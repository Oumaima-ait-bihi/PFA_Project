import { Bell, User, LogOut, Languages } from 'lucide-react';
import { Button } from './ui/button';
import { Badge } from './ui/badge';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from './ui/dropdown-menu';
import { useLanguage } from '../contexts/LanguageContext';
import { useAuth } from '../contexts/AuthContext';
import { NotificationsPanel } from './NotificationsPanel';
import { Logo } from './Logo';
import { toast } from 'sonner';

interface HeaderProps {
  userRole: 'patient' | 'doctor' | 'admin';
  userName?: string;
  notifications?: number;
}

export function Header({ userRole, userName = 'Utilisateur', notifications = 0 }: HeaderProps) {
  const { language, setLanguage, t } = useLanguage();
  const { logout } = useAuth();

  const handleLogout = () => {
    logout();
    toast.success('Déconnexion réussie');
  };

  return (
    <header className="sticky top-0 z-50 w-full border-b bg-white">
      <div className="flex h-16 items-center justify-between px-6">
        <div className="flex items-center gap-3">
          <Logo size="sm" showText={false} />
          <div className="ml-2">
            <h1 className="text-sm font-semibold text-slate-700">
              {userRole === 'patient' 
                ? t('header.patient') 
                : userRole === 'admin'
                ? 'Administration'
                : t('header.doctor')}
            </h1>
          </div>
        </div>

        <div className="flex items-center gap-4">
          {/* Language Switcher */}
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="sm" className="gap-2">
                <Languages className="h-4 w-4" />
                <span className="uppercase">{language}</span>
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onClick={() => setLanguage('fr')}>
                Français
              </DropdownMenuItem>
              <DropdownMenuItem onClick={() => setLanguage('ar')}>
                العربية
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>

          {/* Notifications Panel */}
          <NotificationsPanel notifications={notifications} />

          {/* User Menu */}
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" className="gap-2">
                <User className="h-5 w-5" />
                <span>{userName}</span>
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem>
                <User className="mr-2 h-4 w-4" />
                {t('sidebar.profile')}
              </DropdownMenuItem>
              <DropdownMenuItem onClick={handleLogout}>
                <LogOut className="mr-2 h-4 w-4" />
                {t('header.logout')}
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
    </header>
  );
}