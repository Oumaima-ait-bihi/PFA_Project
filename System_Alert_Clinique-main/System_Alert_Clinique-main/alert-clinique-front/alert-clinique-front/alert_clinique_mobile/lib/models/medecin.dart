class Medecin {
  final int id;
  final String nom;
  final String specialite;
  final String email;
  final String phone;

  Medecin({
    required this.id,
    required this.nom,
    required this.specialite,
    required this.email,
    required this.phone,
  });

  // Convertir depuis JSON (réponse API)
  factory Medecin.fromJson(Map<String, dynamic> json) {
    return Medecin(
      id: json['id'] as int,
      nom: json['nom'] as String,
      specialite: json['specialite'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  // Convertir vers JSON (pour les requêtes POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'specialite': specialite,
      'email': email,
      'phone': phone,
    };
  }

  // Créer un Medecin pour création (sans id)
  Map<String, dynamic> toJsonForCreate() {
    return {
      'nom': nom,
      'specialite': specialite,
      'email': email,
      'phone': phone,
    };
  }

  Medecin copyWith({
    int? id,
    String? nom,
    String? specialite,
    String? email,
    String? phone,
  }) {
    return Medecin(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      specialite: specialite ?? this.specialite,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

