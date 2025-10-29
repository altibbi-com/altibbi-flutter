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

  final Map<String, dynamic>? data;

  final String? languageUsed;
  final List<dynamic>? tags;
  final String? contentType;
  final bool? foundInRag;
  final List<dynamic>? links;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.chatId,
    required this.createdAt,
    required this.updatedAt,
    this.media,
    this.data,
    this.languageUsed,
    this.tags,
    this.contentType,
    this.foundInRag,
    this.links,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? dataJson =
    json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : null;

    return ChatMessage(
      id: json['id'] as int,
      sender: json['sender'] as String,
      text: json['text'] as String,
      chatId: json['chat_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      media: json['media'],
      data: dataJson == null ? null : Map<String, dynamic>.from(dataJson),
      languageUsed: dataJson?['language_used'] as String?,
      tags: (dataJson?['tags'] as List?)?.cast<dynamic>(),
      contentType: dataJson?['content_type'] as String?,
      foundInRag: dataJson?['found_in_rag'] as bool?,
      links: (dataJson?['links'] as List?)?.cast<dynamic>(),
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

    Map<String, dynamic>? dataMap = data == null ? null : Map<String, dynamic>.from(data!);

    void put(String key, dynamic value) {
      if (value != null) {
        dataMap ??= <String, dynamic>{};
        dataMap![key] = value;
      }
    }

    put('language_used', languageUsed);
    put('tags', tags);
    put('content_type', contentType);
    put('found_in_rag', foundInRag);
    put('links', links);

    if (dataMap != null) {
      result['data'] = dataMap;
    }

    return result;
  }
}