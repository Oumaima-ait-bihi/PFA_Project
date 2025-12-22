import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/ai_prediction.dart';
import '../models/alert.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  // Données vitales
  double _heartRate = 72.0;
  double _hrVariability = 50.0;
  int _steps = 5000;
  double _moodScore = 7.0;
  double _sleepHours = 7.0;
  double _sleepMinutes = 0.0;
  double _sleepEfficiency = 85.0;
  int _numAwakenings = 1;

  // État IA
  AIPrediction? _currentPrediction;
  bool _isPredicting = false;
  bool _aiServiceAvailable = false;
  Timer? _predictionTimer;
  List<Map<String, dynamic>> _predictionHistory = [];

  // Patient ID (récupéré depuis l'auth)
  int _patientId = 1; // Par défaut, sera récupéré depuis l'auth
  String _patientName = 'Patient';

  @override
  void initState() {
    super.initState();
    _loadPatientInfo();
    _checkAIService();
  }

  @override
  void dispose() {
    _predictionTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPatientInfo() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      setState(() {
        _patientName = authProvider.user!.name;
        // Essayer d'extraire l'ID depuis l'email ou utiliser un ID par défaut
        _patientId = int.tryParse(authProvider.user!.id) ?? 1;
      });
    }
  }

  Future<void> _checkAIService() async {
    final available = await ApiService.checkAIServiceHealth();
    setState(() {
      _aiServiceAvailable = available;
    });
  }

  void _onDataChanged() {
    // Annuler le timer précédent
    _predictionTimer?.cancel();
    
    // Lancer une nouvelle prédiction après 2 secondes d'inactivité
    _predictionTimer = Timer(const Duration(seconds: 2), () {
      _predictAI();
    });
  }

  Future<void> _predictAI() async {
    if (!_aiServiceAvailable || _isPredicting) return;

    setState(() {
      _isPredicting = true;
    });

    try {
      final prediction = await ApiService.predictAISimple(
        patientId: _patientId,
        heartRate: _heartRate,
        hrVariability: _hrVariability,
        steps: _steps,
        moodScore: _moodScore,
        sleepDurationHours: _sleepHours + (_sleepMinutes / 60),
        sleepEfficiency: _sleepEfficiency,
        numAwakenings: _numAwakenings,
      );

      setState(() {
        _currentPrediction = prediction;
        _isPredicting = false;
        
        // Ajouter à l'historique
        _predictionHistory.add({
          'timestamp': DateTime.now(),
          'anomalyScore': prediction.anomalyScore,
          'alertFlag': prediction.alertFlag,
        });
        
        // Garder seulement les 7 derniers jours
        if (_predictionHistory.length > 7) {
          _predictionHistory.removeAt(0);
        }
      });

      // Créer une alerte automatiquement si alertFlag est true
      if (prediction.alertFlag) {
        await _createAIAlert(prediction);
      }
    } catch (e) {
      setState(() {
        _isPredicting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de prédiction IA: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createAIAlert(AIPrediction prediction) async {
    try {
      await ApiService.createAlerte(
        patientId: _patientId,
        patientName: _patientName,
        type: 'Anomalie détectée par IA',
        description: prediction.message ?? 
            'Anomalie détectée: Score ${prediction.anomalyScore.toStringAsFixed(2)}',
        severity: prediction.anomalyScore > 0.8 
            ? AlertSeverity.critical 
            : prediction.anomalyScore > 0.6 
                ? AlertSeverity.high 
                : AlertSeverity.medium,
        isAIGenerated: true,
        confidenceScore: 1.0 - prediction.anomalyScore,
        anomalyScore: prediction.anomalyScore,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alerte créée automatiquement par l\'IA'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la création de l\'alerte: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final t = languageProvider.t;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bannière de bienvenue
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade400],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Semaine en cours',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Carte Analyse IA
          _buildAIRiskIndicator(context, t),
          const SizedBox(height: 16),

          // Humeur
          _buildMoodCard(context, t),
          const SizedBox(height: 16),

          // Sommeil
          _buildSleepCard(context, t),
          const SizedBox(height: 16),

          // Rythme cardiaque
          _buildHeartRateCard(context, t),
          const SizedBox(height: 16),

          // Capture Photo
          _buildPhotoCaptureCard(context, t),
          const SizedBox(height: 16),

          // Suggestions IA (caché par défaut, peut être affiché si nécessaire)
          if (_currentPrediction != null && _currentPrediction!.alertFlag) ...[
            _buildSuggestionsCard(context, t),
            const SizedBox(height: 16),
          ],

          // Graphiques de tendances (caché par défaut, peut être affiché si nécessaire)
          if (_predictionHistory.isNotEmpty && _predictionHistory.length >= 3) ...[
            _buildTrendsChart(context, t),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildAIRiskIndicator(BuildContext context, String Function(String) t) {
    Color riskColor;
    String riskText;
    IconData riskIcon;

    if (!_aiServiceAvailable) {
      riskColor = Colors.grey;
      riskText = 'Service IA indisponible';
      riskIcon = Icons.error_outline;
    } else if (_isPredicting) {
      riskColor = Colors.blue;
      riskText = 'Analyse en cours...';
      riskIcon = Icons.hourglass_empty;
    } else if (_currentPrediction == null) {
      riskColor = Colors.blue;
      riskText = 'En attente de données';
      riskIcon = Icons.psychology;
    } else {
      final score = _currentPrediction!.anomalyScore;
      if (score < 0.3) {
        riskColor = Colors.green;
        riskText = 'Risque faible';
        riskIcon = Icons.check_circle;
      } else if (score < 0.6) {
        riskColor = Colors.orange;
        riskText = 'Risque modéré';
        riskIcon = Icons.warning;
      } else if (score < 0.8) {
        riskColor = Colors.deepOrange;
        riskText = 'Risque élevé';
        riskIcon = Icons.warning_amber;
      } else {
        riskColor = Colors.red;
        riskText = 'Risque critique';
        riskIcon = Icons.error;
      }
    }

    final hasAlert = _currentPrediction?.alertFlag ?? false;
    final score = _currentPrediction?.anomalyScore ?? 0.0;

    return Card(
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
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.psychology, color: Colors.blue.shade600, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analyse IA en temps réel',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(riskIcon, color: riskColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            riskText,
                            style: TextStyle(
                              color: riskColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_currentPrediction != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score d\'anomalie',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '${(score * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: score,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                ),
              ),
            ],
            if (hasAlert) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.pink.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.pink.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Alerte détectée ! Consultez votre médecin.',
                        style: TextStyle(
                          color: Colors.pink.shade900,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context, String Function(String) t) {
    return Card(
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
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.sentiment_satisfied,
                      color: Colors.amber.shade600, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  t('patient.mood'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodEmoji(1.0, Icons.sentiment_very_dissatisfied, '😢'),
                _buildMoodEmoji(3.0, Icons.sentiment_dissatisfied, '🙂'),
                _buildMoodEmoji(5.0, Icons.sentiment_neutral, '😊'),
                _buildMoodEmoji(7.0, Icons.sentiment_satisfied, '😂'),
                _buildMoodEmoji(9.0, Icons.sentiment_very_satisfied, '🤩'),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _getMoodLabel(_moodScore),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.amber.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMoodLabel(double score) {
    if (score <= 2.0) return 'Triste';
    if (score <= 4.0) return 'Neutre';
    if (score <= 6.0) return 'Content';
    if (score <= 8.0) return 'Joyeux';
    return 'Excellent';
  }

  Widget _buildMoodEmoji(double value, IconData icon, String emoji) {
    final isSelected = (_moodScore - value).abs() < 1.0;
    return GestureDetector(
      onTap: () {
        setState(() {
          _moodScore = value;
        });
        _onDataChanged();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber.shade100 : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.amber.shade600 : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepCard(BuildContext context, String Function(String) t) {
    return Card(
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
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.bedtime,
                      color: Colors.purple.shade600, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  t('patient.sleep'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${_sleepHours.toInt()}h',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Heures:'),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _sleepHours,
                              min: 0,
                              max: 12,
                              divisions: 12,
                              label: '${_sleepHours.toInt()} h',
                              onChanged: (value) {
                                setState(() {
                                  _sleepHours = value;
                                });
                                _onDataChanged();
                              },
                            ),
                          ),
                          Text(
                            '${_sleepHours.toInt()} h',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.purple.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Minutes:'),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _sleepMinutes,
                              min: 0,
                              max: 59,
                              divisions: 59,
                              label: '${_sleepMinutes.toInt()} min',
                              onChanged: (value) {
                                setState(() {
                                  _sleepMinutes = value;
                                });
                                _onDataChanged();
                              },
                            ),
                          ),
                          Text(
                            '${_sleepMinutes.toInt()} min',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.purple.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeartRateCard(BuildContext context, String Function(String) t) {
    return Card(
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
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.favorite,
                      color: Colors.red.shade600, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  t('patient.rhythm'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '${_heartRate.toInt()} bpm',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Rythme cardiaque:'),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _heartRate,
                    min: 40,
                    max: 120,
                    divisions: 80,
                    label: '${_heartRate.toInt()}',
                    onChanged: (value) {
                      setState(() {
                        _heartRate = value;
                      });
                      _onDataChanged();
                    },
                  ),
                ),
                Text(
                  '${_heartRate.toInt()}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsCard(BuildContext context, String Function(String) t) {
    final suggestions = _currentPrediction?.suggestions ?? {};
    
    return Card(
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
              children: [
                Icon(Icons.lightbulb, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  'Suggestions basées sur l\'IA',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (suggestions.isEmpty)
              Text(
                _currentPrediction?.message ?? 'Aucune suggestion disponible',
                style: TextStyle(color: Colors.grey.shade700),
              )
            else
              ...suggestions.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsChart(BuildContext context, String Function(String) t) {
    if (_predictionHistory.isEmpty) return const SizedBox.shrink();

    return Card(
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
              children: [
                Icon(Icons.trending_up, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  'Tendances des prédictions',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _predictionHistory.asMap().entries.map((e) {
                        return FlSpot(
                          e.key.toDouble(),
                          e.value['anomalyScore'] as double,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue.shade600,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.blue.shade600,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.shade50,
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCaptureCard(BuildContext context, String Function(String) t) {
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
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.camera_alt, color: Colors.blue.shade600, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Capture Photo',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

