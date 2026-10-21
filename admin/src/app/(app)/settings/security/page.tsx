'use client';

import { useState } from 'react';
import { Button, Card, CardHeader, Field, Input, PageHeader } from '@/components/ui';
import { api, useApi } from '@/lib/api';

/** Activation de la double authentification (obligatoire pour l'administration). */
export default function SecurityPage() {
  const { data: me, mutate } = useApi<{ twoFactorEnabled: boolean; email: string }>('me');
  const [setup, setSetup] = useState<{ secret: string; otpauthUrl: string } | null>(null);
  const [code, setCode] = useState('');
  const [msg, setMsg] = useState<string | null>(null);

  async function start() {
    setSetup(await api('auth/2fa/setup', { method: 'POST' }));
  }

  async function enable() {
    try {
      await api('auth/2fa/enable', { method: 'POST', json: { code } });
      sessionStorage.removeItem('up_2fa_setup');
      setMsg('Double authentification activée. Elle sera demandée à chaque connexion.');
      setSetup(null);
      mutate();
    } catch (e) {
      setMsg((e as Error).message);
    }
  }

  return (
    <>
      <PageHeader title="Ma sécurité" description={me?.email} />
      <Card className="max-w-xl">
        <CardHeader title="Double authentification (TOTP)" description="Google Authenticator, Microsoft Authenticator, Authy…" />
        <div className="space-y-4 p-5 text-sm">
          {me?.twoFactorEnabled ? (
            <p className="rounded-lg bg-success/10 p-3 text-success">La double authentification est active sur votre compte.</p>
          ) : !setup ? (
            <Button onClick={start}>Configurer</Button>
          ) : (
            <>
              <p>1. Dans votre application d’authentification, ajoutez un compte avec cette clé :</p>
              <code className="block break-all rounded bg-muted p-3 text-base tracking-widest">{setup.secret}</code>
              <p className="text-xs text-subtle">Ou ouvrez ce lien sur le téléphone : <a className="break-all text-primary underline" href={setup.otpauthUrl}>{setup.otpauthUrl}</a></p>
              <Field label="2. Saisissez le code à 6 chiffres affiché">
                <Input inputMode="numeric" maxLength={6} value={code} onChange={(e) => setCode(e.target.value)} />
              </Field>
              <Button onClick={enable} disabled={code.length !== 6}>Activer</Button>
            </>
          )}
          {msg && <p>{msg}</p>}
        </div>
      </Card>
    </>
  );
}
