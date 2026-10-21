'use client';

import { Badge, Card, ErrorBox, Loading, PageHeader, Select, Table, Td } from '@/components/ui';
import { api, fmtDate, useApi } from '@/lib/api';

interface Req {
  id: string;
  type: string;
  motif: string | null;
  statut: string;
  createdAt: string;
  student: { matricule: string; nom: string; prenom: string; group: { nom: string } };
}

const LABELS: Record<string, string> = {
  ATTESTATION_INSCRIPTION: "Attestation d'inscription",
  CERTIFICAT_SCOLARITE: 'Certificat de scolarité',
  RELEVE_NOTES_OFFICIEL: 'Relevé de notes officiel',
  DUPLICATA_CARTE: 'Duplicata de carte',
  CHANGEMENT_FILIERE: 'Changement de filière',
  CONGE_ACADEMIQUE: 'Congé académique',
};

export default function RequestsPage() {
  const { data, error, isLoading, mutate } = useApi<Req[]>('admin/requests');

  async function update(id: string, statut: string) {
    try {
      await api(`admin/requests/${id}`, { method: 'PATCH', json: { statut } });
      mutate();
    } catch (e) {
      alert((e as Error).message);
    }
  }

  return (
    <>
      <PageHeader title="Démarches & documents" description="Les attestations d’inscription et de scolarité sont générées automatiquement au statut « Prête »" />
      <Card>
        {isLoading ? <Loading /> : error ? <ErrorBox error={error} onRetry={() => mutate()} /> : (
          <Table head={['Date', 'Étudiant', 'Demande', 'Motif', 'Statut', 'Mettre à jour']} empty={!data?.length}>
            {data?.map((r) => (
              <tr key={r.id}>
                <Td>{fmtDate(r.createdAt)}</Td>
                <Td><b>{r.student.prenom} {r.student.nom}</b><div className="text-xs text-subtle">{r.student.matricule} · {r.student.group.nom}</div></Td>
                <Td>{LABELS[r.type] ?? r.type}</Td>
                <Td className="max-w-xs">{r.motif ?? '—'}</Td>
                <Td><Badge status={r.statut} /></Td>
                <Td>
                  <Select className="w-44" value={r.statut} onChange={(e) => update(r.id, e.target.value)} aria-label="Statut">
                    <option value="SOUMISE">Reçue</option>
                    <option value="EN_TRAITEMENT">En traitement</option>
                    <option value="PRETE">Prête</option>
                    <option value="LIVREE">Retirée / envoyée</option>
                    <option value="REJETEE">Refusée</option>
                  </Select>
                </Td>
              </tr>
            ))}
          </Table>
        )}
      </Card>
    </>
  );
}
