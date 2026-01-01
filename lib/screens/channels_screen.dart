import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../connector/meshcore_connector.dart';
import '../models/channel.dart';
import '../utils/dialog_utils.dart';
import '../utils/disconnect_navigation_mixin.dart';
import '../utils/route_transitions.dart';
import '../widgets/empty_state.dart';
import '../widgets/quick_switch_bar.dart';
import '../widgets/unread_badge.dart';
import 'channel_chat_screen.dart';
import 'contacts_screen.dart';
import 'map_screen.dart';
import 'settings_screen.dart';

class ChannelsScreen extends StatefulWidget {
  final bool hideBackButton;

  const ChannelsScreen({
    super.key,
    this.hideBackButton = false,
  });

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen>
    with DisconnectNavigationMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeshCoreConnector>().getChannels();
    });
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
          title: const Text('Channels'),
          centerTitle: true,
          automaticallyImplyLeading: !widget.hideBackButton && allowBack,
          actions: [
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: 'Settings',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.bluetooth_disabled),
              tooltip: 'Disconnect',
              onPressed: () => _disconnect(context),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<MeshCoreConnector>().getChannels(),
            ),
          ],
        ),
        body: () {
          if (connector.isLoadingChannels) {
            return const Center(child: CircularProgressIndicator());
          }

          final channels = connector.channels;

          if (channels.isEmpty) {
            return EmptyState(
              icon: Icons.tag,
              title: 'No channels configured',
              action: FilledButton.icon(
                onPressed: () => _addPublicChannel(context, connector),
                icon: const Icon(Icons.public),
                label: const Text('Add Public Channel'),
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 88),
            buildDefaultDragHandles: false,
            itemCount: channels.length,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex -= 1;
              final reordered = List<Channel>.from(channels);
              final item = reordered.removeAt(oldIndex);
              reordered.insert(newIndex, item);
              unawaited(
                connector.setChannelOrder(
                  reordered.map((c) => c.index).toList(),
                ),
              );
            },
            itemBuilder: (context, index) {
              final channel = channels[index];
              return _buildChannelTile(context, connector, channel, index);
            },
          );
        }(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddChannelDialog(context),
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: QuickSwitchBar(
            selectedIndex: 1,
            onDestinationSelected: (index) => _handleQuickSwitch(index, context),
          ),
        ),
      ),
    );
  }

  Widget _buildChannelTile(
    BuildContext context,
    MeshCoreConnector connector,
    Channel channel,
    int index,
  ) {
    final unreadCount = connector.getUnreadCountForChannel(channel);
    return Card(
      key: ValueKey('channel_${channel.index}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        dense: true,
        minVerticalPadding: 0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: const VisualDensity(vertical: -2),
        leading: CircleAvatar(
          backgroundColor: channel.isPublicChannel
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.blue.withValues(alpha: 0.2),
          child: Icon(
            channel.isPublicChannel
                ? Icons.public
                : channel.name.startsWith('#')
                    ? Icons.tag
                    : Icons.lock,
            color: channel.isPublicChannel ? Colors.green : Colors.blue,
          ),
        ),
        title: Text(
          channel.name.isEmpty ? 'Channel ${channel.index}' : channel.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          channel.name.startsWith('#')
              ? 'Hashtag channel'
              : channel.isPublicChannel
                  ? 'Public channel'
                  : 'Private channel',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (unreadCount > 0) ...[
              UnreadBadge(count: unreadCount),
              const SizedBox(width: 4),
            ],
            ReorderableDelayedDragStartListener(
              index: index,
              child: Icon(
                Icons.drag_handle,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        onTap: () async {
          connector.markChannelRead(channel.index);
          await Future.delayed(const Duration(milliseconds: 50));
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChannelChatScreen(channel: channel),
              ),
            );
          }
        },
        onLongPress: () => _showChannelActions(context, connector, channel),
      ),
    );
  }

  void _showChannelActions(
    BuildContext context,
    MeshCoreConnector connector,
    Channel channel,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit channel'),
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 100));
                if (context.mounted) {
                  _showEditChannelDialog(context, connector, channel);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete channel', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 100));
                if (context.mounted) {
                  _confirmDeleteChannel(context, connector, channel);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleQuickSwitch(int index, BuildContext context) {
    if (index == 1) return;
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          buildQuickSwitchRoute(
            const ContactsScreen(hideBackButton: true),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          buildQuickSwitchRoute(
            const MapScreen(hideBackButton: true),
          ),
        );
        break;
    }
  }

  Future<void> _disconnect(BuildContext context) async {
    final connector = context.read<MeshCoreConnector>();
    await showDisconnectDialog(context, connector);
  }

  void _showAddChannelDialog(BuildContext context) {
    final connector = context.read<MeshCoreConnector>();
    final nameController = TextEditingController();
    final pskController = TextEditingController();
    final maxChannels = connector.maxChannels;
    int selectedIndex = _findNextAvailableIndex(connector.channels, maxChannels);
    bool usePublicPsk = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Channel'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: selectedIndex,
                  decoration: const InputDecoration(
                    labelText: 'Channel Index',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(maxChannels, (i) => i)
                      .map((i) => DropdownMenuItem(
                            value: i,
                            child: Text('Channel $i'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedIndex = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Channel Name',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 31,
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Use Public Channel'),
                  subtitle: const Text('Standard public PSK'),
                  value: usePublicPsk,
                  onChanged: (value) {
                    setDialogState(() {
                      usePublicPsk = value ?? false;
                      if (usePublicPsk) {
                        nameController.text = 'Public';
                        pskController.text = Channel.publicChannelPsk;
                      } else {
                        pskController.clear();
                      }
                    });
                  },
                ),
                if (!usePublicPsk) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: pskController,
                    decoration: InputDecoration(
                      labelText: 'PSK (Hex)',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.casino),
                        tooltip: 'Generate random PSK',
                        onPressed: () {
                          final random = Random.secure();
                          final bytes = Uint8List(16);
                          for (int i = 0; i < 16; i++) {
                            bytes[i] = random.nextInt(256);
                          }
                          pskController.text = Channel.formatPskHex(bytes);
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final pskHex = usePublicPsk
                    ? Channel.publicChannelPsk
                    : pskController.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a channel name')),
                  );
                  return;
                }

                Uint8List psk;
                try {
                  psk = Channel.parsePskHex(pskHex);
                } on FormatException {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PSK must be 32 hex characters')),
                  );
                  return;
                }

                Navigator.pop(context);
                connector.setChannel(selectedIndex, name, psk);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Channel "$name" added')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditChannelDialog(
    BuildContext context,
    MeshCoreConnector connector,
    Channel channel,
  ) {
    final nameController = TextEditingController(text: channel.name);
    final pskController = TextEditingController(text: channel.pskHex);
    bool smazEnabled = connector.isChannelSmazEnabled(channel.index);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Edit Channel ${channel.index}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Channel Name',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 31,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: pskController,
                  decoration: InputDecoration(
                    labelText: 'PSK (Hex)',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.casino),
                      tooltip: 'Generate random PSK',
                      onPressed: () {
                        final random = Random.secure();
                        final bytes = Uint8List(16);
                        for (int i = 0; i < 16; i++) {
                          bytes[i] = random.nextInt(256);
                        }
                        pskController.text = Channel.formatPskHex(bytes);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('SMAZ compression'),
                  value: smazEnabled,
                  onChanged: (value) => setState(() => smazEnabled = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final pskHex = pskController.text.trim();

                Uint8List psk;
                try {
                  psk = Channel.parsePskHex(pskHex);
                } on FormatException {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PSK must be 32 hex characters')),
                  );
                  return;
                }

                Navigator.pop(context);
                connector.setChannel(channel.index, name, psk);
                connector.setChannelSmazEnabled(channel.index, smazEnabled);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Channel "$name" updated')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteChannel(
    BuildContext context,
    MeshCoreConnector connector,
    Channel channel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Channel'),
        content: Text('Delete "${channel.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              connector.deleteChannel(channel.index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Channel "${channel.name}" deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addPublicChannel(BuildContext context, MeshCoreConnector connector) {
    final psk = Channel.parsePskHex(Channel.publicChannelPsk);
    connector.setChannel(0, 'Public', psk);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Public channel added')),
    );
  }

  int _findNextAvailableIndex(List<Channel> channels, int maxChannels) {
    final usedIndices = channels.map((c) => c.index).toSet();
    for (int i = 0; i < maxChannels; i++) {
      if (!usedIndices.contains(i)) return i;
    }
    return 0;
  }
}
