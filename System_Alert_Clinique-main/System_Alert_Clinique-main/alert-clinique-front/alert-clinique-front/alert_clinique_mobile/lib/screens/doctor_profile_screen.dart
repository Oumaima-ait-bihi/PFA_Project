import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> _profileData;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    _profileData = {
      'name': user?.name ?? 'Dr. Hasna Ait Ben Brahim',
      'email': user?.email ?? 'hasna.aitbenbrahim@hopital.com',
      'phone': '+33 1 23 45 67 89',
      'specialty': 'Cardiologie',
      'license': 'FR-MED-123456',
      'hospital': 'Hôpital Universitaire de Paris',
      'experience': '15',
      'address': '45 Avenue de la République, 75011 Paris',
      'languages': ['Français', 'Anglais', 'Arabe'],
      'about': 'Cardiologue spécialisée dans les maladies cardiovasculaires avec plus de 15 ans d\'expérience dans la prise en charge des patients.',
    };
  }

  final _education = [
    {
      'degree': 'Doctorat en Médecine',
      'institution': 'Université Paris Diderot',
      'year': '2008',
    },
    {
      'degree': 'Spécialisation en Cardiologie',
      'institution': 'Hôpital Pitié-Salpêtrière',
      'year': '2012',
    },
    {
      'degree': 'Master en Recherche Cardiovasculaire',
      'institution': 'Sorbonne Université',
      'year': '2014',
    },
  ];

  final _certifications = [
    {
      'name': 'European Board of Cardiology',
      'issuer': 'ESC',
      'year': '2013',
    },
    {
      'name': 'Certification en Échographie Cardiaque',
      'issuer': 'SFC',
      'year': '2015',
    },
    {
      'name': 'Formation Avancée en Électrophysiologie',
      'issuer': 'EHRA',
      'year': '2018',
    },
  ];

  final _statistics = [
    {'label': 'Patients suivis', 'value': '247', 'icon': Icons.people},
    {'label': 'Années d\'expérience', 'value': '15+', 'icon': Icons.calendar_today},
    {'label': 'Consultations/mois', 'value': '180', 'icon': Icons.work},
    {'label': 'Taux de satisfaction', 'value': '98%', 'icon': Icons.star},
  ];

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

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t('profile.title')),
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
                  'Gérez vos informations professionnelles',
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
                            _profileData['name']
                                .toString()
                                .replaceAll('Dr. ', '')
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
                                _profileData['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _profileData['specialty'],
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: [
                                  Chip(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.medical_services, size: 14),
                                        const SizedBox(width: 4),
                                        const Text('Médecin'),
                                      ],
                                    ),
                                    backgroundColor: Colors.blue.shade100,
                                    labelStyle: TextStyle(color: Colors.blue.shade800),
                                  ),
                                  Chip(
                                    label: const Text('Actif'),
                                    backgroundColor: Colors.green.shade100,
                                    labelStyle: TextStyle(color: Colors.green.shade800),
                                  ),
                                  Chip(
                                    label: const Text('Certifié'),
                                    backgroundColor: Colors.purple.shade100,
                                    labelStyle: TextStyle(color: Colors.purple.shade800),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Statistics
                Row(
                  children: _statistics.map((stat) {
                    return Expanded(
                      child: Card(
                        margin: const EdgeInsets.only(right: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
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
                                  stat['icon'] as IconData,
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
                                      stat['label'] as String,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      stat['value'] as String,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
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
                              t('profile.personalInfo'),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField('Nom complet', 'name', Icons.person),
                        const SizedBox(height: 16),
                        _buildTextField('Email', 'email', Icons.email),
                        const SizedBox(height: 16),
                        _buildTextField('Téléphone', 'phone', Icons.phone),
                        const SizedBox(height: 16),
                        _buildTextField('Adresse', 'address', Icons.location_on),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: _profileData['about'],
                          enabled: _isEditing,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'À propos',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: !_isEditing,
                            fillColor: Colors.grey.shade50,
                          ),
                          onSaved: (value) {
                            if (value != null) {
                              _profileData['about'] = value;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Professional Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.work, color: Colors.blue.shade600),
                            const SizedBox(width: 8),
                            Text(
                              t('profile.professionalInfo'),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(t('profile.specialty'), 'specialty', Icons.medical_services),
                        const SizedBox(height: 16),
                        _buildTextField(t('profile.license'), 'license', Icons.verified),
                        const SizedBox(height: 16),
                        _buildTextField(t('profile.hospital'), 'hospital', Icons.business),
                        const SizedBox(height: 16),
                        _buildTextField(t('profile.experience'), 'experience', Icons.calendar_today),
                        const SizedBox(height: 16),
                        Text(
                          t('profile.languages'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: (_profileData['languages'] as List<String>).map((lang) {
                            return Chip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.language, size: 14),
                                  const SizedBox(width: 4),
                                  Text(lang),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Education
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.school, color: Colors.blue.shade600),
                            const SizedBox(width: 8),
                            Text(
                              t('profile.education'),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._education.map((edu) {
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
                                    Icons.school,
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
                                        edu['degree']!,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        edu['institution']!,
                                        style: TextStyle(color: Colors.grey.shade600),
                                      ),
                                      Text(
                                        edu['year']!,
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

                // Certifications
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.verified, color: Colors.blue.shade600),
                            const SizedBox(width: 8),
                            Text(
                              t('profile.certifications'),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._certifications.map((cert) {
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
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.verified,
                                    color: Colors.green.shade600,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cert['name']!,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        cert['issuer']!,
                                        style: TextStyle(color: Colors.grey.shade600),
                                      ),
                                      Text(
                                        cert['year']!,
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

  Widget _buildTextField(String label, String key, IconData icon) {
    return TextFormField(
      initialValue: _profileData[key]?.toString(),
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
}

