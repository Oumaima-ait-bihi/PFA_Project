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
  final bool isAIGenerated;
  final double? confidenceScore;
  final double? anomalyScore;

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
    this.isAIGenerated = false,
    this.confidenceScore,
    this.anomalyScore,
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
    bool? isAIGenerated,
    double? confidenceScore,
    double? anomalyScore,
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
      isAIGenerated: isAIGenerated ?? this.isAIGenerated,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      anomalyScore: anomalyScore ?? this.anomalyScore,
    );
  }

  factory Alert.fromJson(Map<String, dynamic> json) {
    // Extraction du patientId
    String patientId = '';
    if (json['patientId'] != null) {
      patientId = json['patientId'].toString();
    } else if (json['patient'] != null && json['patient'] is Map) {
      patientId = json['patient']['id']?.toString() ?? '';
    } else if (json['patient'] != null && json['patient'] is String) {
      // Si patient est une string, essayer d'extraire l'ID
      final match = RegExp(r'P-?\d+').firstMatch(json['patient']);
      if (match != null) {
        patientId = match.group(0) ?? '';
      }
    }

    // Extraction du nom du patient
    String patientName = 'Patient inconnu';
    if (json['patient'] != null) {
      if (json['patient'] is Map) {
        patientName = json['patient']['name'] ?? 
                     json['patient']['nom'] ?? 
                     json['patient']['patientName'] ??
                     'Patient inconnu';
      } else if (json['patient'] is String) {
        patientName = json['patient'];
      }
    }

    // Extraction depuis le message si nécessaire
    if (patientName == 'Patient inconnu' && json['message'] != null) {
      final message = json['message'].toString();
      // Pattern: "Patient: Nom. ..." ou "Patient Nom ..."
      final patterns = [
        RegExp(r'Patient:\s*([^\.]+)'),
        RegExp(r'Patient\s+([A-Za-z\s]+)'),
        RegExp(r'pour\s+([A-Za-z\s]+)'),
      ];
      
      for (var pattern in patterns) {
        final match = pattern.firstMatch(message);
        if (match != null && match.group(1) != null) {
          patientName = match.group(1)!.trim();
          break;
        }
      }
    }

    // Fallback avec patientId si toujours inconnu
    if (patientName == 'Patient inconnu' && patientId.isNotEmpty) {
      patientName = 'Patient $patientId';
    }

    // Conversion de la sévérité
    AlertSeverity severity = AlertSeverity.medium;
    if (json['severity'] != null) {
      final severityStr = json['severity'].toString().toLowerCase();
      switch (severityStr) {
        case 'critical':
          severity = AlertSeverity.critical;
          break;
        case 'high':
          severity = AlertSeverity.high;
          break;
        case 'low':
          severity = AlertSeverity.low;
          break;
        default:
          severity = AlertSeverity.medium;
      }
    }

    // Conversion du statut
    AlertStatus status = AlertStatus.pending;
    if (json['status'] != null) {
      final statusStr = json['status'].toString().toLowerCase();
      switch (statusStr) {
        case 'inprogress':
        case 'in_progress':
          status = AlertStatus.inProgress;
          break;
        case 'resolved':
          status = AlertStatus.resolved;
          break;
        default:
          status = AlertStatus.pending;
      }
    }

    // Extraction des vitals
    Vitals? vitals;
    if (json['vitals'] != null) {
      vitals = Vitals(
        heartRate: json['vitals']['heartRate'],
        bloodPressure: json['vitals']['bloodPressure'],
        temperature: json['vitals']['temperature']?.toDouble(),
        oxygen: json['vitals']['oxygen'],
      );
    }

    return Alert(
      id: json['id'] ?? 0,
      patient: patientName,
      patientId: patientId,
      type: json['type'] ?? json['alertType'] ?? 'Alerte',
      severity: severity,
      status: status,
      time: json['time'] ?? json['timeAgo'] ?? 'N/A',
      timestamp: json['timestamp'] ?? json['createdAt'] ?? '',
      description: json['description'] ?? json['message'] ?? '',
      vitals: vitals,
      notes: json['notes'],
      assignedTo: json['assignedTo'],
      isAIGenerated: json['isAIGenerated'] ?? json['aiGenerated'] ?? false,
      confidenceScore: json['confidenceScore']?.toDouble(),
      anomalyScore: json['anomalyScore']?.toDouble(),
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

