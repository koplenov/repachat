import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../connector/meshcore_connector.dart';
import '../connector/meshcore_protocol.dart';
import '../helpers/utf8_length_limiter.dart';
import '../models/channel.dart';
import '../models/channel_message.dart';
import '../utils/emoji_utils.dart';
import '../widgets/emoji_picker.dart';
import '../widgets/gif_message.dart';
import '../widgets/gif_picker.dart';
import 'channel_message_path_screen.dart';
import 'map_screen.dart';

class ChannelChatScreen extends StatefulWidget {
  final Channel channel;

  const ChannelChatScreen({
    super.key,
    required this.channel,
  });

  @override
  State<ChannelChatScreen> createState() => _ChannelChatScreenState();
}

class _ChannelChatScreenState extends State<ChannelChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ChannelMessage? _replyingToMessage;
  final Map<String, GlobalKey> _messageKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MeshCoreConnector>().setActiveChannel(widget.channel.index);
    });
  }

  @override
  void dispose() {
    context.read<MeshCoreConnector>().setActiveChannel(null);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _setReplyingTo(ChannelMessage message) {
    setState(() {
      _replyingToMessage = message;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingToMessage = null;
    });
  }

  Future<void> _scrollToMessage(String messageId) async {
    final key = _messageKeys[messageId];
    if (key == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Original message not found'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final targetContext = key.currentContext;
    if (targetContext == null) return;

    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              widget.channel.isPublicChannel ? Icons.public : Icons.tag,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.channel.name.isEmpty
                        ? 'Channel ${widget.channel.index}'
                        : widget.channel.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Consumer<MeshCoreConnector>(
                    builder: (context, connector, _) {
                      final unreadCount =
                          connector.getUnreadCountForChannelIndex(widget.channel.index);
                      final privacy = widget.channel.isPublicChannel ? 'Public' : 'Private';
                      return Text(
                        '$privacy • Unread: $unreadCount',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Consumer<MeshCoreConnector>(
                builder: (context, connector, child) {
                  final messages = connector.getChannelMessages(widget.channel);

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.channel.isPublicChannel
                                ? Icons.public
                                : Icons.tag,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No messages yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Send a message to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      if (!_messageKeys.containsKey(message.messageId)) {
                        _messageKeys[message.messageId] = GlobalKey();
                      }
                      return Container(
                        key: _messageKeys[message.messageId]!,
                        child: _buildMessageBubble(message),
                      );
                    },
                  );
                },
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChannelMessage message) {
    final isOutgoing = message.isOutgoing;
    final gifId = _parseGifId(message.text);
    final poi = _parsePoiMessage(message.text);
    final displayPath = message.pathBytes.isNotEmpty
        ? message.pathBytes
        : (message.pathVariants.isNotEmpty ? message.pathVariants.first : Uint8List(0));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: isOutgoing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isOutgoing ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isOutgoing) ...[
                _buildAvatar(message.senderName),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: GestureDetector(
                  onTap: () => _showMessagePathInfo(message),
                  onLongPress: () => _showMessageActions(message),
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                decoration: BoxDecoration(
                  color: isOutgoing
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isOutgoing) ...[
                      Text(
                        message.senderName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (message.replyToMessageId != null) ...[
                      _buildReplyPreview(message),
                      const SizedBox(height: 8),
                    ],
                    if (poi != null)
                      _buildPoiMessage(context, poi, isOutgoing)
                    else if (gifId != null)
                      GifMessage(
                        url: 'https://media.giphy.com/media/$gifId/giphy.gif',
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        fallbackTextColor: isOutgoing
                            ? Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      )
                    else
                      Text(
                        message.text,
                        style: const TextStyle(fontSize: 14),
                      ),
                    if (displayPath.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'via ${_formatPathPrefixes(displayPath)}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (message.repeatCount > 0) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.repeat, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 2),
                          Text(
                            '${message.repeatCount}',
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                        ],
                        if (isOutgoing) ...[
                          const SizedBox(width: 4),
                          Icon(
                            message.status == ChannelMessageStatus.sent
                                ? Icons.check
                                : message.status == ChannelMessageStatus.pending
                                    ? Icons.schedule
                                    : Icons.error_outline,
                            size: 14,
                            color: message.status == ChannelMessageStatus.failed
                                ? Colors.red
                                : Colors.grey[600],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
            ],
          ),
          if (message.reactions.isNotEmpty) ...[
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(left: isOutgoing ? 0 : 48),
              child: _buildReactionsDisplay(message),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyPreview(ChannelMessage message) {
    final connector = context.read<MeshCoreConnector>();
    final isOwnNode = message.replyToSenderName == connector.selfName;
    final replyText = message.replyToText ?? '';

    final gifId = _parseGifId(replyText);
    final poi = _parsePoiMessage(replyText);

    Widget contentPreview;
    if (gifId != null) {
      contentPreview = Row(
        children: [
          Icon(Icons.gif_box, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text('GIF', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      );
    } else if (poi != null) {
      contentPreview = Row(
        children: [
          Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text('Location', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      );
    } else {
      contentPreview = Text(
        replyText,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _scrollToMessage(message.replyToMessageId!),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reply to ${message.replyToSenderName}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isOwnNode
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            contentPreview,
          ],
        ),
      ),
    );
  }

  Widget _buildReactionsDisplay(ChannelMessage message) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: message.reactions.entries.map((entry) {
        final emoji = entry.key;
        final count = entry.value;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 16),
              ),
              if (count > 1) ...[
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  String? _parseGifId(String text) {
    final trimmed = text.trim();
    final match = RegExp(r'^g:([A-Za-z0-9_-]+)$').firstMatch(trimmed);
    return match?.group(1);
  }

  _PoiInfo? _parsePoiMessage(String text) {
    final trimmed = text.trim();
    final match = RegExp(r'm:([\-0-9.]+),([\-0-9.]+)\|([^|]*)\|').firstMatch(trimmed);
    if (match == null) return null;
    final lat = double.tryParse(match.group(1) ?? '');
    final lon = double.tryParse(match.group(2) ?? '');
    if (lat == null || lon == null) return null;
    final label = match.group(3) ?? '';
    return _PoiInfo(lat: lat, lon: lon, label: label);
  }

  Widget _buildPoiMessage(BuildContext context, _PoiInfo poi, bool isOutgoing) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor =
        isOutgoing ? colorScheme.onPrimaryContainer : colorScheme.onSurface;
    final metaColor = textColor.withValues(alpha: 0.7);
    final channelColor = widget.channel.isPublicChannel ? Colors.orange : Colors.blue;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.location_on_outlined, color: channelColor),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreen(
                  highlightPosition: LatLng(poi.lat, poi.lon),
                  highlightLabel: poi.label,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'POI Shared',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (poi.label.isNotEmpty)
                Text(
                  poi.label,
                  style: TextStyle(
                    color: metaColor,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showGifPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => GifPicker(
        onGifSelected: (gifId) {
          _textController.text = 'g:$gifId';
        },
      ),
    );
  }

  Widget _buildAvatar(String senderName) {
    final initial = _getFirstCharacterOrEmoji(senderName);
    final color = _getColorForName(senderName);

    return CircleAvatar(
      radius: 18,
      backgroundColor: color.withValues(alpha: 0.2),
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _getFirstCharacterOrEmoji(String name) {
    if (name.isEmpty) return '?';

    final emoji = firstEmoji(name);
    if (emoji != null) return emoji;

    final runes = name.runes.toList();
    if (runes.isEmpty) return '?';
    return String.fromCharCode(runes[0]).toUpperCase();
  }

  Color _getColorForName(String name) {
    // Generate a consistent color based on the name hash
    final hash = name.hashCode;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
      Colors.amber,
      Colors.deepOrange,
    ];

    return colors[hash.abs() % colors.length];
  }

  Widget _buildReplyBanner() {
    final message = _replyingToMessage!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.reply,
            size: 18,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to ${message.senderName}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Text(
                  message.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: _cancelReply,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    final connector = context.watch<MeshCoreConnector>();
    final maxBytes = maxChannelMessageBytes(connector.selfName);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_replyingToMessage != null) _buildReplyBanner(),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.gif_box),
            onPressed: () => _showGifPicker(context),
            tooltip: 'Send GIF',
          ),
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _textController,
              builder: (context, value, child) {
                final gifId = _parseGifId(value.text);
                if (gifId != null) {
                  return Row(
                    children: [
                      Expanded(
                        child: GifMessage(
                          url: 'https://media.giphy.com/media/$gifId/giphy.gif',
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainerHighest,
                          fallbackTextColor:
                              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          width: 160,
                          height: 110,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _textController.clear(),
                      ),
                    ],
                  );
                }

                return TextField(
                  controller: _textController,
                  inputFormatters: [
                    Utf8LengthLimitingTextInputFormatter(maxBytes),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final connector = context.read<MeshCoreConnector>();

    String messageText = text;
    if (_replyingToMessage != null) {
      messageText = '@[${_replyingToMessage!.senderName}] $text';
    }

    final maxBytes = maxChannelMessageBytes(connector.selfName);
    if (utf8.encode(messageText).length > maxBytes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message too long (max $maxBytes bytes).')),
      );
      return;
    }

    connector.sendChannelMessage(widget.channel, messageText);
    _textController.clear();
    _cancelReply();
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays > 0) {
      return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showMessagePathInfo(ChannelMessage message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChannelMessagePathScreen(message: message),
      ),
    );
  }

  void _showMessageActions(ChannelMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(sheetContext);
                _setReplyingTo(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_reaction_outlined),
              title: const Text('Add Reaction'),
              onTap: () {
                Navigator.pop(sheetContext);
                _showEmojiPicker(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(sheetContext);
                _copyMessageText(message.text);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete'),
              onTap: () async {
                Navigator.pop(sheetContext);
                await _deleteMessage(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(sheetContext),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmojiPicker(ChannelMessage message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EmojiPicker(
        onEmojiSelected: (emoji) {
          _sendReaction(message, emoji);
        },
      ),
    );
  }

  void _sendReaction(ChannelMessage message, String emoji) {
    final connector = context.read<MeshCoreConnector>();
    final reactionText = 'r:${message.messageId}:$emoji';
    connector.sendChannelMessage(widget.channel, reactionText);
  }

  void _copyMessageText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message copied')),
    );
  }

  Future<void> _deleteMessage(ChannelMessage message) async {
    await context.read<MeshCoreConnector>().deleteChannelMessage(message);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message deleted')),
    );
  }

  String _formatPathPrefixes(Uint8List pathBytes) {
    return pathBytes
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(',');
  }
}

class _PoiInfo {
  final double lat;
  final double lon;
  final String label;

  const _PoiInfo({
    required this.lat,
    required this.lon,
    required this.label,
  });
}
