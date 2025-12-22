import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  
  late Map<String, String> _profileData;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    _profileData = {
      'name': user?.name ?? 'Jean Dupont',
      'email': user?.email ?? 'jean.dupont@email.com',
      'phone': '+33 6 12 34 56 78',
      'dateOfBirth': '15/05/1978',
      'address': '123 Rue de la Santé, 75013 Paris',
      'bloodType': 'A+',
      'height': '175 cm',
      'weight': '72 kg',
      'emergencyContact': 'Marie Dupont - +33 6 98 76 54 32',
    };
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final t = languageProvider.t;
    final isRTL = languageProvider.language == AppLanguage.ar;

    final medicalHistory = [
      {'date': '2024-01', 'condition': 'Consultation générale', 'doctor': 'Dr. Hasna Ait Ben Brahim'},
      {'date': '2023-09', 'condition': 'Vaccination grippe', 'doctor': 'Dr. Martin'},
      {'date': '2023-03', 'condition': 'Bilan sanguin', 'doctor': 'Dr. Hasna Ait Ben Brahim'},
    ];

    final medications = [
      {'name': 'Lisinopril', 'dosage': '10mg', 'frequency': '1x par jour', 'startDate': 'Jan 2023'},
      {'name': 'Metformine', 'dosage': '500mg', 'frequency': '2x par jour', 'startDate': 'Mar 2023'},
    ];

    final allergies = ['Pénicilline', 'Pollen'];

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t('sidebar.profile')),
          actions: [
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              onPressed: () {
                if (_isEditing) {
                  _handleSave();
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gérez vos informations personnelles et médicales',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                
                // Profile Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade600,
                          child: Text(
                            _profileData['name']!
                                .split(' ')
                                .map((n) => n[0])
                                .join('')
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _profileData['name']!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: [
                                  Chip(
                                    label: const Text('Patient'),
                                    backgroundColor: Colors.blue.shade100,
                                    labelStyle: TextStyle(color: Colors.blue.shade800),
                                  ),
                                  Chip(
                                    label: const Text('Actif'),
                                    backgroundColor: Colors.green.shade100,
                                    labelStyle: TextStyle(color: Colors.green.shade800),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Membre depuis Janvier 2023',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Personal Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.blue.shade600),
                            const SizedBox(width: 8),
                            Text(
                              'Informations personnelles',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          'Nom complet',
                          'name',
                          Icons.person,
                          _profileData['name']!,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          'Email',
                          'email',
                          Icons.email,
                          _profileData['email']!,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          'Téléphone',
                          'phone',
                          Icons.phone,
                          _profileData['phone']!,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          'Date de naissance',
                          'dateOfBirth',
                          Icons.calendar_today,
                          _profileData['dateOfBirth']!,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          'Adresse',
                          'address',
                          Icons.location_on,
                          _profileData['address']!,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Medical Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.favorite, color: Colors.red.shade600),
                            const SizedBox(width: 8),
                            Text(
                              'Informations médicales',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoBox(
                                'Groupe sanguin',
                                _profileData['bloodType']!,
                                Icons.bloodtype,
                                Colors.red,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoBox(
                                'Taille',
                                _profileData['height']!,
                                null,
                                Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoBox(
                                'Poids',
                                _profileData['weight']!,
                                null,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoBox(
                                'IMC',
                                '23.5',
                                null,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Allergies',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: allergies.map((allergy) {
                            return Chip(
                              label: Text(allergy),
                              backgroundColor: Colors.red.shade50,
                              labelStyle: TextStyle(color: Colors.red.shade800),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          'Contact d\'urgence',
                          'emergencyContact',
                          Icons.phone,
                          _profileData['emergencyContact']!,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Medications
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.medication, color: Colors.purple.shade600),
                            const SizedBox(width: 8),
                            Text(
                              'Médicaments actuels',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...medications.map((med) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.medication,
                                    color: Colors.purple.shade600,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        med['name']!,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${med['dosage']} - ${med['frequency']}',
                                        style: TextStyle(color: Colors.grey.shade600),
                                      ),
                                      Text(
                                        'Depuis ${med['startDate']}',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Medical History
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.history, color: Colors.blue.shade600),
                            const SizedBox(width: 8),
                            Text(
                              'Historique médical',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...medicalHistory.map((record) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.description,
                                    color: Colors.blue.shade600,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        record['condition']!,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        record['doctor']!,
                                        style: TextStyle(color: Colors.grey.shade600),
                                      ),
                                      Text(
                                        record['date']!,
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String key,
    IconData icon,
    String initialValue,
  ) {
    return TextFormField(
      initialValue: initialValue,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: !_isEditing,
        fillColor: Colors.grey.shade50,
      ),
      onSaved: (value) {
        if (value != null) {
          _profileData[key] = value;
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }

  Widget _buildInfoBox(
    String label,
    String value,
    IconData? icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color == Colors.green ? Colors.green.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color == Colors.green ? Colors.green.shade800 : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

