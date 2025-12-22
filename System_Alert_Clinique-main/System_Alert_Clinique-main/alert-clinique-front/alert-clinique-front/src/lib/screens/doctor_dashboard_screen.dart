import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/patient_provider.dart';
import '../models/patient.dart';
import '../models/alert.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les patients au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().loadPatients();
    });
  }

  // Obtenir les patients à haut risque (critical ou high)
  List<Patient> get highRiskPatients {
    final patientProvider = context.watch<PatientProvider>();
    return patientProvider.patients
        .where((p) => p.status == 'critical' || p.status == 'high')
        .take(3)
        .toList();
  }

  // Calculer le temps depuis la dernière visite
  String _getTimeSince(String? lastVisit) {
    if (lastVisit == null) return 'N/A';
    // Pour simplifier, on affiche juste la date
    // Vous pouvez améliorer cela pour calculer "il y a X heures/jours"
    return lastVisit;
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final patientProvider = Provider.of<PatientProvider>(context);
    final t = languageProvider.t;
    final stats = patientProvider.getStats();

    final recentAlerts = [
      Alert(
        id: 1,
        patient: 'Sophie Martin',
        patientId: 'P-2847',
        type: 'Pression artérielle élevée',
        severity: AlertSeverity.critical,
        status: AlertStatus.pending,
        time: '15 min',
        timestamp: '2024-11-13 14:45',
        description: 'Pression artérielle détectée à 180/110 mmHg',
      ),
      Alert(
        id: 2,
        patient: 'Ahmed Benali',
        patientId: 'P-1923',
        type: 'Fréquence cardiaque irrégulière',
        severity: AlertSeverity.high,
        status: AlertStatus.inProgress,
        time: '1h',
        timestamp: '2024-11-13 13:00',
        description: 'Variation anormale du rythme cardiaque détectée',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t('doctor.welcome')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vue d\'ensemble de vos patients',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 24),
            
            // Stats Overview
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    Icons.people,
                    Colors.blue,
                    t('doctor.stats.total'),
                    stats['total'].toString(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    Icons.warning,
                    Colors.red,
                    t('doctor.stats.critical'),
                    stats['critical'].toString(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    Icons.trending_up,
                    Colors.orange,
                    t('doctor.stats.moderate'),
                    stats['high'].toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // High Risk Patients
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning, color: Colors.red.shade600),
                            const SizedBox(width: 8),
                            Text(
                              t('doctor.highRisk'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(t('doctor.viewAll')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (highRiskPatients.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Aucun patient à haut risque',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    else
                      ...highRiskPatients.map((patient) {
                        return _buildPatientCard(context, patient, t);
                      }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Recent Alerts
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notifications_active,
                                color: Colors.blue.shade600),
                            const SizedBox(width: 8),
                            Text(
                              t('doctor.recentAlerts'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(t('doctor.viewAll')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...recentAlerts.map((alert) {
                      return _buildAlertCard(context, alert, t);
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Urgent Action Banner
            Card(
              elevation: 2,
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.red.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.warning, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t('doctor.urgentAction'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                          Text(
                            '${stats['critical']} patient(s) nécessitent une attention immédiate',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                      ),
                      child: const Text('Voir les cas'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    Color color,
    String label,
    String value,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(
    BuildContext context,
    Patient patient,
    String Function(String) t,
  ) {
    Color riskColor;
    String riskLabel;
    switch (patient.status) {
      case 'critical':
        riskColor = Colors.red;
        riskLabel = t('alerts.critical');
        break;
      case 'high':
        riskColor = Colors.orange;
        riskLabel = t('alerts.high');
        break;
      case 'stable':
        riskColor = Colors.green;
        riskLabel = t('patients.stable');
        break;
      default:
        riskColor = Colors.grey;
        riskLabel = patient.status;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(riskLabel),
                      backgroundColor: riskColor.withOpacity(0.1),
                      labelStyle: TextStyle(color: riskColor),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  patient.condition ?? 'N/A',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Dernière visite: ${_getTimeSince(patient.lastVisit)}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.visibility, size: 16),
            label: Text(t('doctor.viewPatient')),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    Alert alert,
    String Function(String) t,
  ) {
    Color severityColor;
    String severityLabel;
    switch (alert.severity) {
      case AlertSeverity.critical:
        severityColor = Colors.red;
        severityLabel = t('alerts.critical');
        break;
      case AlertSeverity.high:
        severityColor = Colors.orange;
        severityLabel = t('alerts.high');
        break;
      case AlertSeverity.medium:
        severityColor = Colors.yellow;
        severityLabel = t('alerts.medium');
        break;
      case AlertSeverity.low:
        severityColor = Colors.green;
        severityLabel = t('alerts.low');
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(severityLabel),
                backgroundColor: severityColor.withOpacity(0.1),
                labelStyle: TextStyle(color: severityColor),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 8),
              Text(
                'Il y a ${alert.time}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            alert.patient,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            alert.type,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

