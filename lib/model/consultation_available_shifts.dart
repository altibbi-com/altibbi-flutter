class ConsultationAvailableShift {
  final String? day;
  final int? from;
  final int? to;
  final bool? booked;
  final String? fullDate;

  ConsultationAvailableShift({
    this.day,
    this.from,
    this.to,
    this.booked,
    this.fullDate,
  });

  String? shiftValue() => (fullDate?.isNotEmpty == true) ? fullDate : null;

  String displayText() {
    final dayPrefix = (day?.isNotEmpty == true) ? '$day ' : '';
    return (from != null && to != null)
        ? '$dayPrefix$from -> $to'
        : dayPrefix.trim();
  }

  factory ConsultationAvailableShift.fromJson(Map<String, dynamic> json) {
    return ConsultationAvailableShift(
      day: json['day'] as String?,
      from: json['from'] as int?,
      to: json['to'] as int?,
      booked: json['booked'] as bool?,
      fullDate: json['full_date'] as String?,
    );
  }
}

class ConsultationAvailableShifts {
  final List<ConsultationAvailableShift> shifts;

  ConsultationAvailableShifts({required this.shifts});

  factory ConsultationAvailableShifts.fromJson(Map<String, dynamic> json) {
    final List<dynamic> shiftsJson = json['shifts'] as List<dynamic>? ?? [];
    return ConsultationAvailableShifts(
      shifts: shiftsJson
          .map((item) => ConsultationAvailableShift.fromJson(
              item as Map<String, dynamic>))
          .toList(),
    );
  }
}
