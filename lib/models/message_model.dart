enum MessageSender {
  user,
  bot,
  agent,
  system,
}

class MessageModel {
  final String id;
  final String content;
  final DateTime timestamp;
  final MessageSender sender;
  final String? senderName;

  MessageModel({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.sender,
    this.senderName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'sender': sender.name,
      'senderName': senderName,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sender: MessageSender.values.byName(json['sender'] as String? ?? 'user'),
      senderName: json['senderName'] as String?,
    );
  }
}
