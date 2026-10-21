'use client';

import { Upload, UserPlus } from 'lucide-react';
import { FormEvent, useState } from 'react';
import { Badge, Button, Card, ErrorBox, Field, Input, Loading, Modal, PageHeader, Select, Table, Td } from '@/components/ui';
import { api, fmtDate, Page, useApi } from '@/lib/api';

interface UserRow {
  id: string;
  email: string | null;
  telephone: string | null;
  status: string;
  lastLoginAt: string | null;
  studentProfile: { id: string; matricule: string; nom: string; prenom: string; group: { nom: string } } | null;
  parentProfile: { id: string; nom: string; prenom: string } | null;
}

interface Structure {
  groups: { id: string; nom: string }[];
}

export default function StudentsPage() {
  const [role, setRole] = useState<'ETUDIANT' | 'PARENT'>('ETUDIANT');
  const [search, setSearch] = useState('');
  const { data, error, isLoading, mutate } = useApi<Page<UserRow>>(`admin/users?role=${role}&take=100${search ? `&search=${encodeURIComponent(search)}` : ''}`);
  const [creating, setCreating] = useState(false);
  const [importing, setImporting] = useState(false);

  return (
    <>
      <PageHeader
        title="Étudiants & familles"
        description="Dossiers étudiants, invitations des parents et rattachements"
        action={
          <div className="flex gap-2">
            <Button variant="outline" onClick={() => setImporting(true)}><Upload className="h-4 w-4" /> Import CSV</Button>
            <Button onClick={() => setCreating(true)}><UserPlus className="h-4 w-4" /> Nouvel étudiant</Button>
          </div>
        }
      />
      <Card>
        <div className="flex flex-wrap gap-3 border-b border-border p-4">
          <Select className="w-44" value={role} onChange={(e) => setRole(e.target.value as 'ETUDIANT' | 'PARENT')} aria-label="Type de compte">
            <option value="ETUDIANT">Étudiants</option>
            <option value="PARENT">Parents</option>
          </Select>
          <Input className="max-w-xs" placeholder="Nom, matricule, téléphone…" value={search} onChange={(e) => setSearch(e.target.value)} aria-label="Recherche" />
        </div>
        {isLoading ? <Loading /> : error ? <ErrorBox error={error} onRetry={() => mutate()} /> : (
          <Table head={['Nom', role === 'ETUDIANT' ? 'Matricule / groupe' : 'Contact', 'Statut', 'Dernière connexion', '']} empty={!data?.items.length}>
            {data?.items.map((u) => {
              const p = u.studentProfile ?? u.parentProfile;
              return (
                <tr key={u.id}>
                  <Td><b>{p?.nom}</b> {p?.prenom}</Td>
                  <Td>{u.studentProfile ? `${u.studentProfile.matricule} · ${u.studentProfile.group.nom}` : u.telephone ?? u.email}</Td>
                  <Td><Badge status={u.status}>{u.status === 'PENDING_ACTIVATION' ? 'invitation envoyée' : undefined}</Badge></Td>
                  <Td>{fmtDate(u.lastLoginAt, true)}</Td>
                  <Td>
                    {u.status === 'PENDING_ACTIVATION' && (
                      <Button size="sm" variant="ghost" onClick={async () => alert(`Invitation renvoyée${((await api<{ activationCode?: string }>(`admin/users/${u.id}/resend-invitation`, { method: 'POST' })).activationCode ? ' (code de test affiché dans les logs SMS)' : '')}`)}>
                        Renvoyer l’invitation
                      </Button>
                    )}
                  </Td>
                </tr>
              );
            })}
          </Table>
        )}
      </Card>
      <CreateStudentModal open={creating} onClose={() => setCreating(false)} onDone={() => mutate()} />
      <ImportModal open={importing} onClose={() => setImporting(false)} onDone={() => mutate()} />
    </>
  );
}

function CreateStudentModal({ open, onClose, onDone }: { open: boolean; onClose: () => void; onDone: () => void }) {
  const { data: s } = useApi<Structure>(open ? 'admin/structure' : null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const f = Object.fromEntries(new FormData(e.currentTarget)) as Record<string, string>;
    setLoading(true);
    setError(null);
    try {
      await api('admin/students', {
        method: 'POST',
        json: {
          matricule: f.matricule,
          nom: f.nom,
          prenom: f.prenom,
          dateNaissance: f.dateNaissance,
          groupId: f.groupId,
          email: f.email || undefined,
          telephone: f.telephone || undefined,
          parents: [{ nom: f.pNom, prenom: f.pPrenom, telephone: f.pTel, email: f.pEmail || undefined, relationType: f.pLien, estPayeur: f.pPayeur === 'oui' }],
        },
      });
      onDone();
      onClose();
    } catch (err) {
      setError((err as Error).message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <Modal open={open} onClose={onClose} title="Nouveau dossier étudiant" wide>
      <form onSubmit={submit} className="space-y-5">
        <div className="grid gap-4 md:grid-cols-2">
          <Field label="Matricule"><Input name="matricule" required /></Field>
          <Field label="Groupe">
            <Select name="groupId" required>
              <option value="">—</option>
              {s?.groups.map((g) => <option key={g.id} value={g.id}>{g.nom}</option>)}
            </Select>
          </Field>
          <Field label="Nom"><Input name="nom" required /></Field>
          <Field label="Prénom"><Input name="prenom" required /></Field>
          <Field label="Date de naissance"><Input name="dateNaissance" type="date" required /></Field>
          <Field label="Téléphone de l’étudiant"><Input name="telephone" placeholder="+241…" /></Field>
        </div>
        <h4 className="font-semibold">Parent / tuteur (invitation par SMS)</h4>
        <div className="grid gap-4 md:grid-cols-2">
          <Field label="Nom"><Input name="pNom" required /></Field>
          <Field label="Prénom"><Input name="pPrenom" required /></Field>
          <Field label="Téléphone" hint="Le code d’activation est envoyé à ce numéro"><Input name="pTel" required placeholder="+241…" /></Field>
          <Field label="Email"><Input name="pEmail" type="email" /></Field>
          <Field label="Lien">
            <Select name="pLien">
              <option value="PERE">Père</option>
              <option value="MERE">Mère</option>
              <option value="TUTEUR_LEGAL">Tuteur légal</option>
              <option value="SPONSOR">Sponsor</option>
            </Select>
          </Field>
          <Field label="Payeur">
            <Select name="pPayeur"><option value="oui">Oui</option><option value="non">Non (consultation seule)</option></Select>
          </Field>
        </div>
        {error && <p className="text-sm text-danger">{error}</p>}
        <div className="flex justify-end gap-2">
          <Button type="button" variant="outline" onClick={onClose}>Annuler</Button>
          <Button type="submit" loading={loading}>Créer et inviter</Button>
        </div>
      </form>
    </Modal>
  );
}

interface ImportReport {
  dryRun: boolean;
  total: number;
  valides?: number;
  crees?: number;
  erreurs: number;
  rapport: { ligne: number; matricule?: string; statut: string; message?: string }[];
}

function ImportModal({ open, onClose, onDone }: { open: boolean; onClose: () => void; onDone: () => void }) {
  const [file, setFile] = useState<File | null>(null);
  const [report, setReport] = useState<ImportReport | null>(null);
  const [loading, setLoading] = useState(false);

  async function run(dryRun: boolean) {
    if (!file) return;
    const form = new FormData();
    form.set('fichier', file);
    setLoading(true);
    try {
      setReport(await api<ImportReport>(`admin/students/import?dryRun=${dryRun}`, { method: 'POST', body: form }));
      if (!dryRun) onDone();
    } catch (err) {
      alert((err as Error).message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <Modal open={open} onClose={() => { setReport(null); onClose(); }} title="Import CSV des étudiants" wide>
      <p className="mb-3 text-sm text-subtle">
        Colonnes : <code>matricule;nom;prenom;dateNaissance;groupe;email;telephone;parentNom;parentPrenom;parentTelephone;parentEmail;lien;payeur</code>
      </p>
      <Input type="file" accept=".csv,text/csv" onChange={(e) => { setFile(e.target.files?.[0] ?? null); setReport(null); }} />
      <div className="mt-4 flex gap-2">
        <Button variant="outline" loading={loading} disabled={!file} onClick={() => run(true)}>Prévisualiser</Button>
        <Button loading={loading} disabled={!report?.dryRun || !report.valides} onClick={() => run(false)}>Importer {report?.valides ?? ''} ligne(s) valide(s)</Button>
      </div>
      {report && (
        <div className="mt-5">
          <p className="mb-2 text-sm">
            {report.dryRun ? 'Prévisualisation' : 'Import terminé'} : {report.total} ligne(s), {report.dryRun ? `${report.valides} valide(s)` : `${report.crees} créée(s)`}, {report.erreurs} erreur(s)
          </p>
          <Table head={['Ligne', 'Matricule', 'Statut', 'Détail']}>
            {report.rapport.map((r) => (
              <tr key={r.ligne}>
                <Td>{r.ligne}</Td>
                <Td>{r.matricule}</Td>
                <Td><Badge status={r.statut === 'OK' ? 'VALIDE' : 'REJETE'}>{r.statut}</Badge></Td>
                <Td className="text-danger">{r.message}</Td>
              </tr>
            ))}
          </Table>
        </div>
      )}
    </Modal>
  );
}

