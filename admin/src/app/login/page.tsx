'use client';

import { FlaskConical, GraduationCap, LogIn, ShieldCheck } from 'lucide-react';
import { useRouter, useSearchParams } from 'next/navigation';
import { FormEvent, Suspense, useState } from 'react';
import { Button, Field, Input } from '@/components/ui';

/** Connexion en un clic — uniquement si NEXT_PUBLIC_DEMO_ACCOUNTS=true (jamais en production). */
const DEMO_ENABLED = process.env.NEXT_PUBLIC_DEMO_ACCOUNTS === 'true';
const DEMO_PASSWORD = 'Afram2026!';
const DEMO_ACCOUNTS = [
  { label: 'Super administrateur', identifier: 'admin@aframgabon.com' },
  { label: 'Direction', identifier: 'direction@aframgabon.com' },
  { label: 'Scolarité', identifier: 'scolarite@aframgabon.com' },
  { label: 'Comptabilité', identifier: 'comptable@aframgabon.com' },
  { label: 'Enseignant — Patrick NDONG', identifier: 'p.ndong@aframgabon.com' },
  { label: 'Accueil / Support', identifier: 'support@aframgabon.com' },
];

function LoginForm() {
  const router = useRouter();
  const next = useSearchParams().get('next') ?? '/';
  const [identifier, setIdentifier] = useState('');
  const [password, setPassword] = useState('');
  const [totpCode, setTotp] = useState('');
  const [needsTotp, setNeedsTotp] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function submit(e?: FormEvent, account?: { identifier: string; password: string }) {
    e?.preventDefault();
    setLoading(true);
    setError(null);
    try {
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(account ?? { identifier, password, totpCode }),
      });
      const data = await res.json();
      if (!res.ok) {
        if (data.code === 'TWO_FACTOR_REQUIRED') {
          setNeedsTotp(true);
          setError('Saisissez le code de votre application d’authentification.');
        } else setError(data.message ?? 'Connexion impossible');
        return;
      }
      sessionStorage.setItem('up_user', JSON.stringify(data.user));
      if (data.twoFactorSetupRequired) sessionStorage.setItem('up_2fa_setup', '1');
      router.replace(next.startsWith('/') ? next : '/');
    } finally {
      setLoading(false);
    }
  }

  return (
    <form onSubmit={submit} className="w-full max-w-sm space-y-5 rounded-2xl border border-border bg-surface p-8 shadow-lg">
      <div className="text-center">
        <div className="mx-auto mb-3 flex h-14 w-14 items-center justify-center rounded-full bg-primary text-white">
          <GraduationCap className="h-7 w-7" />
        </div>
        <h1 className="text-xl font-bold">UniParent — Administration</h1>
        <p className="text-sm text-subtle">AFRAM Business School</p>
      </div>
      <Field label="Email professionnel">
        <Input type="email" autoComplete="username" required value={identifier} onChange={(e) => setIdentifier(e.target.value)} />
      </Field>
      <Field label="Mot de passe">
        <Input type="password" autoComplete="current-password" required value={password} onChange={(e) => setPassword(e.target.value)} />
      </Field>
      {needsTotp && (
        <Field label="Code de double authentification">
          <Input inputMode="numeric" pattern="\d{6}" maxLength={6} autoFocus required value={totpCode} onChange={(e) => setTotp(e.target.value)} />
        </Field>
      )}
      {error && <p className="rounded-lg bg-danger/10 p-3 text-sm text-danger" role="alert">{error}</p>}
      <Button type="submit" loading={loading} className="w-full">
        Se connecter
      </Button>
      <p className="flex items-center justify-center gap-1.5 text-xs text-subtle">
        <ShieldCheck className="h-3.5 w-3.5" /> Accès réservé au personnel · actions journalisées
      </p>
      {DEMO_ENABLED && (
        <div className="space-y-2 rounded-xl border border-gold/50 bg-gold/5 p-3">
          <p className="flex items-center gap-2 text-sm font-semibold">
            <FlaskConical className="h-4 w-4 text-gold" /> Comptes de démonstration
          </p>
          <p className="text-xs text-subtle">Cliquez pour vous connecter (mot de passe {DEMO_PASSWORD})</p>
          {DEMO_ACCOUNTS.map((a) => (
            <button
              key={a.identifier}
              type="button"
              disabled={loading}
              onClick={() => submit(undefined, { identifier: a.identifier, password: DEMO_PASSWORD })}
              className="flex w-full items-center justify-between gap-3 rounded-lg border border-border bg-surface px-3 py-2 text-left text-sm hover:border-primary hover:bg-muted disabled:opacity-50"
            >
              <span>
                <span className="block font-medium">{a.label}</span>
                <span className="block text-xs text-subtle">{a.identifier}</span>
              </span>
              <LogIn className="h-4 w-4 shrink-0 text-primary" />
            </button>
          ))}
        </div>
      )}
    </form>
  );
}

export default function LoginPage() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-gradient-to-br from-primary to-primary-dark p-4">
      <Suspense>
        <LoginForm />
      </Suspense>
    </main>
  );
}
