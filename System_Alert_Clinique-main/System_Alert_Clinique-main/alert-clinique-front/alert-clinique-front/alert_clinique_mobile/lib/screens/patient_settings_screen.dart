import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class PatientSettingsScreen extends StatefulWidget {
  const PatientSettingsScreen({super.key});

  @override
  State<PatientSettingsScreen> createState() => _PatientSettingsScreenState();
}

class _PatientSettingsScreenState extends State<PatientSettingsScreen> {
  Map<String, bool> _settings = {
    'emailNotifications': true,
    'pushNotifications': true,
    'smsNotifications': false,
    'appointmentReminders': true,
    'medicationReminders': true,
    'healthTips': true,
    'soundEnabled': true,
    'darkMode': false,
    'dataSharing': false,
    'twoFactorAuth': false,
  };

  void _handleToggle(String key) {
    setState(() {
      _settings[key] = !_settings[key]!;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paramètre mis à jour')),
    );
  }

  void _handlePasswordChange() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonction de changement de mot de passe - À implémenter')),
    );
  }

  void _handleExportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export des données en cours...')),
    );
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Cette action est irréversible. Êtes-vous sûr de vouloir supprimer votre compte ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonction de suppression - À implémenter')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
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
          title: Text(t('sidebar.settings')),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gérez vos préférences et paramètres de confidentialité',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              
              // Notifications
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications, color: Colors.blue.shade600),
                          const SizedBox(width: 8),
                          Text(
                            'Notifications',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Configurez comment vous souhaitez recevoir les notifications',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      _buildSwitchTile(
                        'Notifications par email',
                        'Recevoir les notifications importantes par email',
                        Icons.email,
                        'emailNotifications',
                      ),
                      const Divider(),
                      _buildSwitchTile(
                        'Notifications push',
                        'Recevoir les notifications sur votre appareil',
                        Icons.smartphone,
                        'pushNotifications',
                      ),
                      const Divider(),
                      _buildSwitchTile(
                        'Notifications SMS',
                        'Recevoir les alertes urgentes par SMS',
                        Icons.sms,
                        'smsNotifications',
                      ),
                      const Divider(),
                      _buildSwitchTile(
                        'Rappels de rendez-vous',
                        'Être notifié avant vos rendez-vous',
                        Icons.notifications,
                        'appointmentReminders',
                      ),
                      const Divider(),
                      _buildSwitchTile(
                        'Rappels de médicaments',
                        'Rappels pour prendre vos médicaments',
                        Icons.medication,
                        'medicationReminders',
                      ),
                      const Divider(),
                      _buildSwitchTile(
                        'Conseils santé',
                        'Recevoir des conseils de santé personnalisés',
                        Icons.health_and_safety,
                        'healthTips',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Language & Display
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.language, color: Colors.blue.shade600),
                          const SizedBox(width: 8),
                          Text(
                            'Langue et affichage',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Personnalisez l\'apparence de votre interface',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<AppLanguage>(
                        initialValue: languageProvider.language,
                        decoration: InputDecoration(
                          labelText: 'Langue',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: AppLanguage.fr,
                            child: Text('🇫🇷 Français'),
                          ),
                          DropdownMenuItem(
                            value: AppLanguage.ar,
                            child: Text('🇸🇦 العربية'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            languageProvider.setLanguage(value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      _buildSwitchTile(
                        'Mode sombre',
                        'Activer le thème sombre',
                        Icons.dark_mode,
                        'darkMode',
                      ),
                      const Divider(),
                      _buildSwitchTile(
                        'Son activé',
                        'Activer les sons de notification',
                        Icons.volume_up,
                        'soundEnabled',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Security & Privacy
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.security, color: Colors.blue.shade600),
                          const SizedBox(width: 8),
                          Text(
                            'Sécurité et confidentialité',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gérez vos paramètres de sécurité et de confidentialité',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Nouveau mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.lock),
                            onPressed: _handlePasswordChange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      _buildSwitchTile(
                        'Authentification à deux facteurs',
                        'Sécurisez votre compte avec 2FA',
                        Icons.security,
                        'twoFactorAuth',
                      ),
                      const Divider(),
                      _buildSwitchTile(
                        'Partage de données',
                        'Partager vos données pour la recherche médicale',
                        Icons.visibility,
                        'dataSharing',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Data Management
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.download, color: Colors.blue.shade600),
                          const SizedBox(width: 8),
                          Text(
                            'Gestion des données',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Exportez ou supprimez vos données personnelles',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Exporter mes données',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Téléchargez une copie de vos données médicales',
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _handleExportData,
                              icon: const Icon(Icons.download),
                              label: const Text('Exporter'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Supprimer mon compte',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Cette action est irréversible',
                                    style: TextStyle(color: Colors.red.shade600),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _handleDeleteAccount,
                              icon: const Icon(Icons.delete),
                              label: const Text('Supprimer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    String settingKey,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: _settings[settingKey]!,
        onChanged: (_) => _handleToggle(settingKey),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

