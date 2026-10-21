'use client';

import {
  BarChart3,
  Bell,
  BookOpenCheck,
  CalendarX,
  FileText,
  GraduationCap,
  LogOut,
  Megaphone,
  MessagesSquare,
  ScrollText,
  Settings,
  ShieldAlert,
  Users,
  Wallet,
} from 'lucide-react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { ReactNode, useEffect, useState } from 'react';
import { cn } from '@/components/ui';
import { useApi } from '@/lib/api';

interface Me {
  email: string;
  role: string;
  twoFactorEnabled: boolean;
}

const NAV: { href: string; label: string; icon: typeof Users; roles?: string[] }[] = [
  { href: '/', label: 'Tableau de bord', icon: BarChart3, roles: ['SUPER_ADMIN', 'DIRECTION', 'SCOLARITE', 'COMPTABLE'] },
  { href: '/students', label: 'Étudiants & familles', icon: GraduationCap, roles: ['SUPER_ADMIN', 'SCOLARITE'] },
  { href: '/finance', label: 'Finances', icon: Wallet, roles: ['SUPER_ADMIN', 'COMPTABLE', 'DIRECTION'] },
  { href: '/attendance', label: 'Justificatifs', icon: CalendarX, roles: ['SUPER_ADMIN', 'SCOLARITE'] },
  { href: '/grades', label: 'Notes', icon: BookOpenCheck, roles: ['SUPER_ADMIN', 'SCOLARITE', 'ENSEIGNANT'] },
  { href: '/requests', label: 'Démarches', icon: FileText, roles: ['SUPER_ADMIN', 'SCOLARITE'] },
  { href: '/discipline', label: 'Discipline', icon: ShieldAlert, roles: ['SUPER_ADMIN', 'SCOLARITE'] },
  { href: '/tickets', label: 'Messagerie', icon: MessagesSquare },
  { href: '/announcements', label: 'Annonces', icon: Megaphone, roles: ['SUPER_ADMIN', 'SCOLARITE', 'DIRECTION'] },
  { href: '/users', label: 'Personnel', icon: Users, roles: ['SUPER_ADMIN'] },
  { href: '/audit', label: 'Journal d’audit', icon: ScrollText, roles: ['SUPER_ADMIN', 'DIRECTION'] },
  { href: '/settings', label: 'Paramètres & droits', icon: Settings, roles: ['SUPER_ADMIN'] },
];

const ROLE_LABEL: Record<string, string> = {
  SUPER_ADMIN: 'Super administrateur',
  DIRECTION: 'Direction',
  SCOLARITE: 'Scolarité',
  COMPTABLE: 'Comptabilité',
  ENSEIGNANT: 'Enseignant',
  SUPPORT: 'Accueil / Support',
};

export default function AppLayout({ children }: { children: ReactNode }) {
  const pathname = usePathname();
  const { data: me } = useApi<Me>('me');
  const { data: unread } = useApi<{ count: number }>('notifications/unread-count', { refreshInterval: 60_000 });
  const [show2fa, setShow2fa] = useState(false);
  useEffect(() => setShow2fa(sessionStorage.getItem('up_2fa_setup') === '1'), []);

  const items = NAV.filter((n) => !n.roles || (me && n.roles.includes(me.role)));

  async function logout() {
    await fetch('/api/auth/logout', { method: 'POST' });
    sessionStorage.clear();
    window.location.href = '/login';
  }

  return (
    <div className="flex min-h-screen">
      <aside className="hidden w-64 shrink-0 flex-col bg-primary-dark text-white lg:flex">
        <div className="flex items-center gap-2 px-5 py-5">
          <GraduationCap className="h-7 w-7 text-gold" />
          <div>
            <p className="font-bold leading-tight">UniParent</p>
            <p className="text-xs text-white/60">Back-office AFRAM</p>
          </div>
        </div>
        <nav className="flex-1 space-y-0.5 px-3" aria-label="Navigation principale">
          {items.map(({ href, label, icon: Icon }) => {
            const active = href === '/' ? pathname === '/' : pathname.startsWith(href);
            return (
              <Link
                key={href}
                href={href}
                className={cn('flex items-center gap-3 rounded-lg px-3 py-2 text-sm transition-colors', active ? 'bg-white/15 font-semibold text-white' : 'text-white/75 hover:bg-white/10')}
              >
                <Icon className="h-4 w-4" /> {label}
              </Link>
            );
          })}
        </nav>
        <div className="border-t border-white/10 p-4 text-sm">
          <p className="truncate font-medium">{me?.email}</p>
          <p className="text-xs text-white/60">{me ? ROLE_LABEL[me.role] : ''}</p>
          <button onClick={logout} className="mt-3 flex items-center gap-2 text-white/75 hover:text-white">
            <LogOut className="h-4 w-4" /> Déconnexion
          </button>
        </div>
      </aside>
      <div className="flex min-w-0 flex-1 flex-col">
        <header className="flex h-14 items-center justify-between border-b border-border bg-surface px-6">
          <nav className="flex gap-3 overflow-x-auto text-sm lg:hidden">
            {items.map((n) => (
              <Link key={n.href} href={n.href} className="whitespace-nowrap text-subtle hover:text-fg">
                {n.label}
              </Link>
            ))}
          </nav>
          <div className="ml-auto flex items-center gap-2 text-sm text-subtle">
            <Bell className="h-4 w-4" aria-hidden />
            <span>{unread?.count ?? 0} notification(s)</span>
          </div>
        </header>
        {show2fa && me && !me.twoFactorEnabled && (
          <div className="bg-warning/15 px-6 py-2 text-sm text-warning">
            La double authentification est obligatoire pour votre rôle. <Link href="/settings/security" className="font-semibold underline">L’activer maintenant</Link>
          </div>
        )}
        <main className="flex-1 p-6 lg:p-8">{children}</main>
      </div>
    </div>
  );
}
