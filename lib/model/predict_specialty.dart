class PredictSpecialty {
  final int specialtyId;

  PredictSpecialty({required this.specialtyId});

  factory PredictSpecialty.fromJson(Map<String, dynamic> json) {
    return PredictSpecialty(
      specialtyId: json['specialty_id'] as int,
    );
  }
}
