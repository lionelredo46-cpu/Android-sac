'use client';

import { useState } from 'react';
import { Button, Card, Input, Loading, PageHeader, Table, Td } from '@/components/ui';
import { api, fmtDate, Page, useApi } from '@/lib/api';

interface Log {
  id: string;
  action: string;
  entite: string;
  entiteId: string;
  avant: unknown;
  apres: unknown;
  adresseIp: string | null;
  createdAt: string;
  user: { email: string | null; telephone: string | null; role: string } | null;
}

/** Journal d'audit immuable (qui a fait quoi, quand, depuis où). */
export default function AuditPage() {
  const [action, setAction] = useState('');
  const [entite, setEntite] = useState('');
  const query = `admin/audit-logs?take=100${action ? `&action=${encodeURIComponent(action)}` : ''}${entite ? `&entite=${encodeURIComponent(entite)}` : ''}`;
  const { data, isLoading } = useApi<Page<Log>>(query);
  const [more, setMore] = useState<Log[]>([]);
  const [cursor, setCursor] = useState<string | null>(null);
  const next = cursor ?? data?.nextCursor ?? null;

  async function loadMore() {
    if (!next) return;
    const p = await api<Page<Log>>(`${query}&cursor=${next}`);
    setMore([...more, ...p.items]);
    setCursor(p.nextCursor);
  }

  const rows = [...(data?.items ?? []), ...more];
  return (
    <>
      <PageHeader title="Journal d’audit" description="Enregistrements non modifiables : finances, notes, comptes, accès" />
      <Card>
        <div className="flex flex-wrap gap-3 border-b border-border p-4">
          <Input className="max-w-xs" placeholder="Action (ex. PAYMENT, GRADE)…" value={action} onChange={(e) => { setAction(e.target.value); setMore([]); setCursor(null); }} aria-label="Action" />
          <Input className="max-w-xs" placeholder="Entité (Invoice, Grade, User…)" value={entite} onChange={(e) => { setEntite(e.target.value); setMore([]); setCursor(null); }} aria-label="Entité" />
        </div>
        {isLoading ? <Loading /> : (
          <Table head={['Date', 'Utilisateur', 'Action', 'Entité', 'Détail', 'IP']} empty={!rows.length}>
            {rows.map((l) => (
              <tr key={l.id}>
                <Td className="whitespace-nowrap">{fmtDate(l.createdAt, true)}</Td>
                <Td>{l.user?.email ?? l.user?.telephone ?? 'système'}<div className="text-xs text-subtle">{l.user?.role}</div></Td>
                <Td className="font-mono text-xs">{l.action}</Td>
                <Td className="text-xs">{l.entite}<div className="max-w-[140px] truncate text-subtle">{l.entiteId}</div></Td>
                <Td>
                  {l.apres != null && (
                    <details className="text-xs">
                      <summary className="cursor-pointer text-primary">voir</summary>
                      <pre className="mt-1 max-w-md overflow-x-auto whitespace-pre-wrap rounded bg-muted p-2">{JSON.stringify({ avant: l.avant, apres: l.apres }, null, 2)}</pre>
                    </details>
                  )}
                </Td>
                <Td className="text-xs">{l.adresseIp ?? '—'}</Td>
              </tr>
            ))}
          </Table>
        )}
        {next && <div className="p-4 text-center"><Button variant="outline" onClick={loadMore}>Charger plus</Button></div>}
      </Card>
    </>
  );
}
