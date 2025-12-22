import 'dart:typed_data'; // Nécessaire pour Uint8List
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // Assurez-vous d'avoir ajouté image_picker dans pubspec.yaml
import '../providers/language_provider.dart';

class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final t = languageProvider.t;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('patient.welcome')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('patient.week'),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 24),
            
            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildMoodCard(context, t),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSleepCard(context, t),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildHeartRateCard(context, t),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Recommendations
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
                      children: [
                        Icon(Icons.lightbulb, color: Colors.blue.shade600),
                        const SizedBox(width: 8),
                        Text(
                          t('patient.advice.title'),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(4, (index) {
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
                                t('patient.advice.${index + 1}'),
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
            ),
            const SizedBox(height: 24),

            // Section de capture de photo intégrée
            _CaptureCard(t: t),
          ],
        ),
      ),
    );
  }

  // --- Graphiques ---

  Widget _buildMoodCard(BuildContext context, String Function(String) t) {
    final moodData = [
      {'day': 'Lun', 'value': 7.0},
      {'day': 'Mar', 'value': 6.0},
      {'day': 'Mer', 'value': 8.0},
      {'day': 'Jeu', 'value': 7.0},
      {'day': 'Ven', 'value': 9.0},
      {'day': 'Sam', 'value': 8.0},
      {'day': 'Dim', 'value': 7.0},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.sentiment_satisfied, color: Colors.amber.shade600, size: 20),
                ),
                const SizedBox(width: 8),
                Text(t('patient.mood'), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: moodData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value['value'] as double)).toList(),
                      isCurved: true,
                      color: Colors.amber.shade600,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  minY: 0, maxY: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepCard(BuildContext context, String Function(String) t) {
    final sleepData = [
      {'day': 'Lun', 'hours': 7.5},
      {'day': 'Mar', 'hours': 6.2},
      {'day': 'Mer', 'hours': 8.1},
      {'day': 'Jeu', 'hours': 7.8},
      {'day': 'Ven', 'hours': 6.5},
      {'day': 'Sam', 'hours': 8.5},
      {'day': 'Dim', 'hours': 7.9},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.bedtime, color: Colors.purple.shade600, size: 20),
                ),
                const SizedBox(width: 8),
                Text(t('patient.sleep'), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: sleepData.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value['hours'] as double,
                          color: Colors.purple.shade600,
                          width: 12,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }).toList(),
                  minY: 0, maxY: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeartRateCard(BuildContext context, String Function(String) t) {
    final heartRateData = [
      {'day': 'Lun', 'bpm': 72.0},
      {'day': 'Mar', 'bpm': 75.0},
      {'day': 'Mer', 'bpm': 68.0},
      {'day': 'Jeu', 'bpm': 71.0},
      {'day': 'Ven', 'bpm': 74.0},
      {'day': 'Sam', 'bpm': 69.0},
      {'day': 'Dim', 'bpm': 70.0},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.favorite, color: Colors.red.shade600, size: 20),
                ),
                const SizedBox(width: 8),
                Text(t('patient.rhythm'), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: heartRateData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value['bpm'] as double)).toList(),
                      isCurved: true,
                      color: Colors.red.shade600,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  minY: 60, maxY: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Nouveau Widget de Capture ---

class _CaptureCard extends StatefulWidget {
  const _CaptureCard({required this.t});

  final String Function(String) t;

  @override
  State<_CaptureCard> createState() => _CaptureCardState();
}

class _CaptureCardState extends State<_CaptureCard> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  bool _isCapturing = false;

  Future<void> _takePhoto() async {
    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        if (!mounted) return;
        setState(() {
          _imageBytes = bytes;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.t('patient.capture.saved'))),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.t('patient.capture.error'))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.camera_alt,
                      color: Colors.blue.shade700, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.t('patient.capture.title'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.t('patient.capture.subtitle'),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isCapturing ? null : _takePhoto,
                  icon: const Icon(Icons.camera),
                  label: Text(widget.t('patient.capture.button')),
                ),
                if (_isCapturing) ...[
                  const SizedBox(width: 12),
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _imageBytes == null
                  ? Text(
                      widget.t('patient.capture.empty'),
                      key: const ValueKey('empty_text'),
                      style: TextStyle(color: Colors.grey.shade600),
                    )
                  : ClipRRect(
                      key: const ValueKey('image_display'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey.shade100,
                        child: Image.memory(
                          _imageBytes!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}