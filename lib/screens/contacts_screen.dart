import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meshcore_open/widgets/path_trace_dialog.dart';
import 'package:provider/provider.dart';

import '../connector/meshcore_connector.dart';
import '../l10n/l10n.dart';
import '../connector/meshcore_protocol.dart';
import '../models/contact.dart';
import '../models/contact_group.dart';
import '../storage/contact_group_store.dart';
import '../utils/contact_search.dart';
import '../utils/dialog_utils.dart';
import '../utils/disconnect_navigation_mixin.dart';
import '../utils/emoji_utils.dart';
import '../utils/route_transitions.dart';
import '../widgets/battery_indicator.dart';
import '../widgets/list_filter_widget.dart';
import '../widgets/empty_state.dart';
import '../widgets/quick_switch_bar.dart';
import '../widgets/repeater_login_dialog.dart';
import '../widgets/room_login_dialog.dart';
import '../widgets/unread_badge.dart';
import 'channels_screen.dart';
import 'chat_screen.dart';
import 'map_screen.dart';
import 'repeater_hub_screen.dart';
import 'settings_screen.dart';

enum RoomLoginDestination {
  chat,
  management,
}

class ContactsScreen extends StatefulWidget {
  final bool hideBackButton;

  const ContactsScreen({super.key, this.hideBackButton = false});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen>
    with DisconnectNavigationMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  ContactSortOption _sortOption = ContactSortOption.lastSeen;
  bool _showUnreadOnly = false;
  ContactTypeFilter _typeFilter = ContactTypeFilter.all;
  final ContactGroupStore _groupStore = ContactGroupStore();
  List<ContactGroup> _groups = [];
  Timer? _searchDebounce;
  
  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGroups() async {
    final groups = await _groupStore.loadGroups();
    if (!mounted) return;
    setState(() {
      _groups = groups;
    });
  }

  Future<void> _saveGroups() async {
    await _groupStore.saveGroups(_groups);
  }

  @override
  Widget build(BuildContext context) {
    final connector = context.watch<MeshCoreConnector>();

    // Auto-navigate back to scanner if disconnected
    if (!checkConnectionAndNavigate(connector)) {
      return const SizedBox.shrink();
    }

    final allowBack = !connector.isConnected;
    return PopScope(
      canPop: allowBack,
      child: Scaffold(
        appBar: AppBar(
          leading: BatteryIndicator(connector: connector),
          title: Text(context.l10n.contacts_title),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.bluetooth_disabled),
              tooltip: context.l10n.common_disconnect,
              onPressed: () => _disconnect(context, connector),
            ),
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: context.l10n.common_settings,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
            ),
          ],
        ),
        body: _buildContactsBody(context, connector),
        bottomNavigationBar: SafeArea(
          top: false,
          child: QuickSwitchBar(
            selectedIndex: 0,
            onDestinationSelected: (index) =>
                _handleQuickSwitch(index, context),
          ),
        ),
      ),
    );
  }

  Future<void> _disconnect(
    BuildContext context,
    MeshCoreConnector connector,
  ) async {
    await showDisconnectDialog(context, connector);
  }

  Widget _buildFilterButton(BuildContext context, MeshCoreConnector connector) {
    return ContactsFilterMenu(
      sortOption: _sortOption,
      typeFilter: _typeFilter,
      showUnreadOnly: _showUnreadOnly,
      onSortChanged: (value) {
        setState(() {
          _sortOption = value;
        });
      },
      onTypeFilterChanged: (value) {
        setState(() {
          _typeFilter = value;
        });
      },
      onUnreadOnlyChanged: (value) {
        setState(() {
          _showUnreadOnly = value;
        });
      },
      onNewGroup: () => _showGroupEditor(context, connector.contacts),
    );
  }

  Widget _buildContactsBody(BuildContext context, MeshCoreConnector connector) {
    final contacts = connector.contacts;

    if (contacts.isEmpty && connector.isLoadingContacts && _groups.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contacts.isEmpty && _groups.isEmpty) {
      return EmptyState(
        icon: Icons.people_outline,
        title: context.l10n.contacts_noContacts,
        subtitle: context.l10n.contacts_contactsWillAppear,
      );
    }

    final filteredAndSorted = _filterAndSortContacts(contacts, connector);
    final filteredGroups = _showUnreadOnly
        ? const <ContactGroup>[]
        : _filterAndSortGroups(_groups, contacts);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: context.l10n.contacts_searchContacts,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                  _buildFilterButton(context, connector),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              _searchDebounce?.cancel();
              _searchDebounce = Timer(const Duration(milliseconds: 300), () {
                if (!mounted) return;
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              });
            },
          ),
        ),
        Expanded(
          child: filteredAndSorted.isEmpty && filteredGroups.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        _showUnreadOnly
                            ? context.l10n.contacts_noUnreadContacts
                            : context.l10n.contacts_noContactsFound,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => connector.getContacts(),
                  child: ListView.builder(
                    itemCount: filteredGroups.length + filteredAndSorted.length,
                    itemBuilder: (context, index) {
                      if (index < filteredGroups.length) {
                        final group = filteredGroups[index];
                        return _buildGroupTile(context, group, contacts);
                      }
                      final contact =
                          filteredAndSorted[index - filteredGroups.length];
                      final unreadCount = connector.getUnreadCountForContact(
                        contact,
                      );
                      return _ContactTile(
                        contact: contact,
                        lastSeen: _resolveLastSeen(contact),
                        unreadCount: unreadCount,
                        onTap: () => _openChat(context, contact),
                        onLongPress: () =>
                            _showContactOptions(context, connector, contact),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  List<ContactGroup> _filterAndSortGroups(
    List<ContactGroup> groups,
    List<Contact> contacts,
  ) {
    final query = _searchQuery.trim().toLowerCase();
    final contactsByKey = <String, Contact>{};
    for (final contact in contacts) {
      contactsByKey[contact.publicKeyHex] = contact;
    }

    final filtered = groups
        .where((group) {
          if (query.isEmpty) return true;
          if (group.name.toLowerCase().contains(query)) return true;
          for (final key in group.memberKeys) {
            final contact = contactsByKey[key];
            if (contact != null && matchesContactQuery(contact, query)) {
              return true;
            }
          }
          return false;
        })
        .where((group) {
          if (_typeFilter == ContactTypeFilter.all) return true;
          for (final key in group.memberKeys) {
            final contact = contactsByKey[key];
            if (contact != null && _matchesTypeFilter(contact)) return true;
          }
          return false;
        })
        .toList();

    filtered.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return filtered;
  }

  List<Contact> _filterAndSortContacts(
    List<Contact> contacts,
    MeshCoreConnector connector,
  ) {
    var filtered = contacts.where((contact) {
      if (_searchQuery.isEmpty) return true;
      return matchesContactQuery(contact, _searchQuery);
    }).toList();

    // Filter out own node from the list
    if (connector.selfPublicKey != null) {
      final selfPubKeyHex = pubKeyToHex(connector.selfPublicKey!);
      filtered = filtered.where((contact) {
        return contact.publicKeyHex != selfPubKeyHex;
      }).toList();
    }

    if (_typeFilter != ContactTypeFilter.all) {
      filtered = filtered.where(_matchesTypeFilter).toList();
    }

    if (_showUnreadOnly) {
      filtered = filtered.where((contact) {
        return connector.getUnreadCountForContact(contact) > 0;
      }).toList();
    }

    switch (_sortOption) {
      case ContactSortOption.lastSeen:
        filtered.sort(
          (a, b) => _resolveLastSeen(b).compareTo(_resolveLastSeen(a)),
        );
        break;
      case ContactSortOption.recentMessages:
        filtered.sort((a, b) {
          final aMessages = connector.getMessages(a);
          final bMessages = connector.getMessages(b);
          final aLastMsg = aMessages.isEmpty
              ? DateTime(1970)
              : aMessages.last.timestamp;
          final bLastMsg = bMessages.isEmpty
              ? DateTime(1970)
              : bMessages.last.timestamp;
          return bLastMsg.compareTo(aLastMsg);
        });
        break;
      case ContactSortOption.name:
        filtered.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
    }

    return filtered;
  }

  bool _matchesTypeFilter(Contact contact) {
    switch (_typeFilter) {
      case ContactTypeFilter.all:
        return true;
      case ContactTypeFilter.users:
        return contact.type == advTypeChat;
      case ContactTypeFilter.repeaters:
        return contact.type == advTypeRepeater;
      case ContactTypeFilter.rooms:
        return contact.type == advTypeRoom;
    }
  }

  DateTime _resolveLastSeen(Contact contact) {
    if (contact.type != advTypeChat) return contact.lastSeen;
    return contact.lastMessageAt.isAfter(contact.lastSeen)
        ? contact.lastMessageAt
        : contact.lastSeen;
  }

  Widget _buildGroupTile(
    BuildContext context,
    ContactGroup group,
    List<Contact> contacts,
  ) {
    final memberContacts = _resolveGroupContacts(group, contacts);
    final subtitle = _formatGroupMembers(context, memberContacts);
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.teal,
        child: Icon(Icons.group, color: Colors.white, size: 20),
      ),
      title: Text(group.name),
      subtitle: Text(subtitle),
      trailing: Text(
        memberContacts.length.toString(),
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      onTap: () => _showGroupOptions(context, group, contacts),
      onLongPress: () => _showGroupOptions(context, group, contacts),
    );
  }

  List<Contact> _resolveGroupContacts(
    ContactGroup group,
    List<Contact> contacts,
  ) {
    final byKey = <String, Contact>{};
    for (final contact in contacts) {
      byKey[contact.publicKeyHex] = contact;
    }
    final resolved = <Contact>[];
    for (final key in group.memberKeys) {
      final contact = byKey[key];
      if (contact != null) {
        resolved.add(contact);
      }
    }
    resolved.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return resolved;
  }

  String _formatGroupMembers(BuildContext context, List<Contact> members) {
    if (members.isEmpty) return context.l10n.contacts_noMembers;
    final names = members.map((c) => c.name).toList();
    if (names.length <= 2) return names.join(', ');
    return '${names.take(2).join(', ')} +${names.length - 2}';
  }

  void _openChat(BuildContext context, Contact contact) {
    // Check if this is a repeater
    if (contact.type == advTypeRepeater) {
      _showRepeaterLogin(context, contact);
    } else if (contact.type == advTypeRoom) {
      _showRoomLogin(context, contact, RoomLoginDestination.chat);
    } else {
      context.read<MeshCoreConnector>().markContactRead(contact.publicKeyHex);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen(contact: contact)),
      );
    }
  }

  void _handleQuickSwitch(int index, BuildContext context) {
    if (index == 0) return;
    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          buildQuickSwitchRoute(const ChannelsScreen(hideBackButton: true)),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          buildQuickSwitchRoute(const MapScreen(hideBackButton: true)),
        );
        break;
    }
  }

  void _showRepeaterLogin(BuildContext context, Contact repeater) {
    showDialog(
      context: context,
      builder: (context) => RepeaterLoginDialog(
        repeater: repeater,
        onLogin: (password) {
          // Navigate to repeater hub screen after successful login
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RepeaterHubScreen(repeater: repeater, password: password),
            ),
          );
        },
      ),
    );
  }

  void _showRoomLogin(
    BuildContext context,
    Contact room,
    RoomLoginDestination destination,
  ) {
    showDialog(
      context: context,
      builder: (context) => RoomLoginDialog(
        room: room,
        onLogin: (password) {
          context.read<MeshCoreConnector>().markContactRead(room.publicKeyHex);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => destination == RoomLoginDestination.management
                  ? RepeaterHubScreen(repeater: room, password: password)
                  : ChatScreen(contact: room),
            ),
          );
        },
      ),
    );
  }

  void _showGroupOptions(
    BuildContext context,
    ContactGroup group,
    List<Contact> contacts,
  ) {
    final members = _resolveGroupContacts(group, contacts);
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(context.l10n.contacts_editGroup),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showGroupEditor(context, contacts, group: group);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  context.l10n.contacts_deleteGroup,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _confirmDeleteGroup(context, group);
                },
              ),
              if (members.isNotEmpty) const Divider(),
              ...members.map((member) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(member.name),
                  subtitle: Text(member.typeLabel),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openChat(context, member);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteGroup(BuildContext context, ContactGroup group) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.contacts_deleteGroup),
        content: Text(context.l10n.contacts_deleteGroupConfirm(group.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.common_cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              setState(() {
                _groups.removeWhere((g) => g.name == group.name);
              });
              await _saveGroups();
            },
            child: Text(
              context.l10n.common_delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showGroupEditor(
    BuildContext context,
    List<Contact> contacts, {
    ContactGroup? group,
  }) {
    final isEditing = group != null;
    final nameController = TextEditingController(text: group?.name ?? '');
    final selectedKeys = <String>{...group?.memberKeys ?? []};
    String filterQuery = '';
    final sortedContacts = List<Contact>.from(contacts)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setDialogState) {
          final filteredContacts = filterQuery.isEmpty
              ? sortedContacts
              : sortedContacts
                    .where(
                      (contact) => matchesContactQuery(contact, filterQuery),
                    )
                    .toList();
          return AlertDialog(
            title: Text(
              isEditing
                  ? context.l10n.contacts_editGroup
                  : context.l10n.contacts_newGroup,
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: context.l10n.contacts_groupName,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: context.l10n.contacts_filterContacts,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setDialogState(() {
                        filterQuery = value.toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 240,
                    child: filteredContacts.isEmpty
                        ? Center(
                            child: Text(
                              context.l10n.contacts_noContactsMatchFilter,
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredContacts.length,
                            itemBuilder: (context, index) {
                              final contact = filteredContacts[index];
                              final isSelected = selectedKeys.contains(
                                contact.publicKeyHex,
                              );
                              return CheckboxListTile(
                                value: isSelected,
                                title: Text(contact.name),
                                subtitle: Text(contact.typeLabel),
                                onChanged: (value) {
                                  setDialogState(() {
                                    if (value == true) {
                                      selectedKeys.add(contact.publicKeyHex);
                                    } else {
                                      selectedKeys.remove(contact.publicKeyHex);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(context.l10n.common_cancel),
              ),
              TextButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.contacts_groupNameRequired),
                      ),
                    );
                    return;
                  }
                  final exists = _groups.any((g) {
                    if (isEditing && g.name == group.name) return false;
                    return g.name.toLowerCase() == name.toLowerCase();
                  });
                  if (exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.l10n.contacts_groupAlreadyExists(name),
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() {
                    if (isEditing) {
                      final index = _groups.indexWhere(
                        (g) => g.name == group.name,
                      );
                      if (index != -1) {
                        _groups[index] = ContactGroup(
                          name: name,
                          memberKeys: selectedKeys.toList(),
                        );
                      }
                    } else {
                      _groups.add(
                        ContactGroup(
                          name: name,
                          memberKeys: selectedKeys.toList(),
                        ),
                      );
                    }
                  });
                  await _saveGroups();
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                },
                child: Text(
                  isEditing
                      ? context.l10n.common_save
                      : context.l10n.common_create,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showContactOptions(
    BuildContext context,
    MeshCoreConnector connector,
    Contact contact,
  ) {
    final isRepeater = contact.type == advTypeRepeater;
    final isRoom = contact.type == advTypeRoom;

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isRepeater) ...[
              ListTile(
                leading: const Icon(Icons.radar, color: Colors.green),
                title: contact.pathLength > 0 ? Text(context.l10n.contacts_pathTrace) : Text(context.l10n.contacts_ping),
                onTap: () {
                  showDialog(context: context, builder: (context) {
                    return PathTraceDialog(
                      title: contact.pathLength > 0 ? context.l10n.contacts_repeaterPathTrace : context.l10n.contacts_repeaterPing,
                      path: contact.traceRouteBytes ?? Uint8List(0),
                    );
                  });
                }
              ),
              ListTile(
                leading: const Icon(Icons.cell_tower, color: Colors.orange),
                title: Text(context.l10n.contacts_manageRepeater),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showRepeaterLogin(context, contact);
                },
              )
            ]else if (isRoom) ...[
              ListTile(
                leading: const Icon(Icons.radar, color: Colors.green),
                title: contact.pathLength > 0 ? Text(context.l10n.contacts_pathTrace) : Text(context.l10n.contacts_ping),
                onTap: () {
                  showDialog(context: context, builder: (context) {
                    return PathTraceDialog(
                      title: contact.pathLength > 0 ? context.l10n.contacts_roomPathTrace : context.l10n.contacts_roomPing,
                      path: contact.traceRouteBytes ?? Uint8List(0),
                    );
                  });
                }
              ),
              ListTile(
                leading: const Icon(Icons.room, color: Colors.blue),
                title: Text(context.l10n.contacts_roomLogin),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showRoomLogin(context, contact, RoomLoginDestination.chat);
                },
              ),
              ListTile(
                leading: const Icon(Icons.room_preferences, color: Colors.orange),
                title: Text(context.l10n.room_management),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showRoomLogin(context, contact, RoomLoginDestination.management);
                },
              ),
            ] else ...[
              if(contact.pathLength > 0)
              ListTile(
                leading: const Icon(Icons.radar, color: Colors.green),
                title: Text(context.l10n.contacts_chatTraceRoute),
                onTap: () {
                  showDialog(context: context, builder: (context) {
                    return PathTraceDialog(
                      title: context.l10n.contacts_pathTraceTo(contact.name),
                      path: contact.traceRouteBytes ?? Uint8List(0),
                    );
                  });
                }
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: Text(context.l10n.contacts_openChat),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openChat(context, contact);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                context.l10n.contacts_deleteContact,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _confirmDelete(context, connector, contact);
              },
            ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    MeshCoreConnector connector,
    Contact contact,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.contacts_deleteContact),
        content: Text(context.l10n.contacts_removeConfirm(contact.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.common_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              connector.removeContact(contact);
            },
            child: Text(
              context.l10n.common_delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final Contact contact;
  final DateTime lastSeen;
  final int unreadCount;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ContactTile({
    required this.contact,
    required this.lastSeen,
    required this.unreadCount,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getTypeColor(contact.type),
        child: _buildContactAvatar(contact),
      ),
      title: Text(contact.name),
      subtitle: Text(
        '${contact.typeLabel} • ${contact.pathLabel} ${contact.shortPubKeyHex}',
      ),
      // Clamp text scaling in trailing section to prevent overflow while
      // maintaining accessibility. Primary content (title/subtitle) scales normally.
      trailing: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
            MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (unreadCount > 0) ...[
              UnreadBadge(count: unreadCount),
              const SizedBox(height: 4),
            ],
            Text(
              _formatLastSeen(context, lastSeen),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            if (contact.hasLocation)
              Icon(Icons.location_on, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  Widget _buildContactAvatar(Contact contact) {
    final emoji = firstEmoji(contact.name);
    if (emoji != null) {
      return Text(emoji, style: const TextStyle(fontSize: 18));
    }
    return Icon(_getTypeIcon(contact.type), color: Colors.white, size: 20);
  }

  IconData _getTypeIcon(int type) {
    switch (type) {
      case advTypeChat:
        return Icons.chat;
      case advTypeRepeater:
        return Icons.cell_tower;
      case advTypeRoom:
        return Icons.group;
      case advTypeSensor:
        return Icons.sensors;
      default:
        return Icons.device_unknown;
    }
  }

  Color _getTypeColor(int type) {
    switch (type) {
      case advTypeChat:
        return Colors.blue;
      case advTypeRepeater:
        return Colors.orange;
      case advTypeRoom:
        return Colors.purple;
      case advTypeSensor:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatLastSeen(BuildContext context, DateTime lastSeen) {
    final now = DateTime.now();
    final diff = now.difference(lastSeen);

    if (diff.isNegative || diff.inMinutes < 5) {
      return context.l10n.contacts_lastSeenNow;
    }
    if (diff.inMinutes < 60) {
      return context.l10n.contacts_lastSeenMinsAgo(diff.inMinutes);
    }
    if (diff.inHours < 24) {
      final hours = diff.inHours;
      return hours == 1
          ? context.l10n.contacts_lastSeenHourAgo
          : context.l10n.contacts_lastSeenHoursAgo(hours);
    }
    final days = diff.inDays;
    return days == 1
        ? context.l10n.contacts_lastSeenDayAgo
        : context.l10n.contacts_lastSeenDaysAgo(days);
  }
}
