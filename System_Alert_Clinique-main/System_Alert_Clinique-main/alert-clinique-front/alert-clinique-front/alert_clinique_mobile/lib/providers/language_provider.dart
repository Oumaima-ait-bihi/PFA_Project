import 'package:flutter/material.dart';

enum AppLanguage {
  fr,
  ar,
}

class LanguageProvider with ChangeNotifier {
  AppLanguage _language = AppLanguage.fr;
  Locale _locale = const Locale('fr');

  AppLanguage get language => _language;
  Locale get locale => _locale;

  void setLanguage(AppLanguage lang) {
    _language = lang;
    _locale = Locale(lang == AppLanguage.fr ? 'fr' : 'ar');
    notifyListeners();
  }

  String t(String key) {
    return _translations[_language]![key] ?? key;
  }

  static const Map<AppLanguage, Map<String, String>> _translations = {
    AppLanguage.fr: {
      // Header
      'header.patient': 'Portail Patient',
      'header.doctor': 'Portail Médecin',
      'header.logout': 'Déconnexion',
      'header.notifications': 'Notifications',
      
      // Sidebar
      'sidebar.dashboard': 'Tableau de bord',
      'sidebar.alerts': 'Centre d\'alertes',
      'sidebar.patients': 'Patients',
      'sidebar.profile': 'Profil',
      'sidebar.settings': 'Paramètres',
      
      // Patient Dashboard
      'patient.welcome': 'Bienvenue',
      'patient.mood': 'Humeur',
      'patient.sleep': 'Sommeil',
      'patient.rhythm': 'Rythme cardiaque',
      'patient.recommendations': 'Recommandations',
      'patient.week': 'Cette semaine',
      'patient.hours': 'heures',
      'patient.bpm': 'bpm',
      'patient.advice.title': 'Conseils personnalisés',
      'patient.advice.1': 'Maintenez une routine de sommeil régulière',
      'patient.advice.2': 'Pratiquez des exercices de respiration quotidiens',
      'patient.advice.3': 'Suivez vos médicaments selon prescription',
      'patient.advice.4': 'Contactez votre médecin en cas d\'anomalie',
      
      // Doctor Dashboard
      'doctor.welcome': 'Tableau de bord médecin',
      'doctor.highRisk': 'Patients à risque élevé',
      'doctor.recentAlerts': 'Alertes récentes',
      'doctor.viewAll': 'Voir tout',
      'doctor.viewPatient': 'Voir le dossier',
      'doctor.urgentAction': 'Action urgente requise',
      'doctor.stats.total': 'Patients total',
      'doctor.stats.critical': 'Cas critiques',
      'doctor.stats.moderate': 'Risque modéré',
      
      // Patients List
      'patients.title': 'Liste des patients',
      'patients.search': 'Rechercher un patient...',
      'patients.filter': 'Filtrer',
      'patients.all': 'Tous',
      'patients.critical': 'Critique',
      'patients.high': 'Risque élevé',
      'patients.stable': 'Stable',
      'patients.age': 'ans',
      'patients.lastVisit': 'Dernière visite',
      'patients.condition': 'Condition',
      'patients.contact': 'Contacter',
      'patients.viewDetails': 'Voir détails',
      
      // Alert Center
      'alerts.title': 'Centre d\'alertes',
      'alerts.filter': 'Filtrer',
      'alerts.severity': 'Gravité',
      'alerts.status': 'Statut',
      'alerts.all': 'Toutes',
      'alerts.critical': 'Critique',
      'alerts.high': 'Élevé',
      'alerts.medium': 'Moyen',
      'alerts.low': 'Faible',
      'alerts.pending': 'En attente',
      'alerts.inProgress': 'En cours',
      'alerts.resolved': 'Résolue',
      
      // Login
      'login.noAccount': 'Pas encore de compte ? Créer un compte',
      
      // Signup
      'signup.title': 'Créer un compte',
      'signup.subtitle': 'Inscrivez-vous pour accéder au portail médical',
      'signup.patient': 'Patient',
      'signup.doctor': 'Médecin',
      'signup.name': 'Nom complet',
      'signup.nameDoctor': 'Nom complet',
      'signup.emailDoctor': 'Email professionnel',
      'signup.confirmPassword': 'Confirmer le mot de passe',
      'signup.createAccount': 'Créer mon compte',
      'signup.haveAccount': 'Vous avez déjà un compte ? Se connecter',
      'signup.terms': 'En créant un compte, vous acceptez nos conditions d\'utilisation',
      'signup.success': 'Compte créé avec succès !',
      'signup.error': 'Erreur lors de la création du compte',
      'signup.nameRequired': 'Veuillez entrer votre nom',
      'signup.emailRequired': 'Veuillez entrer votre email',
      'signup.emailInvalid': 'Email invalide',
      'signup.passwordRequired': 'Veuillez entrer votre mot de passe',
      'signup.passwordMinLength': 'Le mot de passe doit contenir au moins 6 caractères',
      'signup.confirmPasswordRequired': 'Veuillez confirmer votre mot de passe',
      'signup.passwordsNotMatch': 'Les mots de passe ne correspondent pas',
      
      // Common
      'common.login': 'Se connecter',
      'common.signup': 'S\'inscrire',
      'common.email': 'Email',
      'common.password': 'Mot de passe',
      'common.name': 'Nom',
      'common.search': 'Rechercher',
      'common.filter': 'Filtrer',
      'common.export': 'Exporter',
      'common.save': 'Enregistrer',
      'common.cancel': 'Annuler',
      
      // Days
      'days.mon': 'Lun',
      'days.tue': 'Mar',
      'days.wed': 'Mer',
      'days.thu': 'Jeu',
      'days.fri': 'Ven',
      'days.sat': 'Sam',
      'days.sun': 'Dim',
    },
    AppLanguage.ar: {
      // Header
      'header.patient': 'بوابة المريض',
      'header.doctor': 'بوابة الطبيب',
      'header.logout': 'تسجيل الخروج',
      'header.notifications': 'الإشعارات',
      
      // Sidebar
      'sidebar.dashboard': 'لوحة التحكم',
      'sidebar.alerts': 'مركز التنبيهات',
      'sidebar.patients': 'المرضى',
      'sidebar.profile': 'الملف الشخصي',
      'sidebar.settings': 'الإعدادات',
      
      // Patient Dashboard
      'patient.welcome': 'مرحبا',
      'patient.mood': 'المزاج',
      'patient.sleep': 'النوم',
      'patient.rhythm': 'نبضات القلب',
      'patient.recommendations': 'التوصيات',
      'patient.week': 'هذا الأسبوع',
      'patient.hours': 'ساعات',
      'patient.bpm': 'نبضة/دقيقة',
      'patient.advice.title': 'نصائح شخصية',
      'patient.advice.1': 'حافظ على روتين نوم منتظم',
      'patient.advice.2': 'مارس تمارين التنفس اليومية',
      'patient.advice.3': 'تناول الأدوية حسب الوصفة',
      'patient.advice.4': 'اتصل بطبيبك في حالة وجود أي شذوذ',
      
      // Doctor Dashboard
      'doctor.welcome': 'لوحة تحكم الطبيب',
      'doctor.highRisk': 'مرضى عالي الخطورة',
      'doctor.recentAlerts': 'التنبيهات الأخيرة',
      'doctor.viewAll': 'عرض الكل',
      'doctor.viewPatient': 'عرض الملف',
      'doctor.urgentAction': 'مطلوب إجراء عاجل',
      'doctor.stats.total': 'إجمالي المرضى',
      'doctor.stats.critical': 'حالات حرجة',
      'doctor.stats.moderate': 'خطر متوسط',
      
      // Patients List
      'patients.title': 'قائمة المرضى',
      'patients.search': 'البحث عن مريض...',
      'patients.filter': 'تصفية',
      'patients.all': 'الكل',
      'patients.critical': 'حرج',
      'patients.high': 'عالي الخطورة',
      'patients.stable': 'مستقر',
      'patients.age': 'سنة',
      'patients.lastVisit': 'آخر زيارة',
      'patients.condition': 'الحالة',
      'patients.contact': 'اتصال',
      'patients.viewDetails': 'عرض التفاصيل',
      
      // Alert Center
      'alerts.title': 'مركز التنبيهات',
      'alerts.filter': 'تصفية',
      'alerts.severity': 'الخطورة',
      'alerts.status': 'الحالة',
      'alerts.all': 'الكل',
      'alerts.critical': 'حرج',
      'alerts.high': 'عالي',
      'alerts.medium': 'متوسط',
      'alerts.low': 'منخفض',
      'alerts.pending': 'قيد الانتظار',
      'alerts.inProgress': 'قيد المعالجة',
      'alerts.resolved': 'تم الحل',
      
      // Login
      'login.noAccount': 'ليس لديك حساب؟ إنشاء حساب',
      
      // Signup
      'signup.title': 'إنشاء حساب',
      'signup.subtitle': 'سجل للوصول إلى البوابة الطبية',
      'signup.patient': 'مريض',
      'signup.doctor': 'طبيب',
      'signup.name': 'الاسم الكامل',
      'signup.nameDoctor': 'الاسم الكامل',
      'signup.emailDoctor': 'البريد الإلكتروني المهني',
      'signup.confirmPassword': 'تأكيد كلمة المرور',
      'signup.createAccount': 'إنشاء حسابي',
      'signup.haveAccount': 'لديك حساب بالفعل؟ تسجيل الدخول',
      'signup.terms': 'بإنشاء حساب، فإنك تقبل شروط الاستخدام الخاصة بنا',
      'signup.success': 'تم إنشاء الحساب بنجاح!',
      'signup.error': 'خطأ في إنشاء الحساب',
      'signup.nameRequired': 'الرجاء إدخال اسمك',
      'signup.emailRequired': 'الرجاء إدخال بريدك الإلكتروني',
      'signup.emailInvalid': 'بريد إلكتروني غير صالح',
      'signup.passwordRequired': 'الرجاء إدخال كلمة المرور',
      'signup.passwordMinLength': 'يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل',
      'signup.confirmPasswordRequired': 'الرجاء تأكيد كلمة المرور',
      'signup.passwordsNotMatch': 'كلمات المرور غير متطابقة',
      
      // Common
      'common.login': 'تسجيل الدخول',
      'common.signup': 'إنشاء حساب',
      'common.email': 'البريد الإلكتروني',
      'common.password': 'كلمة المرور',
      'common.name': 'الاسم',
      'common.search': 'بحث',
      'common.filter': 'تصفية',
      'common.export': 'تصدير',
      'common.save': 'حفظ',
      'common.cancel': 'إلغاء',
      
      // Days
      'days.mon': 'الإثنين',
      'days.tue': 'الثلاثاء',
      'days.wed': 'الأربعاء',
      'days.thu': 'الخميس',
      'days.fri': 'الجمعة',
      'days.sat': 'السبت',
      'days.sun': 'الأحد',
    },
  };
}

