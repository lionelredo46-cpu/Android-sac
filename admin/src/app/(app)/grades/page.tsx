'use client';

import { useState } from 'react';
import { Badge, Button, Card, CardHeader, cn, ErrorBox, Input, Loading, Modal, PageHeader, Table, Td } from '@/components/ui';
import { api, fmtDate, useApi } from '@/lib/api';

interface Assessment {
  id: string;
  titre: string;
  type: string;
  statut: string;
  bareme: number;
  coefficient: number;
  createdAt: string;
  course: { code: string; nom: string };
  group: { nom: string } | null;
  semester: { code: string };
  _count: { grades: number };
}

interface Sheet extends Assessment {
  lignes: { id: string; matricule: string; nom: string; prenom: string; valeur: number | null }[];
}

interface Dispute {
  id: string;
  motif: string;
  statut: string;
  createdAt: string;
  student: { matricule: string; nom: string; prenom: string };
  grade: { id: string; valeur: number; assessment: { titre: string; bareme: number; course: { nom: string } } };
}

const STATUSES = [
  { value: 'BROUILLON', label: 'Brouillons (enseignants)' },
  { value: 'VALIDE_SCOLARITE', label: 'Validées — à publier' },
  { value: 'PUBLIE', label: 'Publiées' },
];

/** Workflow brouillon → validé scolarité → publié (parcours P5). */
export default function GradesPage() {
  const [statut, setStatut] = useState('BROUILLON');
  const { data, error, isLoading, mutate } = useApi<Assessment[]>(`admin/assessments?statut=${statut}`);
  const disputes = useApi<Dispute[]>('admin/grade-disputes?statut=OUVERTE');
  const [sheetId, setSheetId] = useState<string | null>(null);

  async function transition(id: string, action: 'validate' | 'publish' | 'reject') {
    const msg = { validate: 'Valider ces notes ?', publish: 'Publier ces notes ? Les familles seront notifiées et les notes deviendront visibles.', reject: 'Renvoyer en brouillon à l’enseignant ?' }[action];
    if (!confirm(msg)) return;
    try {
      await api(`admin/assessments/${id}/${action}`, { method: 'POST' });
      mutate();
    } catch (e) {
      alert((e as Error).message);
    }
  }

  return (
    <>
      <PageHeader title="Notes & évaluations" description="Contrôle, validation et publication des notes" />
      <div className="mb-4 flex flex-wrap gap-2">
        {STATUSES.map((s) => (
          <button key={s.value} onClick={() => setStatut(s.value)} className={cn('rounded-full px-4 py-1.5 text-sm', statut === s.value ? 'bg-primary text-white' : 'border border-border bg-surface')}>
            {s.label}
          </button>
        ))}
      </div>
      <Card>
        {isLoading ? <Loading /> : error ? <ErrorBox error={error} onRetry={() => mutate()} /> : (
          <Table head={['Matière', 'Évaluation', 'Groupe', 'Notes', 'Statut', '']} empty={!data?.length}>
            {data?.map((a) => (
              <tr key={a.id}>
                <Td><b>{a.course.nom}</b><div className="text-xs text-subtle">{a.course.code} · {a.semester.code}</div></Td>
                <Td>{a.titre}<div className="text-xs text-subtle">{a.type.replace(/_/g, ' ').toLowerCase()} · coef. {a.coefficient} · /{a.bareme}</div></Td>
                <Td>{a.group?.nom ?? '—'}</Td>
                <Td>{a._count.grades}</Td>
                <Td><Badge status={a.statut} /></Td>
                <Td className="space-x-2 whitespace-nowrap">
                  <Button size="sm" variant="ghost" onClick={() => setSheetId(a.id)}>Voir / corriger</Button>
                  {a.statut === 'BROUILLON' && <Button size="sm" onClick={() => transition(a.id, 'validate')}>Valider</Button>}
                  {a.statut === 'VALIDE_SCOLARITE' && (
                    <>
                      <Button size="sm" variant="success" onClick={() => transition(a.id, 'publish')}>Publier</Button>
                      <Button size="sm" variant="outline" onClick={() => transition(a.id, 'reject')}>Renvoyer</Button>
                    </>
                  )}
                </Td>
              </tr>
            ))}
          </Table>
        )}
      </Card>

      <Card className="mt-6">
        <CardHeader title="Réclamations de notes" description="Demandes de révision des familles" />
        <Table head={['Date', 'Étudiant', 'Note', 'Motif', '']} empty={!disputes.data?.length}>
          {disputes.data?.map((d) => (
            <tr key={d.id}>
              <Td>{fmtDate(d.createdAt)}</Td>
              <Td>{d.student.prenom} {d.student.nom}<div className="text-xs text-subtle">{d.student.matricule}</div></Td>
              <Td>{d.grade.assessment.course.nom} — {d.grade.assessment.titre}<div className="font-semibold">{d.grade.valeur} / {d.grade.assessment.bareme}</div></Td>
              <Td className="max-w-xs">{d.motif}</Td>
              <Td className="space-x-2 whitespace-nowrap">
                <Button size="sm" variant="success" onClick={async () => {
                  const v = prompt('Nouvelle note (laisser vide pour ne pas modifier)');
                  const reponse = prompt('Réponse à la famille') ?? '';
                  if (!reponse) return;
                  await api(`admin/grade-disputes/${d.id}`, { method: 'PATCH', json: { statut: 'ACCEPTEE', reponse, nouvelleValeur: v ? Number(v.replace(',', '.')) : undefined } });
                  disputes.mutate();
                }}>Accepter</Button>
                <Button size="sm" variant="outline" onClick={async () => {
                  const reponse = prompt('Motif du rejet') ?? '';
                  if (!reponse) return;
                  await api(`admin/grade-disputes/${d.id}`, { method: 'PATCH', json: { statut: 'REJETEE', reponse } });
                  disputes.mutate();
                }}>Rejeter</Button>
              </Td>
            </tr>
          ))}
        </Table>
      </Card>

      <SheetModal id={sheetId} onClose={() => { setSheetId(null); mutate(); }} />
    </>
  );
}

/** Feuille de notes : toute correction après brouillon exige un motif (historisé). */
function SheetModal({ id, onClose }: { id: string | null; onClose: () => void }) {
  const { data, mutate } = useApi<Sheet>(id ? `teacher/assessments/${id}` : null);
  const [edits, setEdits] = useState<Record<string, string>>({});
  const [saving, setSaving] = useState(false);

  async function save() {
    if (!data) return;
    const grades = Object.entries(edits)
      .filter(([, v]) => v.trim() !== '')
      .map(([studentId, v]) => ({ studentId, valeur: Number(v.replace(',', '.')) }));
    if (!grades.length) return;
    const motif = data.statut !== 'BROUILLON' ? prompt('Motif de la correction (obligatoire, historisé)') ?? '' : undefined;
    if (data.statut !== 'BROUILLON' && !motif) return;
    setSaving(true);
    try {
      await api(`teacher/assessments/${data.id}/grades`, { method: 'PUT', json: { grades, motif } });
      setEdits({});
      mutate();
    } catch (e) {
      alert((e as Error).message);
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal open={!!id} onClose={onClose} title={data ? `${data.course.nom} — ${data.titre}` : 'Feuille de notes'} wide>
      {!data ? <Loading /> : (
        <>
          <Table head={['Étudiant', 'Matricule', `Note /${data.bareme}`]}>
            {data.lignes.map((l) => (
              <tr key={l.id}>
                <Td>{l.nom} {l.prenom}</Td>
                <Td>{l.matricule}</Td>
                <Td>
                  <Input
                    className="w-24"
                    inputMode="decimal"
                    aria-label={`Note de ${l.prenom} ${l.nom}`}
                    placeholder={l.valeur?.toString() ?? '—'}
                    value={edits[l.id] ?? ''}
                    onChange={(e) => setEdits({ ...edits, [l.id]: e.target.value })}
                  />
                </Td>
              </tr>
            ))}
          </Table>
          <div className="mt-4 flex justify-end">
            <Button loading={saving} onClick={save} disabled={!Object.values(edits).some((v) => v.trim())}>Enregistrer les modifications</Button>
          </div>
        </>
      )}
    </Modal>
  );
}
