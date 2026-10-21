'use client';

import Link from 'next/link';
import { Card, CardHeader, ErrorBox, Loading, PageHeader, Stat } from '@/components/ui';
import { fmtMoney, useApi } from '@/lib/api';

interface Overview {
  inscrits: number;
  adoption: { parentsActifs30j: number; parentsTotal: number; taux: number | null };
  finances: { totalFacture: number; totalEncaisse: number; resteARecouvrer: number; tauxRecouvrement: number | null; impayesEnRetard: { montant: number; factures: number } };
  assiduite30j: number | null;
  moyenneGeneraleSemestre: number | null;
  ticketsOuverts: number;
  aTraiter: { justificatifs: number; demandesDocuments: number };
}

const pct = (v: number | null) => (v === null ? '—' : `${v.toLocaleString('fr-FR')} %`);

export default function DashboardPage() {
  const { data, error, isLoading, mutate } = useApi<Overview>('admin/stats/overview', { refreshInterval: 60_000 });
  if (isLoading) return <Loading />;
  if (error || !data) return <ErrorBox error={error} onRetry={() => mutate()} />;
  const f = data.finances;

  return (
    <>
      <PageHeader title="Tableau de bord" description="Indicateurs clés de l’année en cours (actualisés chaque minute)" />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <Stat label="Étudiants inscrits" value={data.inscrits} />
        <Stat label="Taux de recouvrement" value={pct(f.tauxRecouvrement)} hint={`${fmtMoney(f.totalEncaisse)} encaissés / ${fmtMoney(f.totalFacture)}`} accent="text-success" />
        <Stat label="Impayés en retard" value={fmtMoney(f.impayesEnRetard.montant)} hint={`${f.impayesEnRetard.factures} facture(s)`} accent="text-danger" />
        <Stat label="Assiduité (30 jours)" value={pct(data.assiduite30j)} />
        <Stat label="Moyenne générale (semestre)" value={data.moyenneGeneraleSemestre?.toLocaleString('fr-FR') ?? '—'} hint="Notes publiées uniquement" />
        <Stat label="Adoption parents (30 j)" value={pct(data.adoption.taux)} hint={`${data.adoption.parentsActifs30j} / ${data.adoption.parentsTotal} actifs · objectif 70 %`} />
        <Stat label="Tickets ouverts" value={data.ticketsOuverts} />
        <Stat label="Reste à recouvrer" value={fmtMoney(f.resteARecouvrer)} />
      </div>

      <Card className="mt-6">
        <CardHeader title="À traiter" description="Actions en attente de l’administration" />
        <ul className="divide-y divide-border text-sm">
          <li className="flex items-center justify-between px-5 py-3">
            Justificatifs d’absence à valider <Link className="font-semibold text-primary" href="/attendance">{data.aTraiter.justificatifs} →</Link>
          </li>
          <li className="flex items-center justify-between px-5 py-3">
            Demandes de documents <Link className="font-semibold text-primary" href="/requests">{data.aTraiter.demandesDocuments} →</Link>
          </li>
          <li className="flex items-center justify-between px-5 py-3">
            Tickets ouverts <Link className="font-semibold text-primary" href="/tickets">{data.ticketsOuverts} →</Link>
          </li>
        </ul>
      </Card>
    </>
  );
}
