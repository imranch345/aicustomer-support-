import 'message_model.dart';

enum TicketStatus {
  open,
  inProgress,
  pending,
  resolved,
  closed,
}

enum TicketPriority {
  low,
  medium,
  high,
  urgent,
}

class TicketModel {
  final String id;
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final String? assignedAgentId;
  final List<MessageModel> messages;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.assignedAgentId,
    this.messages = const [],
  });

  TicketModel copyWith({
    String? id,
    String? title,
    String? description,
    TicketStatus? status,
    TicketPriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    String? assignedAgentId,
    List<MessageModel>? messages,
  }) {
    return TicketModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      assignedAgentId: assignedAgentId ?? this.assignedAgentId,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'assignedAgentId': assignedAgentId,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: TicketStatus.values.byName(json['status'] as String? ?? 'open'),
      priority: TicketPriority.values.byName(json['priority'] as String? ?? 'medium'),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String,
      assignedAgentId: json['assignedAgentId'] as String?,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
