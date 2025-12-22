class AIPrediction {
  final double anomalyScore;
  final bool alertFlag;
  final String? message;
  final Map<String, dynamic>? suggestions;

  AIPrediction({
    required this.anomalyScore,
    required this.alertFlag,
    this.message,
    this.suggestions,
  });

  factory AIPrediction.fromJson(Map<String, dynamic> json) {
    return AIPrediction(
      anomalyScore: (json['anomaly_score'] ?? json['anomalyScore'] ?? 0.0).toDouble(),
      alertFlag: json['alert_flag'] ?? json['alertFlag'] ?? false,
      message: json['message'],
      suggestions: json['suggestions'] != null
          ? Map<String, dynamic>.from(json['suggestions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anomaly_score': anomalyScore,
      'alert_flag': alertFlag,
      'message': message,
      'suggestions': suggestions,
    };
  }
}

