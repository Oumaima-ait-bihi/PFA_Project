import {
  LayoutDashboard,
  Users,
  UserCheck,
  AlertTriangle,
} from "lucide-react";
import { cn } from "../lib/utils";
import { Logo } from "./Logo";

interface AdminSidebarProps {
  activeView: string;
  onViewChange: (view: string) => void;
}

export function AdminSidebar({
  activeView,
  onViewChange,
}: AdminSidebarProps) {
  const menuItems = [
    {
      id: "dashboard",
      icon: LayoutDashboard,
      label: "Tableau de bord",
    },
    {
      id: "doctors",
      icon: UserCheck,
      label: "Médecins",
    },
    {
      id: "patients",
      icon: Users,
      label: "Patients",
    },
    {
      id: "alerts",
      icon: AlertTriangle,
      label: "Alertes",
    },
  ];

  return (
    <aside className="w-64 border-r bg-slate-50 p-4">
      <div className="mb-6 flex flex-col items-center">
        <Logo size="sm" showText={true} />
        <p className="text-xs text-slate-600 mt-2">Administration</p>
      </div>
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

