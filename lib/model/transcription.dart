class Transcription {
  final String transcript;

  Transcription({required this.transcript});

  factory Transcription.fromJson(Map<String, dynamic> json) {
    return Transcription(
      transcript: json['transcript'] as String,
    );
  }
}

