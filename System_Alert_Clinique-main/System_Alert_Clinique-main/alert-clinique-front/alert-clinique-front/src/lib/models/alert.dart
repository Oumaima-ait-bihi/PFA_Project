enum AlertSeverity {
  critical,
  high,
  medium,
  low,
}

enum AlertStatus {
  pending,
  inProgress,
  resolved,
}

class Alert {
  final int id;
  final String patient;
  final String patientId;
  final String type;
  final AlertSeverity severity;
  final AlertStatus status;
  final String time;
  final String timestamp;
  final String description;
  final Vitals? vitals;
  final String? notes;
  final String? assignedTo;

  Alert({
    required this.id,
    required this.patient,
    required this.patientId,
    required this.type,
    required this.severity,
    required this.status,
    required this.time,
    required this.timestamp,
    required this.description,
    this.vitals,
    this.notes,
    this.assignedTo,
  });

  Alert copyWith({
    int? id,
    String? patient,
    String? patientId,
    String? type,
    AlertSeverity? severity,
    AlertStatus? status,
    String? time,
    String? timestamp,
    String? description,
    Vitals? vitals,
    String? notes,
    String? assignedTo,
  }) {
    return Alert(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      patientId: patientId ?? this.patientId,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      time: time ?? this.time,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      vitals: vitals ?? this.vitals,
      notes: notes ?? this.notes,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}

class Vitals {
  final int? heartRate;
  final String? bloodPressure;
  final double? temperature;
  final int? oxygen;

  Vitals({
    this.heartRate,
    this.bloodPressure,
    this.temperature,
    this.oxygen,
  });
}

