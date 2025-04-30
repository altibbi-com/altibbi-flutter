class ChatResponse {
  final ChatMessage userMessage;
  final ChatMessage sinaMessage;

  ChatResponse({
    required this.userMessage,
    required this.sinaMessage,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      userMessage: ChatMessage.fromJson(json['user_message'] as Map<String, dynamic>),
      sinaMessage: ChatMessage.fromJson(json['sina_message'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_message': userMessage.toJson(),
    'sina_message': sinaMessage.toJson(),
  };
}

class ChatMessage {
  final int id;
  final String sender;
  final String text;
  final String chatId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic media;
  final MessageData? data;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.chatId,
    required this.createdAt,
    required this.updatedAt,
    this.media,
    this.data,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int,
      sender: json['sender'] as String,
      text: json['text'] as String,
      chatId: json['chat_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      media: json['media'], // keep dynamic, or cast if you know the type
      data: json['data'] != null
          ? MessageData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'id': id,
      'sender': sender,
      'text': text,
      'chat_id': chatId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'media': media,
    };
    if (data != null) {
      result['data'] = data!.toJson();
    }
    return result;
  }
}

class MessageData {
  final String contentType;
  final bool foundInRag;
  final List<dynamic> links;

  MessageData({
    required this.contentType,
    required this.foundInRag,
    required this.links,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      contentType: json['content_type'] as String,
      foundInRag: json['found_in_rag'] as bool,
      links: json['links'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() => {
    'content_type': contentType,
    'found_in_rag': foundInRag,
    'links': links,
  };
}