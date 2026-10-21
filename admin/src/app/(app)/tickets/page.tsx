'use client';

import { FormEvent, useState } from 'react';
import { Badge, Button, Card, cn, ErrorBox, Loading, PageHeader, Select, Textarea } from '@/components/ui';
import { api, fmtDate, Page, useApi } from '@/lib/api';

interface Ticket {
  id: string;
  numeroTicket: string;
  sujet: string;
  service: string;
  statut: string;
  priorite: string;
  nonLus: number;
  slaDepasse: boolean;
  updatedAt: string;
  student: { prenom: string; nom: string } | null;
}

interface Thread {
  id: string;
  sujet: string;
  statut: string;
  numeroTicket: string;
  messages: { id: string; contenu: string; createdAt: string; moi: boolean; auteur: string; estLu: boolean; piecesJointes: number }[];
}

/** Parcours P6 : traitement des tickets des familles par service, avec SLA. */
export default function TicketsPage() {
  const [statut, setStatut] = useState('');
  const { data, error, isLoading, mutate } = useApi<Page<Ticket>>(`conversations?take=100${statut ? `&statut=${statut}` : ''}`, { refreshInterval: 30_000 });
  const [selected, setSelected] = useState<string | null>(null);

  return (
    <>
      <PageHeader title="Messagerie & tickets" description="Demandes des familles par service" />
      <div className="grid gap-6 lg:grid-cols-[380px_1fr]">
        <Card>
          <div className="border-b border-border p-3">
            <Select value={statut} onChange={(e) => setStatut(e.target.value)} aria-label="Filtrer par statut">
              <option value="">Tous les statuts</option>
              <option value="OUVERT">Ouverts</option>
              <option value="EN_COURS">En cours</option>
              <option value="RESOLU">Résolus</option>
              <option value="CLOTURE">Clôturés</option>
            </Select>
          </div>
          {isLoading ? <Loading /> : error ? <ErrorBox error={error} /> : (
            <ul className="max-h-[70vh] divide-y divide-border overflow-y-auto">
              {data?.items.map((t) => (
                <li key={t.id}>
                  <button onClick={() => setSelected(t.id)} className={cn('w-full p-4 text-left hover:bg-muted', selected === t.id && 'bg-muted')}>
                    <div className="flex items-center justify-between gap-2">
                      <span className={cn('truncate text-sm', t.nonLus > 0 ? 'font-bold' : 'font-medium')}>{t.sujet}</span>
                      {t.nonLus > 0 && <span className="rounded-full bg-primary px-2 text-xs text-white">{t.nonLus}</span>}
                    </div>
                    <div className="mt-1 flex flex-wrap items-center gap-2 text-xs text-subtle">
                      <Badge status={t.statut} />
                      {t.slaDepasse && <Badge status="EN_RETARD">SLA dépassé</Badge>}
                      <span>{t.service.toLowerCase()} · {t.numeroTicket}</span>
                      {t.student && <span>· {t.student.prenom} {t.student.nom}</span>}
                    </div>
                  </button>
                </li>
              ))}
            </ul>
          )}
        </Card>
        {selected ? <ThreadView id={selected} onChange={() => mutate()} /> : <Card className="p-10 text-center text-subtle">Sélectionnez une conversation</Card>}
      </div>
    </>
  );
}

function ThreadView({ id, onChange }: { id: string; onChange: () => void }) {
  const { data, mutate } = useApi<Thread>(`conversations/${id}/messages`);
  const [text, setText] = useState('');
  const [sending, setSending] = useState(false);

  async function send(e: FormEvent) {
    e.preventDefault();
    if (!text.trim()) return;
    setSending(true);
    try {
      await api(`conversations/${id}/messages`, { method: 'POST', json: { contenu: text.trim() } });
      setText('');
      mutate();
      onChange();
    } finally {
      setSending(false);
    }
  }

  async function setStatus(statut: string) {
    await api(`conversations/${id}`, { method: 'PATCH', json: { statut } });
    mutate();
    onChange();
  }

  if (!data) return <Card><Loading /></Card>;
  return (
    <Card className="flex flex-col">
      <div className="flex items-center justify-between border-b border-border px-5 py-3">
        <div>
          <h2 className="font-semibold">{data.sujet}</h2>
          <p className="text-xs text-subtle">{data.numeroTicket}</p>
        </div>
        <Select className="w-40" value={data.statut} onChange={(e) => setStatus(e.target.value)} aria-label="Statut du ticket">
          <option value="OUVERT">Ouvert</option>
          <option value="EN_COURS">En cours</option>
          <option value="RESOLU">Résolu</option>
          <option value="CLOTURE">Clôturé</option>
        </Select>
      </div>
      <div className="max-h-[55vh] flex-1 space-y-3 overflow-y-auto p-5">
        {data.messages.map((m) => (
          <div key={m.id} className={cn('max-w-[80%] rounded-xl p-3 text-sm', m.moi ? 'ml-auto bg-primary text-white' : 'bg-muted')}>
            {!m.moi && <p className="mb-1 text-xs font-semibold text-gold">{m.auteur}</p>}
            <p className="whitespace-pre-wrap">{m.contenu}</p>
            {m.piecesJointes > 0 && (
              <a className="mt-1 block text-xs underline" href={`/api/backend/messages/${m.id}/attachments/0`} target="_blank" rel="noreferrer">Pièce jointe</a>
            )}
            <p className={cn('mt-1 text-[11px]', m.moi ? 'text-white/70' : 'text-subtle')}>{fmtDate(m.createdAt, true)}{m.moi && m.estLu ? ' · lu' : ''}</p>
          </div>
        ))}
      </div>
      {data.statut !== 'CLOTURE' && (
        <form onSubmit={send} className="flex gap-2 border-t border-border p-4">
          <Textarea rows={2} value={text} onChange={(e) => setText(e.target.value)} placeholder="Votre réponse…" aria-label="Réponse" />
          <Button type="submit" loading={sending} className="self-end">Envoyer</Button>
        </form>
      )}
    </Card>
  );
}
