'use client';

import { FormEvent, useState } from 'react';
import { Button, Card, CardHeader, Field, Input, PageHeader, Select, Textarea } from '@/components/ui';
import { api, fmtDate, Page, useApi } from '@/lib/api';

interface Structure {
  programs: { id: string; nom: string; code: string }[];
  groups: { id: string; nom: string }[];
}

interface Announcement {
  id: string;
  titre: string;
  contenu: string;
  targetType: string;
  datePublication: string;
}

export default function AnnouncementsPage() {
  const { data: s } = useApi<Structure>('admin/structure');
  const { data: list, mutate } = useApi<Page<Announcement>>('announcements?take=50');
  const [target, setTarget] = useState('ALL');
  const [msg, setMsg] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const f = Object.fromEntries(new FormData(e.currentTarget)) as Record<string, string>;
    setLoading(true);
    try {
      const r = await api<{ destinataires: number }>('admin/announcements', {
        method: 'POST',
        json: { titre: f.titre, contenu: f.contenu, targetType: target, targetId: target === 'ALL' ? undefined : f.targetId, dateExpiration: f.dateExpiration ? new Date(f.dateExpiration).toISOString() : undefined },
      });
      setMsg(`Annonce publiée et notifiée à ${r.destinataires} personne(s).`);
      (e.target as HTMLFormElement).reset();
      mutate();
    } catch (err) {
      setMsg((err as Error).message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <>
      <PageHeader title="Annonces officielles" description="Diffusion ciblée : tous, une filière ou un groupe" />
      <div className="grid gap-6 xl:grid-cols-2">
        <Card>
          <CardHeader title="Nouvelle annonce" />
          <form onSubmit={submit} className="space-y-4 p-5">
            <Field label="Titre"><Input name="titre" required maxLength={150} /></Field>
            <Field label="Message"><Textarea name="contenu" rows={6} required maxLength={5000} /></Field>
            <div className="grid gap-4 md:grid-cols-2">
              <Field label="Destinataires">
                <Select value={target} onChange={(e) => setTarget(e.target.value)}>
                  <option value="ALL">Toute l’université</option>
                  <option value="PROGRAM">Une filière</option>
                  <option value="GROUP">Un groupe</option>
                </Select>
              </Field>
              {target !== 'ALL' && (
                <Field label={target === 'PROGRAM' ? 'Filière' : 'Groupe'}>
                  <Select name="targetId" required>
                    {(target === 'PROGRAM' ? s?.programs : s?.groups)?.map((x) => <option key={x.id} value={x.id}>{x.nom}</option>)}
                  </Select>
                </Field>
              )}
              <Field label="Expire le (facultatif)"><Input name="dateExpiration" type="date" /></Field>
            </div>
            <Button type="submit" loading={loading}>Publier et notifier</Button>
            {msg && <p className="text-sm">{msg}</p>}
          </form>
        </Card>
        <Card>
          <CardHeader title="Annonces publiées" />
          <ul className="divide-y divide-border">
            {list?.items.map((a) => (
              <li key={a.id} className="p-5">
                <div className="flex justify-between gap-4">
                  <h3 className="font-semibold">{a.titre}</h3>
                  <span className="whitespace-nowrap text-xs text-subtle">{fmtDate(a.datePublication)}</span>
                </div>
                <p className="mt-1 line-clamp-3 text-sm text-subtle">{a.contenu}</p>
                <p className="mt-1 text-xs text-subtle">Cible : {a.targetType.toLowerCase()}</p>
              </li>
            ))}
          </ul>
        </Card>
      </div>
    </>
  );
}
