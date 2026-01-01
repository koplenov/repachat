class ReactionInfo {
  final String targetMessageId;
  final String emoji;
  final String? reactionKey; // Lightweight key for deduplication: timestamp_senderPrefix

  ReactionInfo({
    required this.targetMessageId,
    required this.emoji,
    this.reactionKey,
  });
}

class ReactionHelper {
  /// Parse reaction format: r:[messageId]:[emoji]
  /// Supports both old format (full messageId) and new format (timestamp_senderPrefix)
  static ReactionInfo? parseReaction(String text) {
    final regex = RegExp(r'^r:([^:]+):(.+)$');
    final match = regex.firstMatch(text);
    if (match == null) return null;

    final targetId = match.group(1)!;
    final emoji = match.group(2)!;

    // Extract reaction key for deduplication
    // If targetId is in new format (timestamp_senderPrefix), use it directly
    // Otherwise, extract timestamp from old format (timestamp_nameHash_textHash)
    String? reactionKey;
    if (targetId.contains('_')) {
      final parts = targetId.split('_');
      if (parts.length >= 2) {
        // New format: timestamp_senderPrefix, or old format with at least timestamp
        reactionKey = '${parts[0]}_${parts[1]}';
      }
    }

    return ReactionInfo(
      targetMessageId: targetId,
      emoji: emoji,
      reactionKey: reactionKey,
    );
  }

  /// Generate a lightweight reaction key for a message
  /// Format: r:[timestamp]_[senderPrefix]:[emoji]
  static String buildReactionText(String timestamp, String senderPrefix, String emoji) {
    return 'r:${timestamp}_$senderPrefix:$emoji';
  }

  /// Extract sender prefix from public key hex (first 8 chars)
  static String getSenderPrefix(String senderKeyHex) {
    return senderKeyHex.substring(0, 8);
  }
}
