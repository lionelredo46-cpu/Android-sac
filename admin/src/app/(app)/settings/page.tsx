'use client';

import Link from 'next/link';
import { useState } from 'react';
import { Button, Card, CardHeader, Input, Loading, PageHeader, Table, Td } from '@/components/ui';
import { api, useApi } from '@/lib/api';

interface Permissions {
  catalogue: string[];
  matrice: Record<string, string[]>;
}

interface Setting {
  key: string;
  value: unknown;
}

const ROLES = ['DIRECTION', 'SCOLARITE', 'COMPTABLE', 'ENSEIGNANT', 'SUPPORT', 'PARENT', 'ETUDIANT'];

/** Paramétrage : matrice RBAC modifiable sans redéploiement + paramètres applicatifs. */
export default function SettingsPage() {
  const perms = useApi<Permissions>('admin/permissions');
  const settings = useApi<Setting[]>('admin/settings');
  const [draft, setDraft] = useState<Record<string, string[]> | null>(null);
  const [saving, setSaving] = useState<string | null>(null);
  const matrix = draft ?? perms.data?.matrice;

  function toggle(role: string, p: string) {
    const m = { ...(matrix ?? {}) };
    const set = new Set(m[role] ?? []);
    set.has(p) ? set.delete(p) : set.add(p);
    m[role] = [...set];
    setDraft(m);
  }

  async function saveRole(role: string) {
    setSaving(role);
    try {
      await api(`admin/permissions/${role}`, { method: 'PUT', json: { permissions: matrix?.[role] ?? [] } });
      await perms.mutate();
    } catch (e) {
      alert((e as Error).message);
    } finally {
      setSaving(null);
    }
  }

  async function saveSetting(key: string, raw: string) {
    let value: unknown;
    try {
      value = JSON.parse(raw);
    } catch {
      return alert('Valeur JSON invalide');
    }
    await api(`admin/settings/${encodeURIComponent(key)}`, { method: 'PUT', json: { value } });
    settings.mutate();
  }

  return (
    <>
      <PageHeader title="Paramètres & droits" description="Les modifications sont journalisées et appliquées immédiatement" action={<Link href="/settings/security"><Button variant="outline">Ma sécurité (2FA)</Button></Link>} />
      <Card>
        <CardHeader title="Matrice des permissions (RBAC)" description="Le super administrateur dispose de tous les droits" />
        {!perms.data || !matrix ? <Loading /> : (
          <Table head={['Permission', ...ROLES]}>
            {perms.data.catalogue.map((p) => (
              <tr key={p}>
                <Td className="font-mono text-xs">{p}</Td>
                {ROLES.map((r) => (
                  <Td key={r} className="text-center">
                    <input type="checkbox" aria-label={`${r} : ${p}`} checked={matrix[r]?.includes(p) ?? false} onChange={() => toggle(r, p)} />
                  </Td>
                ))}
              </tr>
            ))}
            <tr>
              <Td>{''}</Td>
              {ROLES.map((r) => (
                <Td key={r}>
                  <Button size="sm" variant="outline" loading={saving === r} disabled={!draft} onClick={() => saveRole(r)}>Enregistrer</Button>
                </Td>
              ))}
            </tr>
          </Table>
        )}
      </Card>

      <Card className="mt-6">
        <CardHeader title="Paramètres applicatifs" description="Seuil d’alerte d’absences, paiement par l’étudiant, rang visible, heures calmes, charte graphique…" />
        {!settings.data ? <Loading /> : (
          <Table head={['Clé', 'Valeur (JSON)', '']}>
            {settings.data.map((s) => <SettingRow key={s.key} s={s} onSave={saveSetting} />)}
          </Table>
        )}
      </Card>
    </>
  );
}

function SettingRow({ s, onSave }: { s: Setting; onSave: (k: string, v: string) => void }) {
  const [v, setV] = useState(JSON.stringify(s.value));
  return (
    <tr>
      <Td className="font-mono text-xs">{s.key}</Td>
      <Td><Input className="font-mono text-xs" value={v} onChange={(e) => setV(e.target.value)} aria-label={s.key} /></Td>
      <Td><Button size="sm" variant="outline" disabled={v === JSON.stringify(s.value)} onClick={() => onSave(s.key, v)}>Enregistrer</Button></Td>
    </tr>
  );
}
