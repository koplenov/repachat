class ReactionInfo {
  final String targetMessageId;
  final String emoji;

  ReactionInfo({
    required this.targetMessageId,
    required this.emoji,
  });
}

class ReactionHelper {
  /// Parse reaction format: r:[messageId]:[emoji]
  static ReactionInfo? parseReaction(String text) {
    final regex = RegExp(r'^r:([^:]+):(.+)$');
    final match = regex.firstMatch(text);
    if (match == null) return null;
    return ReactionInfo(
      targetMessageId: match.group(1)!,
      emoji: match.group(2)!,
    );
  }
}
