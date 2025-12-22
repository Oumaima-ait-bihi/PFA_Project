import React, { createContext, useContext, useState } from 'react';

type Language = 'fr' | 'ar';

interface LanguageContextType {
  language: Language;
  setLanguage: (lang: Language) => void;
  t: (key: string) => string;
}

const translations = {
  fr: {
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
    
    // Profile
    'profile.title': 'Mon profil',
    'profile.edit': 'Modifier',
    'profile.save': 'Enregistrer',
    'profile.personalInfo': 'Informations personnelles',
    'profile.professionalInfo': 'Informations professionnelles',
    'profile.specialty': 'Spécialité',
    'profile.license': 'Numéro de licence',
    'profile.hospital': 'Établissement',
    'profile.experience': 'Années d\'expérience',
    'profile.languages': 'Langues parlées',
    'profile.education': 'Formation',
    'profile.certifications': 'Certifications',
    
    // Notifications
    'notif.title': 'Notifications',
    'notif.markAllRead': 'Tout marquer comme lu',
    'notif.clear': 'Effacer',
    'notif.noNew': 'Aucune nouvelle notification',
    'notif.viewAll': 'Voir toutes',
    
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
    'alerts.acknowledge': 'Accuser réception',
    'alerts.resolve': 'Résoudre',
    'alerts.assign': 'Assigner',
    'alerts.patient': 'Patient',
    
    // Common
    'common.edit': 'Modifier',
    'common.save': 'Enregistrer',
    'common.cancel': 'Annuler',
    'common.delete': 'Supprimer',
    'common.search': 'Rechercher',
    'common.filter': 'Filtrer',
    'common.export': 'Exporter',
    
    // Days
    'days.mon': 'Lun',
    'days.tue': 'Mar',
    'days.wed': 'Mer',
    'days.thu': 'Jeu',
    'days.fri': 'Ven',
    'days.sat': 'Sam',
    'days.sun': 'Dim',
  },
  ar: {
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
    
    // Profile
    'profile.title': 'ملفي الشخصي',
    'profile.edit': 'تعديل',
    'profile.save': 'حفظ',
    'profile.personalInfo': 'المعلومات الشخصية',
    'profile.professionalInfo': 'المعلومات المهنية',
    'profile.specialty': 'التخصص',
    'profile.license': 'رقم الترخيص',
    'profile.hospital': 'المؤسسة',
    'profile.experience': 'سنوات الخبرة',
    'profile.languages': 'اللغات المتحدثة',
    'profile.education': 'التعليم',
    'profile.certifications': 'الشهادات',
    
    // Notifications
    'notif.title': 'الإشعارات',
    'notif.markAllRead': 'تحديد الكل كمقروء',
    'notif.clear': 'مسح',
    'notif.noNew': 'لا توجد إشعارات جديدة',
    'notif.viewAll': 'عرض الكل',
    
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
    'alerts.acknowledge': 'إقرار الاستلام',
    'alerts.resolve': 'حل',
    'alerts.assign': 'تعيين',
    'alerts.patient': 'المريض',
    
    // Common
    'common.edit': 'تعديل',
    'common.save': 'حفظ',
    'common.cancel': 'إلغاء',
    'common.delete': 'حذف',
    'common.search': 'بحث',
    'common.filter': 'تصفية',
    'common.export': 'تصدير',
    
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

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export function LanguageProvider({ children }: { children: React.ReactNode }) {
  const [language, setLanguage] = useState<Language>('fr');

  const t = (key: string): string => {
    return translations[language][key as keyof typeof translations.fr] || key;
  };

  return (
    <LanguageContext.Provider value={{ language, setLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
}