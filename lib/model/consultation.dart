
import 'package:altibbi/model/media.dart';
import 'package:altibbi/model/recommendation.dart';
import 'package:altibbi/model/user.dart';
import 'package:altibbi/model/voip_config.dart';

import 'chat_config.dart';
import 'chat_history.dart';

class Consultation {
  int? id;
  int? userId;
  String? question;
  String? doctorName;
  String? doctorAvatar;
  String? medium;
  String? status;
  int? isFulfilled;
  int? parentConsultationId;
  String? createdAt;
  String? updatedAt;
  User? user;
  Consultation? parentConsultation;
  List<Media>? media;
  List<Consultation>? consultations;
  String? pusherChannel;
  String? pusherApiKey;
  ChatConfig? chatConfig;
  VoipConfig? voipConfig;
  VoipConfig? videoConfig;
  ChatHistory? chatHistory;
  Recommendation? recommendation;
  double?  doctorAverageRating;


  Consultation({
    this.id,
    this.userId,
    this.question,
    this.medium,
    this.status,
    this.isFulfilled,
    this.parentConsultationId,
    this.createdAt,
    this.updatedAt,
    this.parentConsultation,
    this.media,
    this.user,
    this.consultations,
    this.pusherChannel,
    this.pusherApiKey,
    this.chatConfig,
    this.voipConfig,
    this.videoConfig,
    this.chatHistory,
    this.recommendation,
    this.doctorName,
    this.doctorAvatar,
    this.doctorAverageRating,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] as int?,
      recommendation: json['recommendation'] != null ? Recommendation.fromJson(json['recommendation']) : null ,
      userId: json['user_id'] as int?,
      question: json['question'] as String?,
      doctorName: json['doctor_name'] as String?,
      doctorAvatar: json['doctor_avatar'] as String?,
      medium: json['medium'] as String?,
      status: json['status'] as String?,
      isFulfilled: json['is_fulfilled'] as int?,
      parentConsultationId: json['parent_consultation_id'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      parentConsultation: json['parentConsultation'] != null
          ? Consultation.fromJson(
          json['parentConsultation'] as Map<String, dynamic>)
          : null,
      media: json['media'] != null? (json['media'] as List<dynamic>).map((item) =>
          Media.fromJson(item as Map<String,dynamic>)).toList() : null,
      user: json['user'] != null ? User.fromJson(
          json['user'] as Map<String, dynamic>) : null,
      consultations: (json['consultations'] as List<dynamic>?)
          ?.map((item) => Consultation.fromJson(item as Map<String, dynamic>))
          .toList(),
      pusherChannel: json['pusherChannel'] as String?,
      doctorAverageRating: json['doctor_average_rating'] as double?,
      pusherApiKey: json['pusherAppKey'] as String?,
      chatConfig: json['chatConfig'] != null ? ChatConfig.fromJson(
          json['chatConfig'] as Map<String, dynamic>) : null,
      voipConfig: json['voipConfig'] != null ? VoipConfig.fromJson(
          json['voipConfig'] as Map<String, dynamic>) : null,
      chatHistory: json['chatHistory'] != null ? ChatHistory.fromJson(
          json['chatHistory'] as Map<String, dynamic>) : null,
      videoConfig: json['videoConfig'] != null ? VoipConfig.fromJson(
          json['videoConfig'] as Map<String, dynamic>) : null,
    );
  }


}
