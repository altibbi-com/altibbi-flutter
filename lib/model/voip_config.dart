class VoipConfig {
  int? id;
  int? consultationId;
  String? apiKey;
  String? callId;
  String? token;

  VoipConfig({
    this.id,
    this.consultationId,
    this.apiKey,
    this.callId,
    this.token,
  });

  factory VoipConfig.fromJson(Map<String, dynamic> json) {
    return VoipConfig(
      id: json['id'] as int?,
      consultationId: json['consultation_id'] as int?,
      apiKey: json['api_key'] as String?,
      callId: json['call_id'] as String?,
      token: json['token'] as String?,
    );
  }
}