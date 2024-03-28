class Recommendation {
  int? id;
  int? consultationId;
  RecommendationData? data;
  String? createdAt;
  String? updatedAt;

  Recommendation({
    this.id,
    this.consultationId,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'],
      consultationId: json['consultation_id'],
      data: json['data'] != null ? RecommendationData.fromJson(json['data']) : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class RecommendationData {
  RecommendationLab? lab;
  RecommendationDrug? drug;
  RecommendationICD10? icd10;
  List<RecommendationFollowUp>? followUp;
  RecommendationDoctorReferral? doctorReferral;
  List<RecommendationPostCallAnswer>? postCallAnswer;

  RecommendationData({
     this.lab,
     this.drug,
     this.icd10,
     this.followUp,
     this.doctorReferral,
     this.postCallAnswer,
  });

  factory RecommendationData.fromJson(Map<String, dynamic> json) {
    return RecommendationData(
      lab: json['lab'] != null ? RecommendationLab.fromJson(json['lab']) :null ,
      drug: json['drug'] != null ?RecommendationDrug.fromJson(json['drug']):null ,
      icd10: json['icd10'] != null ?RecommendationICD10.fromJson(json['icd10']):null ,
      followUp: json['followUp'] != null ?(json['followUp'] as List<dynamic>)
          .map((item) => RecommendationFollowUp.fromJson(item))
          .toList():null ,
      doctorReferral: json['doctorReferral'] != null ?RecommendationDoctorReferral.fromJson(json['doctorReferral']):null ,
      postCallAnswer: json['postCallAnswer'] != null ?(json['postCallAnswer'] as List<dynamic>)
          .map((item) => RecommendationPostCallAnswer.fromJson(item))
          .toList(): null ,
    );
  }
}

class RecommendationLab {
  List<RecommendationLabItem>? lab;
  List<RecommendationLabItem>? panel;

  RecommendationLab({
    this.lab,
    this.panel,
  });

  factory RecommendationLab.fromJson(Map<String, dynamic> json) {
    return RecommendationLab(
      lab: json['lab'] != null ? (json['lab'] as List<dynamic>)
          .map((item) => RecommendationLabItem.fromJson(item))
          .toList() : null ,
      panel: json['panel'] != null ? (json['panel'] as List<dynamic>)
          .map((item) => RecommendationLabItem.fromJson(item))
          .toList() : null ,
    );
  }
}

class RecommendationLabItem {
  String? name;

  RecommendationLabItem({
    this.name,
  });

  factory RecommendationLabItem.fromJson(Map<String, dynamic> json) {
    return RecommendationLabItem(
      name: json['name'],
    );
  }
}

class RecommendationDrug {
  List<RecommendationFdaDrug>? fdaDrug;

  RecommendationDrug({
    this.fdaDrug,
  });

  factory RecommendationDrug.fromJson(Map<String, dynamic> json) {
    return RecommendationDrug(
      fdaDrug: json['fdaDrug'] != null ? (json['fdaDrug'] as List<dynamic>)
          .map((item) => RecommendationFdaDrug.fromJson(item))
          .toList() : null,
    );
  }
}

class RecommendationFdaDrug {
  String? name;
  String? dosage;
  int? duration;
  String? howToUse;
  String? frequency;
  String? tradeName;
  String? dosageForm;
  String? dosageUnit;
  String? packageSize;
  String? packageType;
  String? strengthValue;
  String? relationWithFood;
  String? specialInstructions;
  String? routeOfAdministration;
  String? registrationNumber;

  RecommendationFdaDrug({
     this.name,
     this.dosage,
     this.duration,
     this.howToUse,
     this.frequency,
     this.tradeName,
     this.dosageForm,
     this.dosageUnit,
     this.packageSize,
     this.packageType,
     this.strengthValue,
     this.relationWithFood,
     this.specialInstructions,
     this.routeOfAdministration,
     this.registrationNumber,
  });

  factory RecommendationFdaDrug.fromJson(Map<String, dynamic> json) {
    return RecommendationFdaDrug(
      name: json['name'],
      dosage: json['dosage'],
      duration: json['duration'],
      howToUse: json['howToUse'],
      frequency: json['frequency'],
      tradeName: json['tradeName'],
      dosageForm: json['dosageForm'],
      dosageUnit: json['dosageUnit'],
      packageSize: json['packageSize'],
      packageType: json['packageType'],
      strengthValue: json['strengthValue'],
      relationWithFood: json['relationWithFood'],
      specialInstructions: json['specialInstructions'],
      routeOfAdministration: json['routeOfAdministration'],
      registrationNumber: json['registrationNumber'],
    );
  }
}

class RecommendationICD10 {
  List<RecommendationSymptom>? symptom;
  List<RecommendationDiagnosis>? diagnosis;

  RecommendationICD10({
     this.symptom,
     this.diagnosis,
  });

  factory RecommendationICD10.fromJson(Map<String, dynamic> json) {
    return RecommendationICD10(
      symptom:json['symptom']!= null ?(json['symptom'] as List<dynamic>)
          .map((item) => RecommendationSymptom.fromJson(item))
          .toList() : null ,
      diagnosis: json['diagnosis']!= null ? (json['diagnosis'] as List<dynamic>)
          .map((item) => RecommendationDiagnosis.fromJson(item))
          .toList() : null,
    );
  }
}

class RecommendationSymptom {
  String? code;
  String? name;

  RecommendationSymptom({
     this.code,
     this.name,
  });

  factory RecommendationSymptom.fromJson(Map<String, dynamic> json) {
    return RecommendationSymptom(
      code: json['code'],
      name: json['name'],
    );
  }
}

class RecommendationDiagnosis {
  String? code;
  String? name;

  RecommendationDiagnosis({
     this.code,
     this.name,
  });

  factory RecommendationDiagnosis.fromJson(Map<String, dynamic> json) {
    return RecommendationDiagnosis(
      code: json['code'],
      name: json['name'],
    );
  }
}

class RecommendationFollowUp {
  String? name;

  RecommendationFollowUp({
     this.name,
  });

  factory RecommendationFollowUp.fromJson(Map<String, dynamic> json) {
    return RecommendationFollowUp(
      name: json['name'],
    );
  }
}

class RecommendationDoctorReferral {
  String? name;

  RecommendationDoctorReferral({
    this.name,
  });

  factory RecommendationDoctorReferral.fromJson(Map<String, dynamic> json) {
    return RecommendationDoctorReferral(
      name: json['name'],
    );
  }
}

class RecommendationPostCallAnswer {
  String? answer;
  String? question;

  RecommendationPostCallAnswer({
     this.answer,
     this.question,
  });

  factory RecommendationPostCallAnswer.fromJson(Map<String, dynamic> json) {
    return RecommendationPostCallAnswer(
      answer: json['answer'],
      question: json['question'],
    );
  }
}
