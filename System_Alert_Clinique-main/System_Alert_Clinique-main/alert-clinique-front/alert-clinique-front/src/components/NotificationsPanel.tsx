import { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Button } from './ui/button';
import { Badge } from './ui/badge';
import { ScrollArea } from './ui/scroll-area';
import { useLanguage } from '../contexts/LanguageContext';
import { toast } from 'sonner';
import { 
  Bell, 
  CheckCheck, 
  Trash2, 
  AlertTriangle, 
  Calendar,
  MessageSquare,
  UserPlus,
  Clock
} from 'lucide-react';
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from './ui/sheet';

interface Notification {
  id: number;
  type: 'alert' | 'appointment' | 'message' | 'patient';
  title: string;
  message: string;
  time: string;
  read: boolean;
  severity?: 'critical' | 'high' | 'medium' | 'low';
}

const mockNotifications: Notification[] = [
  {
    id: 1,
    type: 'alert',
    title: 'Alerte critique',
    message: 'Sophie Martin - Pression artérielle élevée détectée',
    time: '5 min',
    read: false,
    severity: 'critical',
  },
  {
    id: 2,
    type: 'appointment',
    title: 'Rendez-vous',
    message: 'Consultation avec Ahmed Benali dans 30 minutes',
    time: '25 min',
    read: false,
  },
  {
    id: 3,
    type: 'message',
    title: 'Nouveau message',
    message: 'Dr. Martin a commenté sur le dossier de Jean Lefebvre',
    time: '1h',
    read: false,
  },
  {
    id: 4,
    type: 'patient',
    title: 'Nouveau patient',
    message: 'Fatima Alaoui a été assignée à votre service',
    time: '2h',
    read: false,
  },
  {
    id: 5,
    type: 'alert',
    title: 'Alerte',
    message: 'Pierre Durand - Médication non prise',
    time: '3h',
    read: true,
    severity: 'medium',
  },
  {
    id: 6,
    type: 'appointment',
    title: 'Rappel',
    message: 'Consultation de suivi avec Marie Dubois demain à 10h',
    time: '5h',
    read: true,
  },
];

const getNotificationIcon = (type: string) => {
  switch (type) {
    case 'alert':
      return <AlertTriangle className="h-5 w-5 text-red-600" />;
    case 'appointment':
      return <Calendar className="h-5 w-5 text-blue-600" />;
    case 'message':
      return <MessageSquare className="h-5 w-5 text-purple-600" />;
    case 'patient':
      return <UserPlus className="h-5 w-5 text-green-600" />;
    default:
      return <Bell className="h-5 w-5" />;
  }
};

const getSeverityColor = (severity?: string) => {
  switch (severity) {
    case 'critical':
      return 'bg-red-100 border-red-200';
    case 'high':
      return 'bg-orange-100 border-orange-200';
    case 'medium':
      return 'bg-yellow-100 border-yellow-200';
    case 'low':
      return 'bg-green-100 border-green-200';
    default:
      return 'bg-slate-50 border-slate-200';
  }
};

export function NotificationsPanel({ notifications: notifCount }: { notifications: number }) {
  const { t } = useLanguage();
  const [notifications, setNotifications] = useState<Notification[]>(mockNotifications);
  const [open, setOpen] = useState(false);

  const unreadCount = notifications.filter(n => !n.read).length;

  const handleMarkAllRead = () => {
    setNotifications(notifications.map(n => ({ ...n, read: true })));
    toast.success(t('notif.markAllRead'));
  };

  const handleClearNotification = (id: number) => {
    setNotifications(notifications.filter(n => n.id !== id));
    toast.success(t('notif.clear'));
  };

  const handleNotificationClick = (id: number) => {
    setNotifications(notifications.map(n => 
      n.id === id ? { ...n, read: true } : n
    ));
  };

  return (
    <Sheet open={open} onOpenChange={setOpen}>
      <SheetTrigger asChild>
        <Button variant="ghost" size="icon" className="relative">
          <Bell className="h-5 w-5" />
          {unreadCount > 0 && (
            <Badge
              variant="destructive"
              className="absolute -right-1 -top-1 h-5 w-5 rounded-full p-0 flex items-center justify-center"
            >
              {unreadCount}
            </Badge>
          )}
        </Button>
      </SheetTrigger>
      <SheetContent className="w-full sm:max-w-md">
        <SheetHeader>
          <SheetTitle className="flex items-center gap-2">
            <Bell className="h-5 w-5" />
            {t('notif.title')}
          </SheetTitle>
          <SheetDescription>
            {unreadCount > 0 
              ? `${unreadCount} nouvelle${unreadCount > 1 ? 's' : ''} notification${unreadCount > 1 ? 's' : ''}`
              : t('notif.noNew')
            }
          </SheetDescription>
        </SheetHeader>

        <div className="mt-4 flex gap-2">
          <Button 
            variant="outline" 
            size="sm" 
            onClick={handleMarkAllRead}
            disabled={unreadCount === 0}
            className="flex-1"
          >
            <CheckCheck className="mr-2 h-4 w-4" />
            {t('notif.markAllRead')}
          </Button>
        </div>

        <ScrollArea className="h-[calc(100vh-200px)] mt-4">
          <div className="space-y-3">
            {notifications.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-12 text-center">
                <Bell className="h-12 w-12 text-slate-300 mb-4" />
                <p className="text-slate-500">{t('notif.noNew')}</p>
              </div>
            ) : (
              notifications.map((notif) => (
                <Card 
                  key={notif.id}
                  className={`cursor-pointer transition-all hover:shadow-md ${
                    !notif.read ? 'border-l-4 border-l-blue-600' : ''
                  } ${getSeverityColor(notif.severity)}`}
                  onClick={() => handleNotificationClick(notif.id)}
                >
                  <CardContent className="p-4">
                    <div className="flex items-start gap-3">
                      <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-white">
                        {getNotificationIcon(notif.type)}
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-start justify-between gap-2 mb-1">
                          <p className={`text-slate-900 ${!notif.read ? '' : ''}`}>
                            {notif.title}
                          </p>
                          {!notif.read && (
                            <Badge className="bg-blue-600 text-white shrink-0">
                              Nouveau
                            </Badge>
                          )}
                        </div>
                        <p className="text-slate-600 mb-2 break-words">
                          {notif.message}
                        </p>
                        <div className="flex items-center justify-between">
                          <div className="flex items-center gap-1 text-slate-500">
                            <Clock className="h-3 w-3" />
                            <span>Il y a {notif.time}</span>
                          </div>
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={(e) => {
                              e.stopPropagation();
                              handleClearNotification(notif.id);
                            }}
                            className="h-8 w-8 p-0"
                          >
                            <Trash2 className="h-4 w-4 text-slate-400" />
                          </Button>
                        </div>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))
            )}
          </div>
        </ScrollArea>
      </SheetContent>
    </Sheet>
  );
}
