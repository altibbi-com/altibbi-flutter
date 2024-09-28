class PredictSummary {
  final String summary;

  PredictSummary({required this.summary});

  factory PredictSummary.fromJson(Map<String, dynamic> json) {
    return PredictSummary(
      summary: json['summary'] as String,
    );
  }
}