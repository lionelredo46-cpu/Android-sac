'use client';

import { Download } from 'lucide-react';
import { FormEvent, useState } from 'react';
import { Badge, Button, Card, CardHeader, cn, ErrorBox, Field, Input, Loading, PageHeader, Select, Table, Td } from '@/components/ui';
import { StudentPicker } from '@/components/student-picker';
import { api, fmtDate, fmtMoney, useApi } from '@/lib/api';

const TABS = ['Saisie guichet', 'Impayés', 'Facturation en masse', 'Échelonnements', 'Journal'] as const;

export default function FinancePage() {
  const [tab, setTab] = useState<(typeof TABS)[number]>('Saisie guichet');
  return (
    <>
      <PageHeader title="Finances" description="Encaissements, impayés, facturation et relances" />
      <div className="mb-6 flex flex-wrap gap-2" role="tablist">
        {TABS.map((t) => (
          <button key={t} role="tab" aria-selected={tab === t} onClick={() => setTab(t)} className={cn('rounded-full px-4 py-1.5 text-sm', tab === t ? 'bg-primary text-white' : 'bg-surface border border-border')}>
            {t}
          </button>
        ))}
      </div>
      {tab === 'Saisie guichet' && <CashTab />}
      {tab === 'Impayés' && <UnpaidTab />}
      {tab === 'Facturation en masse' && <BulkTab />}
      {tab === 'Échelonnements' && <InstallmentsTab />}
      {tab === 'Journal' && <JournalTab />}
    </>
  );
}

interface Invoice {
  id: string;
  numeroFacture: string;
  soldeRestant: number;
  montantTotal: number;
  statut: string;
  dateEcheance: string;
  lines: { titre: string }[];
}

/** Parcours P3 : le comptable enregistre un versement → le parent est notifié avec le reçu. */
function CashTab() {
  const [student, setStudent] = useState<{ id: string; nom: string; prenom: string; matricule: string } | null>(null);
  const { data: invoices, mutate } = useApi<Invoice[]>(student ? `children/${student.id}/invoices` : null);
  const [invoiceId, setInvoiceId] = useState('');
  const [result, setResult] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const form = new FormData(e.currentTarget);
    form.set('invoiceId', invoiceId);
    setLoading(true);
    setError(null);
    try {
      const p = await api<{ montant: number; receipt: { numeroRecu: string } }>('admin/finance/payments/cash', { method: 'POST', body: form });
      setResult(`Versement de ${fmtMoney(p.montant)} enregistré — reçu ${p.receipt.numeroRecu}. Les parents ont été notifiés.`);
      (e.target as HTMLFormElement).reset();
      mutate();
    } catch (err) {
      setError((err as Error).message);
    } finally {
      setLoading(false);
    }
  }

  const open = (invoices ?? []).filter((i) => i.soldeRestant > 0 && i.statut !== 'ANNULE');
  return (
    <Card>
      <CardHeader title="Enregistrer un versement au guichet" description="Espèces, chèque ou virement, avec pièce justificative" />
      <div className="space-y-4 p-5">
        <StudentPicker onSelect={(s) => { setStudent(s); setInvoiceId(''); setResult(null); }} />
        {student && (
          <p className="text-sm">
            Étudiant : <b>{student.prenom} {student.nom}</b> ({student.matricule})
          </p>
        )}
        {student && (
          <form onSubmit={submit} className="grid gap-4 md:grid-cols-2">
            <Field label="Échéance">
              <Select required value={invoiceId} onChange={(e) => setInvoiceId(e.target.value)}>
                <option value="">— Choisir —</option>
                {open.map((i) => (
                  <option key={i.id} value={i.id}>
                    {i.lines[0]?.titre ?? i.numeroFacture} · reste {fmtMoney(i.soldeRestant)}
                  </option>
                ))}
              </Select>
            </Field>
            <Field label="Montant (FCFA, entier)">
              <Input name="montant" type="number" min={1} step={1} required />
            </Field>
            <Field label="Mode">
              <Select name="canal" required>
                <option value="GUICHET_ESPECES">Espèces</option>
                <option value="GUICHET_CHEQUE">Chèque</option>
                <option value="GUICHET_VIREMENT">Virement</option>
              </Select>
            </Field>
            <Field label="Versé par">
              <Select name="payeurType" required>
                <option value="PARENT">Parent</option>
                <option value="ETUDIANT">Étudiant</option>
                <option value="TIERS">Tiers (sponsor…)</option>
              </Select>
            </Field>
            <Field label="Nom de la personne">
              <Input name="payeurNom" maxLength={120} />
            </Field>
            <Field label="Référence (n° chèque / virement)">
              <Input name="referenceExterne" maxLength={120} />
            </Field>
            <Field label="Pièce justificative (PDF, image)">
              <Input name="justificatif" type="file" accept="application/pdf,image/*" />
            </Field>
            <div className="flex items-end">
              <Button type="submit" loading={loading} disabled={!invoiceId} className="w-full">
                Enregistrer le versement
              </Button>
            </div>
          </form>
        )}
        {result && <p className="rounded-lg bg-success/10 p-3 text-sm text-success">{result}</p>}
        {error && <p className="rounded-lg bg-danger/10 p-3 text-sm text-danger">{error}</p>}
      </div>
    </Card>
  );
}

interface Unpaid {
  invoiceId: string;
  numeroFacture: string;
  matricule: string;
  etudiant: string;
  groupe: string;
  soldeRestant: number;
  dateEcheance: string;
  joursRetard: number;
  statut: string;
}

function UnpaidTab() {
  const [overdue, setOverdue] = useState(true);
  const { data, error, isLoading } = useApi<Unpaid[]>(`admin/finance/unpaid?overdueOnly=${overdue}`);
  const total = (data ?? []).reduce((s, r) => s + r.soldeRestant, 0);
  return (
    <Card>
      <CardHeader
        title="État des impayés"
        description={`${data?.length ?? 0} facture(s) · ${fmtMoney(total)}`}
        action={
          <div className="flex items-center gap-3">
            <label className="flex items-center gap-2 text-sm">
              <input type="checkbox" checked={overdue} onChange={(e) => setOverdue(e.target.checked)} /> En retard uniquement
            </label>
            <a href={`/api/backend/admin/finance/unpaid?format=csv&overdueOnly=${overdue}`}>
              <Button variant="outline" size="sm">
                <Download className="h-4 w-4" /> Export Excel (CSV)
              </Button>
            </a>
          </div>
        }
      />
      {isLoading ? <Loading /> : error ? <ErrorBox error={error} /> : (
        <Table head={['Étudiant', 'Groupe', 'Facture', 'Échéance', 'Retard', 'Reste dû']} empty={!data?.length}>
          {data?.map((r) => (
            <tr key={r.invoiceId}>
              <Td>
                <b>{r.etudiant}</b>
                <div className="text-xs text-subtle">{r.matricule}</div>
              </Td>
              <Td>{r.groupe}</Td>
              <Td>{r.numeroFacture}</Td>
              <Td>{fmtDate(r.dateEcheance)}</Td>
              <Td>{r.joursRetard > 0 ? <Badge status="EN_RETARD">{r.joursRetard} j</Badge> : <Badge status="A_PAYER">à venir</Badge>}</Td>
              <Td className="font-semibold text-danger">{fmtMoney(r.soldeRestant)}</Td>
            </tr>
          ))}
        </Table>
      )}
    </Card>
  );
}

interface Structure {
  programs: { id: string; code: string; nom: string }[];
  groups: { id: string; nom: string; program: { code: string }; _count: { students: number } }[];
  years: { id: string; libelle: string; estActif: boolean }[];
}

function BulkTab() {
  const { data: s } = useApi<Structure>('admin/structure');
  const [lines, setLines] = useState([{ titre: 'Scolarité — tranche', type: 'SCOLARITE_TRANCHE', montant: 330000, dateLimite: '' }]);
  const [target, setTarget] = useState({ groupId: '', academicYearId: '' });
  const [msg, setMsg] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function submit(e: FormEvent) {
    e.preventDefault();
    if (!confirm('Générer ces factures pour tous les étudiants du groupe ? Les familles seront notifiées.')) return;
    setLoading(true);
    try {
      const r = await api<{ count: number }>('admin/finance/invoices/bulk', {
        method: 'POST',
        json: { academicYearId: target.academicYearId, groupId: target.groupId, lines: lines.map((l) => ({ ...l, montant: Number(l.montant), dateLimite: new Date(l.dateLimite).toISOString() })) },
      });
      setMsg(`${r.count} facture(s) générée(s).`);
    } catch (err) {
      setMsg((err as Error).message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <Card>
      <CardHeader title="Génération en masse" description="Crée une facture par étudiant du groupe (montants entiers en FCFA)" />
      <form onSubmit={submit} className="space-y-4 p-5">
        <div className="grid gap-4 md:grid-cols-2">
          <Field label="Année académique">
            <Select required value={target.academicYearId} onChange={(e) => setTarget({ ...target, academicYearId: e.target.value })}>
              <option value="">—</option>
              {s?.years.map((y) => <option key={y.id} value={y.id}>{y.libelle}{y.estActif ? ' (active)' : ''}</option>)}
            </Select>
          </Field>
          <Field label="Groupe">
            <Select required value={target.groupId} onChange={(e) => setTarget({ ...target, groupId: e.target.value })}>
              <option value="">—</option>
              {s?.groups.map((g) => <option key={g.id} value={g.id}>{g.nom} ({g._count.students} étudiants)</option>)}
            </Select>
          </Field>
        </div>
        {lines.map((l, i) => (
          <div key={i} className="grid gap-3 rounded-lg border border-border p-3 md:grid-cols-4">
            <Input aria-label="Libellé" value={l.titre} onChange={(e) => setLines(lines.map((x, j) => (j === i ? { ...x, titre: e.target.value } : x)))} required />
            <Select aria-label="Type" value={l.type} onChange={(e) => setLines(lines.map((x, j) => (j === i ? { ...x, type: e.target.value } : x)))}>
              {['INSCRIPTION', 'SCOLARITE_TRANCHE', 'EXAMEN', 'BIBLIOTHEQUE', 'UNIFORME', 'ACTIVITE', 'AUTRE'].map((t) => <option key={t}>{t}</option>)}
            </Select>
            <Input aria-label="Montant" type="number" min={1} step={1} value={l.montant} onChange={(e) => setLines(lines.map((x, j) => (j === i ? { ...x, montant: Number(e.target.value) } : x)))} required />
            <Input aria-label="Date limite" type="date" value={l.dateLimite} onChange={(e) => setLines(lines.map((x, j) => (j === i ? { ...x, dateLimite: e.target.value } : x)))} required />
          </div>
        ))}
        <div className="flex gap-3">
          <Button type="button" variant="outline" onClick={() => setLines([...lines, { titre: '', type: 'AUTRE', montant: 0, dateLimite: '' }])}>
            + Ligne
          </Button>
          <Button type="submit" loading={loading}>Générer les factures</Button>
        </div>
        {msg && <p className="text-sm">{msg}</p>}
      </form>
    </Card>
  );
}

interface Installment {
  id: string;
  nombreTranches: number;
  motif: string;
  createdAt: string;
  student: { nom: string; prenom: string; matricule: string };
  invoice: { numeroFacture: string; soldeRestant: number };
}

function InstallmentsTab() {
  const { data, mutate, isLoading } = useApi<Installment[]>('admin/finance/installment-requests');
  async function review(id: string, accepter: boolean) {
    const reponse = prompt(accepter ? 'Message au parent (facultatif)' : 'Motif du refus') ?? undefined;
    await api(`admin/finance/installment-requests/${id}`, { method: 'PATCH', json: { accepter, reponse } });
    mutate();
  }
  return (
    <Card>
      <CardHeader title="Demandes d’échelonnement" />
      {isLoading ? <Loading /> : (
        <Table head={['Date', 'Étudiant', 'Facture', 'Reste', 'Tranches', 'Motif', '']} empty={!data?.length}>
          {data?.map((r) => (
            <tr key={r.id}>
              <Td>{fmtDate(r.createdAt)}</Td>
              <Td>{r.student.prenom} {r.student.nom}</Td>
              <Td>{r.invoice.numeroFacture}</Td>
              <Td>{fmtMoney(r.invoice.soldeRestant)}</Td>
              <Td>{r.nombreTranches}</Td>
              <Td className="max-w-xs">{r.motif}</Td>
              <Td className="space-x-2 whitespace-nowrap">
                <Button size="sm" variant="success" onClick={() => review(r.id, true)}>Accepter</Button>
                <Button size="sm" variant="outline" onClick={() => review(r.id, false)}>Refuser</Button>
              </Td>
            </tr>
          ))}
        </Table>
      )}
    </Card>
  );
}

interface JournalRow {
  id: string;
  createdAt: string;
  montant: number;
  canal: string;
  reference: string;
  invoice: { numeroFacture: string; student: { nom: string; prenom: string; matricule: string } };
  receipt: { numeroRecu: string } | null;
}

function JournalTab() {
  const { data, isLoading } = useApi<JournalRow[]>('admin/finance/journal');
  const [reminder, setReminder] = useState<string | null>(null);
  return (
    <Card>
      <CardHeader
        title="Journal des encaissements"
        description="500 derniers versements validés (rapprochement bancaire)"
        action={
          <Button variant="outline" size="sm" onClick={async () => setReminder(`${(await api<{ sent: number }>('admin/finance/reminders/run', { method: 'POST' })).sent} relance(s) envoyée(s)`)}>
            Lancer les relances du jour
          </Button>
        }
      />
      {reminder && <p className="px-5 pt-3 text-sm text-success">{reminder}</p>}
      {isLoading ? <Loading /> : (
        <Table head={['Date', 'Étudiant', 'Facture', 'Canal', 'Référence', 'Reçu', 'Montant']} empty={!data?.length}>
          {data?.map((p) => (
            <tr key={p.id}>
              <Td>{fmtDate(p.createdAt, true)}</Td>
              <Td>{p.invoice.student.prenom} {p.invoice.student.nom}</Td>
              <Td>{p.invoice.numeroFacture}</Td>
              <Td><Badge status={p.canal.startsWith('ONLINE') ? 'INFO' : 'PAYE'}>{p.canal.replace(/_/g, ' ').toLowerCase()}</Badge></Td>
              <Td className="font-mono text-xs">{p.reference}</Td>
              <Td className="font-mono text-xs">{p.receipt?.numeroRecu ?? '—'}</Td>
              <Td className="font-semibold">{fmtMoney(p.montant)}</Td>
            </tr>
          ))}
        </Table>
      )}
    </Card>
  );
}

