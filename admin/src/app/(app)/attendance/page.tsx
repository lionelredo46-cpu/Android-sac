'use client';

import { Badge, Button, Card, CardHeader, ErrorBox, Loading, PageHeader, Table, Td } from '@/components/ui';
import { api, fmtDate, useApi } from '@/lib/api';

interface Justif {
  id: string;
  motif: string;
  createdAt: string;
  attendanceRecord: {
    id: string;
    statut: string;
    student: { matricule: string; nom: string; prenom: string; group: { nom: string } };
    slot: { dateDebut: string; course: { nom: string } };
  };
}

/** Parcours P4 : la scolarité valide ou refuse les justificatifs ; la famille est notifiée. */
export default function AttendancePage() {
  const { data, error, isLoading, mutate } = useApi<Justif[]>('admin/justifications');

  async function decide(id: string, decision: 'VALIDE' | 'REJETE') {
    const commentaire = prompt(decision === 'VALIDE' ? 'Commentaire (facultatif)' : 'Motif du refus (communiqué à la famille)') ?? undefined;
    if (decision === 'REJETE' && !commentaire) return;
    await api(`admin/justifications/${id}`, { method: 'PATCH', json: { decision, commentaire } });
    mutate();
  }

  return (
    <>
      <PageHeader title="Justificatifs d’absence" description="Validation des pièces envoyées par les parents et les étudiants" />
      <Card>
        <CardHeader title={`${data?.length ?? 0} justificatif(s) en attente`} />
        {isLoading ? <Loading /> : error ? <ErrorBox error={error} onRetry={() => mutate()} /> : (
          <Table head={['Étudiant', 'Séance', 'Statut', 'Motif', 'Pièce', 'Décision']} empty={!data?.length}>
            {data?.map((j) => {
              const r = j.attendanceRecord;
              return (
                <tr key={j.id}>
                  <Td>
                    <b>{r.student.prenom} {r.student.nom}</b>
                    <div className="text-xs text-subtle">{r.student.matricule} · {r.student.group.nom}</div>
                  </Td>
                  <Td>{r.slot.course.nom}<div className="text-xs text-subtle">{fmtDate(r.slot.dateDebut, true)}</div></Td>
                  <Td><Badge status={r.statut} /></Td>
                  <Td className="max-w-xs">{j.motif}</Td>
                  <Td>
                    <a className="text-primary underline" href={`/api/backend/absences/${r.id}/justification/file`} target="_blank" rel="noreferrer">Ouvrir</a>
                  </Td>
                  <Td className="space-x-2 whitespace-nowrap">
                    <Button size="sm" variant="success" onClick={() => decide(j.id, 'VALIDE')}>Valider</Button>
                    <Button size="sm" variant="outline" onClick={() => decide(j.id, 'REJETE')}>Refuser</Button>
                  </Td>
                </tr>
              );
            })}
          </Table>
        )}
      </Card>
    </>
  );
}
