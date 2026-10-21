'use client';

import { FormEvent, useState } from 'react';
import { Badge, Button, Card, CardHeader, Field, Input, Loading, Modal, PageHeader, Select, Table, Td } from '@/components/ui';
import { api, fmtDate, Page, useApi } from '@/lib/api';

interface Staff {
  id: string;
  email: string | null;
  telephone: string | null;
  role: string;
  status: string;
  twoFactorEnabled: boolean;
  lastLoginAt: string | null;
  teacherProfile: { nom: string; prenom: string } | null;
}

const ROLES = ['DIRECTION', 'SCOLARITE', 'COMPTABLE', 'ENSEIGNANT', 'SUPPORT', 'SUPER_ADMIN'];

export default function UsersPage() {
  const [role, setRole] = useState('');
  const { data, isLoading, mutate } = useApi<Page<Staff>>(`admin/users?take=100${role ? `&role=${role}` : ''}`);
  const [open, setOpen] = useState(false);
  const staff = (data?.items ?? []).filter((u) => ROLES.includes(u.role));

  async function toggle(u: Staff) {
    const status = u.status === 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE';
    if (!confirm(status === 'SUSPENDED' ? 'Suspendre ce compte ? Toutes ses sessions seront révoquées.' : 'Réactiver ce compte ?')) return;
    try {
      await api(`admin/users/${u.id}/status`, { method: 'PATCH', json: { status } });
      mutate();
    } catch (e) {
      alert((e as Error).message);
    }
  }

  return (
    <>
      <PageHeader title="Personnel" description="Comptes de l’administration et des enseignants" action={<Button onClick={() => setOpen(true)}>Nouveau compte</Button>} />
      <Card>
        <CardHeader
          title={`${staff.length} compte(s)`}
          action={
            <Select className="w-48" value={role} onChange={(e) => setRole(e.target.value)} aria-label="Rôle">
              <option value="">Tous les rôles</option>
              {ROLES.map((r) => <option key={r}>{r}</option>)}
            </Select>
          }
        />
        {isLoading ? <Loading /> : (
          <Table head={['Compte', 'Rôle', 'Statut', '2FA', 'Dernière connexion', '']} empty={!staff.length}>
            {staff.map((u) => (
              <tr key={u.id}>
                <Td><b>{u.teacherProfile ? `${u.teacherProfile.prenom} ${u.teacherProfile.nom}` : u.email}</b><div className="text-xs text-subtle">{u.email} · {u.telephone}</div></Td>
                <Td>{u.role}</Td>
                <Td><Badge status={u.status} /></Td>
                <Td>{u.twoFactorEnabled ? <Badge status="VALIDE">activée</Badge> : <Badge status="EN_ATTENTE">non</Badge>}</Td>
                <Td>{fmtDate(u.lastLoginAt, true)}</Td>
                <Td>{u.status !== 'PENDING_ACTIVATION' && <Button size="sm" variant="outline" onClick={() => toggle(u)}>{u.status === 'ACTIVE' ? 'Suspendre' : 'Réactiver'}</Button>}</Td>
              </tr>
            ))}
          </Table>
        )}
      </Card>
      <CreateStaff open={open} onClose={() => setOpen(false)} onDone={() => mutate()} />
    </>
  );
}

function CreateStaff({ open, onClose, onDone }: { open: boolean; onClose: () => void; onDone: () => void }) {
  const [role, setRole] = useState('SCOLARITE');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const f = Object.fromEntries(new FormData(e.currentTarget)) as Record<string, string>;
    setLoading(true);
    setError(null);
    try {
      await api('admin/users/staff', { method: 'POST', json: { ...f, role } });
      onDone();
      onClose();
    } catch (err) {
      setError((err as Error).message);
    } finally {
      setLoading(false);
    }
  }
  return (
    <Modal open={open} onClose={onClose} title="Nouveau compte du personnel">
      <form onSubmit={submit} className="space-y-4">
        <Field label="Rôle">
          <Select value={role} onChange={(e) => setRole(e.target.value)}>{ROLES.map((r) => <option key={r}>{r}</option>)}</Select>
        </Field>
        <Field label="Email professionnel"><Input name="email" type="email" required /></Field>
        <Field label="Téléphone" hint="Le code d’activation est envoyé par SMS"><Input name="telephone" required placeholder="+241…" /></Field>
        {role === 'ENSEIGNANT' && (
          <div className="grid gap-3 md:grid-cols-3">
            <Field label="Nom"><Input name="nom" required /></Field>
            <Field label="Prénom"><Input name="prenom" required /></Field>
            <Field label="Spécialité"><Input name="specialite" /></Field>
          </div>
        )}
        {error && <p className="text-sm text-danger">{error}</p>}
        <div className="flex justify-end"><Button type="submit" loading={loading}>Créer et inviter</Button></div>
      </form>
    </Modal>
  );
}
