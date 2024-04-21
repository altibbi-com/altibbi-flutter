class User {
  int? id;
  String? name;
  String? phoneNumber;
  String? email;
  String? dateOfBirth;
  String? gender;
  String? insuranceId;
  String? policyNumber;
  String? nationalityNumber;
  int? height;
  int? weight;
  String? bloodType;
  String? smoker;
  String? alcoholic;
  String? relationType;
  String? maritalStatus;
  String? createdAt;
  String? updatedAt;


  User({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.insuranceId,
    this.policyNumber,
    this.nationalityNumber,
    this.height,
    this.weight,
    this.bloodType,
    this.smoker,
    this.alcoholic,
    this.relationType,
    this.maritalStatus,
    this.createdAt,
    this.updatedAt
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    phoneNumber = json['phone_number'] as String?;
    email = json['email'] as String?;
    dateOfBirth = json['date_of_birth'] as String?;
    gender = json['gender'] as String?;
    insuranceId = json['insurance_id'] as String?;
    policyNumber = json['policy_number'] as String?;
    nationalityNumber = json['nationality_number'] as String?;
    height = json['height'] as int?;
    weight = json['weight'] as int?;
    bloodType = json['blood_type'] as String?;
    smoker = json['smoker'] as String?;
    alcoholic = json['alcoholic'] as String?;
    maritalStatus = json['marital_status'] as String?;
    relationType = json['relation_type'] as String?;
    createdAt = json['created_at'] as String?;
    updatedAt = json['updated_at'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'insurance_id': insuranceId,
      'policy_number': policyNumber,
      'nationality_number': nationalityNumber,
      'height': height,
      'weight': weight,
      'blood_type': bloodType,
      'relation_type': relationType,
      'smoker': smoker,
      'alcoholic': alcoholic,
      'marital_status': maritalStatus,
    };
  }


}

