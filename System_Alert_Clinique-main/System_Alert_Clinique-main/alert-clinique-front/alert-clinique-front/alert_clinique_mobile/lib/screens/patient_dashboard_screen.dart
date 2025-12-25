import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
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

  // Image capturée
  File? _capturedImage;
  final ImagePicker _imagePicker = ImagePicker();

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

          // Suggestions IA - Toujours affichées
          _buildSuggestionsCard(context, t),
          const SizedBox(height: 16),

          // Graphiques de tendances - Toujours affichés
          _buildTrendsChart(context, t),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAIRiskIndicator(BuildContext context, String Function(String) t) {
    Color riskColor;
    String riskText;
    IconData riskIcon;
    Color backgroundColor;
    Color textColor;

    if (!_aiServiceAvailable) {
      riskColor = Colors.grey;
      riskText = 'Service IA indisponible';
      riskIcon = Icons.error_outline;
      backgroundColor = Colors.grey.shade50;
      textColor = Colors.grey.shade700;
    } else if (_isPredicting) {
      riskColor = Colors.blue;
      riskText = 'Analyse en cours...';
      riskIcon = Icons.hourglass_empty;
      backgroundColor = Colors.blue.shade50;
      textColor = Colors.blue.shade700;
    } else if (_currentPrediction == null) {
      riskColor = Colors.blue;
      riskText = 'En attente de données';
      riskIcon = Icons.psychology;
      backgroundColor = Colors.blue.shade50;
      textColor = Colors.blue.shade700;
    } else {
      final score = _currentPrediction!.anomalyScore;
      if (score < 0.3) {
        riskColor = Colors.green;
        riskText = 'Risque faible';
        riskIcon = Icons.check_circle;
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
      } else if (score < 0.6) {
        riskColor = Colors.orange;
        riskText = 'Risque modéré';
        riskIcon = Icons.warning;
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
      } else if (score < 0.8) {
        riskColor = Colors.deepOrange;
        riskText = 'Risque élevé';
        riskIcon = Icons.warning_amber;
        backgroundColor = Colors.deepOrange.shade50;
        textColor = Colors.deepOrange.shade700;
      } else {
        riskColor = Colors.red;
        riskText = 'Risque critique';
        riskIcon = Icons.error;
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
      }
    }

    final hasAlert = _currentPrediction?.alertFlag ?? false;
    final score = _currentPrediction?.anomalyScore ?? 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
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
                      color: riskColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(riskIcon, color: riskColor, size: 24),
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
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(score * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 18,
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
                    minHeight: 10,
                    backgroundColor: riskColor.withOpacity(0.2),
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
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Alerte détectée ! Consultez votre médecin.',
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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
    // Générer des suggestions basées sur les données actuelles et la prédiction IA
    List<Map<String, dynamic>> suggestions = [];
    
    if (_currentPrediction != null) {
      final score = _currentPrediction!.anomalyScore;
      
      // Suggestion basée sur le score d'anomalie
      if (score >= 0.8) {
        suggestions.add({
          'icon': Icons.warning_amber,
          'color': Colors.orange,
          'text': 'Risque élevé détecté. Consultez votre médecin.',
        });
      } else if (score >= 0.6) {
        suggestions.add({
          'icon': Icons.warning,
          'color': Colors.orange.shade300,
          'text': 'Risque modéré détecté. Surveillez vos signes vitaux.',
        });
      }
      
      // Suggestion basée sur le rythme cardiaque
      if (_heartRate > 100) {
        suggestions.add({
          'icon': Icons.favorite,
          'color': Colors.red,
          'text': 'Votre rythme cardiaque est élevé. Reposez-vous.',
        });
      } else if (_heartRate < 60) {
        suggestions.add({
          'icon': Icons.favorite,
          'color': Colors.blue,
          'text': 'Votre rythme cardiaque est bas. Consultez votre médecin si cela persiste.',
        });
      }
      
      // Suggestion basée sur le sommeil
      if (_sleepHours < 6) {
        suggestions.add({
          'icon': Icons.bedtime,
          'color': Colors.purple,
          'text': 'Vous devriez dormir au moins 7-8 heures par nuit.',
        });
      }
      
      // Suggestion basée sur l'humeur
      if (_moodScore < 3) {
        suggestions.add({
          'icon': Icons.sentiment_very_dissatisfied,
          'color': Colors.amber,
          'text': 'Votre humeur semble faible. Prenez soin de vous.',
        });
      }
      
      // Suggestion générale sur les médicaments
      suggestions.add({
        'icon': Icons.medication,
        'color': Colors.blue,
        'text': 'Vérifiez que vous avez pris vos médicaments.',
      });
    } else {
      // Suggestions par défaut si pas de prédiction
      suggestions.add({
        'icon': Icons.info,
        'color': Colors.blue,
        'text': 'Remplissez vos données vitales pour recevoir des suggestions personnalisées.',
      });
    }
    
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
                  'Suggestions IA',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...suggestions.map((suggestion) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      suggestion['icon'] as IconData,
                      color: suggestion['color'] as Color,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        suggestion['text'] as String,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
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
    // Préparer les données pour le graphique
    List<FlSpot> spots = [];
    List<FlSpot> alertSpots = [];
    
    // Si on a une prédiction actuelle, l'ajouter à l'historique pour l'affichage
    if (_currentPrediction != null) {
      final currentData = {
        'anomalyScore': _currentPrediction!.anomalyScore,
        'alertFlag': _currentPrediction!.alertFlag,
        'timestamp': DateTime.now(),
      };
      
      // Ajouter à l'historique si pas déjà présent
      if (_predictionHistory.isEmpty || 
          _predictionHistory.last['timestamp'] != currentData['timestamp']) {
        _predictionHistory.add(currentData);
        // Garder seulement les 7 derniers points
        if (_predictionHistory.length > 7) {
          _predictionHistory.removeAt(0);
        }
      }
    }
    
    // Créer les points pour le graphique
    for (int i = 0; i < _predictionHistory.length; i++) {
      final data = _predictionHistory[i];
      final score = data['anomalyScore'] as double;
      spots.add(FlSpot(i.toDouble(), score));
      
      // Marquer les alertes
      if (data['alertFlag'] == true) {
        alertSpots.add(FlSpot(i.toDouble(), score));
      }
    }
    
    // Si pas de données, créer des données de démonstration
    if (spots.isEmpty && _currentPrediction != null) {
      spots.add(FlSpot(0.0, _currentPrediction!.anomalyScore));
    } else if (spots.isEmpty) {
      // Afficher un message si pas de données
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'Aucune donnée disponible.\nRemplissez vos données vitales pour voir les tendances.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

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
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 0.2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value * 100).toInt()}%',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                            ),
                          );
                        },
                        interval: 0.2,
                      ),
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
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                      left: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue.shade600,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          // Vérifier si c'est une alerte
                          final isAlert = alertSpots.any((alertSpot) =>
                              (alertSpot.x - spot.x).abs() < 0.1 &&
                              (alertSpot.y - spot.y).abs() < 0.1);
                          
                          return FlDotCirclePainter(
                            radius: isAlert ? 6 : 4,
                            color: isAlert ? Colors.red : Colors.blue.shade600,
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
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blue.shade700,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          return LineTooltipItem(
                            '${(touchedSpot.y * 100).toStringAsFixed(1)}%',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Légende
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Score d\'anomalie',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Alerte détectée',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _capturePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.front, // Caméra frontale pour le visage
      );

      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo de votre visage capturée avec succès !'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }

        // Ici, vous pouvez ajouter la logique pour envoyer la photo au backend
        // await ApiService.uploadPatientPhoto(_patientId, _capturedImage!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la capture: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPhotoCaptureCard(BuildContext context, String Function(String) t) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zone d'affichage de la photo ou bouton de capture
          InkWell(
            onTap: _capturePhoto,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              width: double.infinity,
              height: _capturedImage != null ? 250 : 180,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: _capturedImage != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.file(
                            _capturedImage!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Overlay avec bouton pour reprendre
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.blue.shade600,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Appuyez pour reprendre',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.blue.shade600,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Prendre une photo de votre visage',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Appuyez pour ouvrir la caméra',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          // Section info et actions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.face,
                  color: Colors.blue.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _capturedImage != null
                        ? 'Photo de votre visage capturée'
                        : 'Capturez une photo de votre visage pour votre profil',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                if (_capturedImage != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade600),
                    onPressed: () {
                      setState(() {
                        _capturedImage = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Photo supprimée'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    tooltip: 'Supprimer la photo',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

