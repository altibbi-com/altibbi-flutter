class Chat {
  String? id;
  String? createdAt;
  String? updatedAt;
  Chat({
    this.id,
    this.createdAt,
    this.updatedAt
  });
  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    createdAt = json['created_at'] as String?;
    updatedAt = json['updated_at'] as String?;
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id
    };
  }
}