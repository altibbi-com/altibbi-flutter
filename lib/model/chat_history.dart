
class ChatHistory {
  ChatHistory({
    this.id,
    this.consultationId,
    this.data,
    this.createdAt,
    this.updatedAt,
  });
  late final int? id;
  late final int? consultationId;
  late final List<Data>? data;
  late final String? createdAt;
  late final String? updatedAt;

  ChatHistory.fromJson(Map<String, dynamic> json){
    id = json['id'];
    consultationId = json['consultation_id'];
    data = json['data'] != null ? List.from(json['data']).map((e)=>Data.fromJson(e)).toList() : null ;
    createdAt = json['created_at'];
    updatedAt = null;
  }
}

class Data {
  Data({
     this.id,
     this.message,
     this.sentAt,
     this.chatUserId,
  });

  late final String? id;
  late final String? message;
  late final String? sentAt;
  late final String? chatUserId;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    message = json['message'];
    sentAt = json['sent_at'];
    chatUserId = json['chat_user_id'];
  }

}