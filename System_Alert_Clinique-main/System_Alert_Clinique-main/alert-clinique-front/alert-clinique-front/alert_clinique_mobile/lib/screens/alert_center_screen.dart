import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../models/alert.dart';
import '../models/patient.dart';
import '../services/api_service.dart';

class AlertCenterScreen extends StatefulWidget {
  const AlertCenterScreen({super.key});

  @override
  State<AlertCenterScreen> createState() => _AlertCenterScreenState();
}

class _AlertCenterScreenState extends State<AlertCenterScreen> {
  String _severityFilter = 'all';
  String _statusFilter = 'all';
  String _sourceFilter = 'all'; // 'all', 'ai', 'manual'
  String _searchTerm = '';
  bool _aiServiceAvailable = false;
  bool _isLoading = false;
  
  List<Alert> _allAlerts = [];
  Map<int, String> _patientNames = {};

  @override
  void initState() {
    super.initState();
    _checkAIService();
    _loadAlerts();
  }

  Future<void> _checkAIService() async {
    final available = await ApiService.checkAIServiceHealth();
    setState(() {
      _aiServiceAvailable = available;
    });
  }

  Future<void> _loadAlerts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Charger les alertes
      final alerts = await ApiService.getAlertes();
      
      // Charger les patients pour enrichir les alertes
      final patients = await ApiService.getPatients();
      final patientMap = <int, String>{};
      for (var patient in patients) {
        patientMap[patient.id] = patient.name;
      }

      setState(() {
        _allAlerts = alerts;
        _patientNames = patientMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des alertes: $e'),
            backgroundColor: Colors.red,
    ),
        );
      }
    }
  }

  List<Alert> get _filteredAlerts {
    var filtered = _allAlerts.where((alert) {
      // Filtre source (IA vs manuel)
      if (_sourceFilter == 'ai' && !alert.isAIGenerated) return false;
      if (_sourceFilter == 'manual' && alert.isAIGenerated) return false;
      
      // Filtre sévérité
      final severityMatch =
          _severityFilter == 'all' ||
          alert.severity.toString().split('.').last == _severityFilter;
      
      // Filtre statut
      final statusMatch =
          _statusFilter == 'all' ||
          alert.status.toString().split('.').last == _statusFilter;
      
      // Filtre recherche
      final searchMatch = alert.patient
              .toLowerCase()
              .contains(_searchTerm.toLowerCase()) ||
          alert.patientId.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          alert.type.toLowerCase().contains(_searchTerm.toLowerCase());
      
      return severityMatch && statusMatch && searchMatch;
    }).toList();

    // Enrichir avec les noms de patients
    return filtered.map((alert) {
      if (_patientNames.containsKey(int.tryParse(alert.patientId.replaceAll('P-', '')))) {
        return alert.copyWith(
          patient: _patientNames[int.tryParse(alert.patientId.replaceAll('P-', ''))] ?? alert.patient,
        );
      }
      return alert;
    }).toList();
  }

  List<Alert> get _aiGeneratedAlerts {
    return _allAlerts.where((a) => a.isAIGenerated).toList();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final t = languageProvider.t;

    final stats = {
      'total': _allAlerts.length,
      'critical': _allAlerts
          .where((a) => a.severity == AlertSeverity.critical)
          .length,
      'high': _allAlerts.where((a) => a.severity == AlertSeverity.high).length,
      'pending': _allAlerts
          .where((a) => a.status == AlertStatus.pending)
          .length,
      'resolved': _allAlerts
          .where((a) => a.status == AlertStatus.resolved)
          .length,
      'ai': _aiGeneratedAlerts.length,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(t('alerts.title')),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadAlerts();
              _checkAIService();
            },
            tooltip: 'Actualiser',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _aiServiceAvailable ? Icons.psychology : Icons.psychology_outlined,
                    size: 20,
                    color: _aiServiceAvailable ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _aiServiceAvailable ? 'IA Actif' : 'IA Inactif',
                    style: TextStyle(
                      fontSize: 12,
                      color: _aiServiceAvailable ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        Colors.red,
                        t('alerts.critical'),
                        stats['critical'].toString(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        Colors.orange,
                        t('alerts.high'),
                        stats['high'].toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        Colors.blue,
                        'En attente',
                        stats['pending'].toString(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        Colors.green,
                        'Résolues',
                        stats['resolved'].toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: t('common.search'),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchTerm = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sourceFilter,
                        decoration: InputDecoration(
                          labelText: 'Source',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(value: 'all', child: const Text('Toutes')),
                          DropdownMenuItem(
                              value: 'ai', child: const Text('Générées par IA')),
                          DropdownMenuItem(
                              value: 'manual', child: const Text('Manuelles')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _sourceFilter = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _severityFilter,
                        decoration: InputDecoration(
                          labelText: t('alerts.severity'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(value: 'all', child: Text(t('alerts.all'))),
                          DropdownMenuItem(
                              value: 'critical', child: Text(t('alerts.critical'))),
                          DropdownMenuItem(
                              value: 'high', child: Text(t('alerts.high'))),
                          DropdownMenuItem(
                              value: 'medium', child: Text(t('alerts.medium'))),
                          DropdownMenuItem(
                              value: 'low', child: Text(t('alerts.low'))),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _severityFilter = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _statusFilter,
                        decoration: InputDecoration(
                          labelText: t('alerts.status'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(value: 'all', child: const Text('Tous')),
                          DropdownMenuItem(
                              value: 'pending', child: Text(t('alerts.pending'))),
                          DropdownMenuItem(
                              value: 'inProgress',
                              child: Text(t('alerts.inProgress'))),
                          DropdownMenuItem(
                              value: 'resolved', child: Text(t('alerts.resolved'))),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _statusFilter = value!;
                          });
                        },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Alerts List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAlerts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle,
                            size: 64, color: Colors.green.shade600),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune alerte correspondant aux filtres',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = _filteredAlerts[index];
                      return _buildAlertCard(context, alert, t);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    Color color,
    String label,
    String value,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
            const SizedBox(height: 4),
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
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    Alert alert,
    String Function(String) t,
  ) {
    Color severityColor;
    String severityLabel;
    IconData icon;
    switch (alert.severity) {
      case AlertSeverity.critical:
        severityColor = Colors.red;
        severityLabel = t('alerts.critical');
        icon = Icons.warning;
        break;
      case AlertSeverity.high:
        severityColor = Colors.orange;
        severityLabel = t('alerts.high');
        icon = Icons.trending_up;
        break;
      case AlertSeverity.medium:
        severityColor = Colors.yellow;
        severityLabel = t('alerts.medium');
        icon = Icons.info;
        break;
      case AlertSeverity.low:
        severityColor = Colors.green;
        severityLabel = t('alerts.low');
        icon = Icons.check_circle;
        break;
    }

    Color statusColor;
    String statusLabel;
    switch (alert.status) {
      case AlertStatus.pending:
        statusColor = Colors.blue;
        statusLabel = t('alerts.pending');
        break;
      case AlertStatus.inProgress:
        statusColor = Colors.purple;
        statusLabel = t('alerts.inProgress');
        break;
      case AlertStatus.resolved:
        statusColor = Colors.green;
        statusLabel = t('alerts.resolved');
        break;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showAlertDetails(context, alert, t);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: severityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: severityColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (alert.isAIGenerated)
                              Chip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.psychology, size: 12),
                                    const SizedBox(width: 4),
                                    const Text('IA'),
                                  ],
                                ),
                                backgroundColor: Colors.purple.shade50,
                                labelStyle: TextStyle(
                                  color: Colors.purple.shade700,
                                  fontSize: 10,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            if (alert.isAIGenerated) const SizedBox(width: 8),
                            Chip(
                              label: Text(severityLabel),
                              backgroundColor: severityColor.withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: severityColor,
                                fontSize: 10,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(statusLabel),
                              backgroundColor: statusColor.withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          alert.patient,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${alert.patientId}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                alert.type,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                alert.description,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              if (alert.vitals != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  children: [
                    if (alert.vitals!.heartRate != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite,
                              size: 16, color: Colors.red.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${alert.vitals!.heartRate} bpm',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    if (alert.vitals!.bloodPressure != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.monitor_heart,
                              size: 16, color: Colors.blue.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${alert.vitals!.bloodPressure} mmHg',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
              if (alert.isAIGenerated) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.psychology, size: 16, color: Colors.purple.shade700),
                      const SizedBox(width: 8),
                      if (alert.confidenceScore != null)
                        Expanded(
                          child: Text(
                            'Confiance: ${(alert.confidenceScore! * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.purple.shade700,
                            ),
                          ),
                        ),
                      if (alert.anomalyScore != null)
                        Expanded(
                          child: Text(
                            'Anomalie: ${(alert.anomalyScore! * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.purple.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Il y a ${alert.time}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  if (alert.assignedTo != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.person, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Assignée à ${alert.assignedTo}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDetails(
    BuildContext context,
    Alert alert,
    String Function(String) t,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Détails de l\'alerte #${alert.id}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                alert.patient,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'ID: ${alert.patientId}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              Text(
                alert.type,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(alert.description),
              if (alert.vitals != null) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Signes vitaux',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                if (alert.vitals!.heartRate != null)
                  _buildVitalItem(
                    context,
                    Icons.favorite,
                    'Fréquence cardiaque',
                    '${alert.vitals!.heartRate} bpm',
                    Colors.red,
                  ),
                if (alert.vitals!.bloodPressure != null)
                  _buildVitalItem(
                    context,
                    Icons.monitor_heart,
                    'Pression artérielle',
                    '${alert.vitals!.bloodPressure} mmHg',
                    Colors.blue,
                  ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Fermer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVitalItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                Text(
                  value,
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
    );
  }
}

