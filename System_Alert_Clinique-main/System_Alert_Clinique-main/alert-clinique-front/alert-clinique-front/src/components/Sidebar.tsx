import {
  LayoutDashboard,
  AlertTriangle,
  Users,
  UserCircle,
  Settings,
} from "lucide-react";
import { cn } from "../lib/utils";
import { useLanguage } from "../contexts/LanguageContext";

interface SidebarProps {
  userRole: "patient" | "doctor";
  activeView: string;
  onViewChange: (view: string) => void;
}

export function Sidebar({
  userRole,
  activeView,
  onViewChange,
}: SidebarProps) {
  const { t, language } = useLanguage();

  const patientMenuItems = [
    {
      id: "dashboard",
      icon: LayoutDashboard,
      label: t("sidebar.dashboard"),
    },
    {
      id: "profile",
      icon: UserCircle,
      label: t("sidebar.profile"),
    },
    {
      id: "settings",
      icon: Settings,
      label: t("sidebar.settings"),
    },
  ];

  const doctorMenuItems = [
    {
      id: "dashboard",
      icon: LayoutDashboard,
      label: t("sidebar.dashboard"),
    },
    {
      id: "alerts",
      icon: AlertTriangle,
      label: t("sidebar.alerts"),
    },
    {
      id: "patients",
      icon: Users,
      label: t("sidebar.patients"),
    },
    {
      id: "profile",
      icon: UserCircle,
      label: t("sidebar.profile"),
    },
    {
      id: "settings",
      icon: Settings,
      label: t("sidebar.settings"),
    },
  ];

  const menuItems =
    userRole === "patient" ? patientMenuItems : doctorMenuItems;

  return (
    <aside
      className={cn(
        "w-64 border-r bg-slate-50 p-4",
        language === "ar" && "border-l border-r-0",
      )}
      dir={language === "ar" ? "rtl" : "ltr"}
    >
      <nav className="space-y-2">
        {menuItems.map((item) => {
          const Icon = item.icon;
          return (
            <button
              key={item.id}
              onClick={() => onViewChange(item.id)}
              className={cn(
                "flex w-full items-center gap-3 rounded-lg px-4 py-3 transition-colors",
                activeView === item.id
                  ? "bg-blue-600 text-white"
                  : "text-slate-700 hover:bg-slate-200",
              )}
            >
              <Icon className="h-5 w-5" />
              <span>{item.label}</span>
            </button>
          );
        })}
      </nav>
    </aside>
  );
}