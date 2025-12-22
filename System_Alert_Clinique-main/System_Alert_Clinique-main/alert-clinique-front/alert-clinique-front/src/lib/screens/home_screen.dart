import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../models/user.dart';
import 'patient_dashboard_screen.dart';
import 'doctor_dashboard_screen.dart';
import 'alert_center_screen.dart';
import 'patient_profile_screen.dart';
import 'patient_settings_screen.dart';
import 'patients_list_screen.dart';
import 'doctor_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _activeView = 'dashboard';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final user = authProvider.user;
    final t = languageProvider.t;
    final isRTL = languageProvider.language == AppLanguage.ar;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isDoctor = user.role == UserRole.doctor;

    List<NavigationItem> navigationItems;
    if (isDoctor) {
      navigationItems = [
        NavigationItem(
          icon: Icons.dashboard,
          label: t('sidebar.dashboard'),
          view: 'dashboard',
        ),
        NavigationItem(
          icon: Icons.warning,
          label: t('sidebar.alerts'),
          view: 'alerts',
        ),
        NavigationItem(
          icon: Icons.people,
          label: t('sidebar.patients'),
          view: 'patients',
        ),
        NavigationItem(
          icon: Icons.person,
          label: t('sidebar.profile'),
          view: 'profile',
        ),
      ];
    } else {
      navigationItems = [
        NavigationItem(
          icon: Icons.dashboard,
          label: t('sidebar.dashboard'),
          view: 'dashboard',
        ),
        NavigationItem(
          icon: Icons.person,
          label: t('sidebar.profile'),
          view: 'profile',
        ),
        NavigationItem(
          icon: Icons.settings,
          label: t('sidebar.settings'),
          view: 'settings',
        ),
      ];
    }

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isDoctor ? t('header.doctor') : t('header.patient'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                _showLanguageDialog(context, languageProvider);
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: CircleAvatar(
                child: Text(user.name[0].toUpperCase()),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text(user.name),
                  enabled: false,
                ),
                const PopupMenuItem(
                  child: Divider(),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(Icons.logout),
                      const SizedBox(width: 8),
                      Text(t('header.logout')),
                    ],
                  ),
                  onTap: () {
                    authProvider.logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Text(user.name[0].toUpperCase()),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ...navigationItems.map((item) {
                final isSelected = _activeView == item.view;
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isSelected ? Colors.blue.shade600 : null,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.blue.shade600 : null,
                    ),
                  ),
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      _activeView = item.view;
                      _currentIndex = navigationItems.indexWhere((i) => i.view == item.view);
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        ),
        body: _buildBody(_activeView, isDoctor),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _activeView = navigationItems[index].view;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: navigationItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBody(String view, bool isDoctor) {
    if (isDoctor) {
      switch (view) {
        case 'dashboard':
          return const DoctorDashboardScreen();
        case 'alerts':
          return const AlertCenterScreen();
        case 'patients':
          return const PatientsListScreen();
        case 'profile':
          return const DoctorProfileScreen();
        default:
          return const DoctorDashboardScreen();
      }
    } else {
      switch (view) {
        case 'dashboard':
          return const PatientDashboardScreen();
        case 'profile':
          return const PatientProfileScreen();
        case 'settings':
          return const PatientSettingsScreen();
        default:
          return const PatientDashboardScreen();
      }
    }
  }

  void _showLanguageDialog(
    BuildContext context,
    LanguageProvider languageProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Français'),
              leading: Radio<AppLanguage>(
                value: AppLanguage.fr,
                groupValue: languageProvider.language,
                onChanged: (value) {
                  languageProvider.setLanguage(value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('العربية'),
              leading: Radio<AppLanguage>(
                value: AppLanguage.ar,
                groupValue: languageProvider.language,
                onChanged: (value) {
                  languageProvider.setLanguage(value!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String view;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.view,
  });
}

