class Patient {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String gender; // 'M' ou 'F'
  final String? condition;
  final String status; // 'critical', 'high', 'stable'
  final String? lastVisit; // Format: "YYYY-MM-DD"
  final String? assignedDoctor;
  final String? adresse;

  Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    this.condition,
    required this.status,
    this.lastVisit,
    this.assignedDoctor,
    this.adresse,
  });

  // Convertir depuis JSON (réponse API)
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      condition: json['condition'] as String?,
      status: json['status'] as String,
      lastVisit: json['lastVisit'] as String?,
      assignedDoctor: json['assignedDoctor'] as String?,
      adresse: json['adresse'] as String?,
    );
  }

  // Convertir vers JSON (pour les requêtes POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'condition': condition,
      'status': status,
      'lastVisit': lastVisit,
      'assignedDoctor': assignedDoctor,
      'adresse': adresse,
    };
  }

  // Créer un Patient pour création (sans id)
  Map<String, dynamic> toJsonForCreate() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'condition': condition,
      'status': status,
      'lastVisit': lastVisit,
      'assignedDoctor': assignedDoctor,
      'adresse': adresse,
    };
  }

  Patient copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    int? age,
    String? gender,
    String? condition,
    String? status,
    String? lastVisit,
    String? assignedDoctor,
    String? adresse,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      condition: condition ?? this.condition,
      status: status ?? this.status,
      lastVisit: lastVisit ?? this.lastVisit,
      assignedDoctor: assignedDoctor ?? this.assignedDoctor,
      adresse: adresse ?? this.adresse,
    );
  }
}
