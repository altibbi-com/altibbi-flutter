class ChatConfig {
  int? id;
  int? consultationId;
  String? groupId;
  String? chatUserId;
  String? appId;
  String? chatUserToken;

  ChatConfig({
    this.id,
    this.consultationId,
    this.groupId,
    this.appId,
    this.chatUserId,
    this.chatUserToken,
  });

  factory ChatConfig.fromJson(Map<String, dynamic> json) {
    return ChatConfig(
      id: json['id'] as int?,
      consultationId: json['consultation_id'] as int?,
      groupId: json['group_id'] as String?,
      appId: json['app_id'] as String?,
      chatUserId: json['chat_user_id'] as String?,
      chatUserToken: json['chat_user_token'] as String?,
    );
  }
}

