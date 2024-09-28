class Soap {
  final Summary summary;

  Soap({required this.summary});

  factory Soap.fromJson(Map<String, dynamic> json) {
    return Soap(
      summary: Summary.fromJson(json['summary'] as Map<String, dynamic>),
    );
  }
}

class Summary {
  final Subjective subjective;
  final Objective objective;
  final Assessment assessment;
  final Plan plan;

  Summary({
    required this.subjective,
    required this.objective,
    required this.assessment,
    required this.plan,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      subjective: Subjective.fromJson(json['subjective'] as Map<String, dynamic>),
      objective: Objective.fromJson(json['objective'] as Map<String, dynamic>),
      assessment: Assessment.fromJson(json['assessment'] as Map<String, dynamic>),
      plan: Plan.fromJson(json['plan'] as Map<String, dynamic>),
    );
  }
}

class Subjective {
  final String? symptoms;
  final String? concerns;

  Subjective({this.symptoms, this.concerns});

  factory Subjective.fromJson(Map<String, dynamic> json) {
    return Subjective(
      symptoms: json['symptoms'] as String?,
      concerns: json['concerns'] as String?,
    );
  }
}

class Objective {
  final String? laboratoryResults;
  final String? physicalExaminationFindings;

  Objective({this.laboratoryResults, this.physicalExaminationFindings});

  factory Objective.fromJson(Map<String, dynamic> json) {
    return Objective(
      laboratoryResults: json['laboratory_results'] as String?,
      physicalExaminationFindings: json['physical_examination_findings'] as String?,
    );
  }
}

class Assessment {
  final String? diagnosis;
  final String? differentialDiagnosis;

  Assessment({this.diagnosis, this.differentialDiagnosis});

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      diagnosis: json['diagnosis'] as String?,
      differentialDiagnosis: json['differential_diagnosis'] as String?,
    );
  }
}

class Plan {
  final String? nonPharmacologicalIntervention;
  final String? medications;
  final String? referrals;
  final String? followUpInstructions;

  Plan({
    this.nonPharmacologicalIntervention,
    this.medications,
    this.referrals,
    this.followUpInstructions,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      nonPharmacologicalIntervention: json['non_pharmacological_intervention'] as String?,
      medications: json['medications'] as String?,
      referrals: json['referrals'] as String?,
      followUpInstructions: json['follow_up_instructions'] as String?,
    );
  }
}