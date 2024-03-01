class VideoData {
  int? consultationId;
  String? apiKey;
  String? callId;
  String? token;
  int? id;

  VideoData(
      {this.consultationId, this.apiKey, this.callId, this.token, this.id});

  VideoData.fromJson(Map<String, dynamic> json) {
    consultationId = json['consultation_id'];
    apiKey = json['api_key'];
    callId = json['call_id'];
    token = json['token'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consultation_id'] = this.consultationId;
    data['api_key'] = this.apiKey;
    data['call_id'] = this.callId;
    data['token'] = this.token;
    data['id'] = this.id;
    return data;
  }
}
