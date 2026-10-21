'use client';

import { FormEvent, useState } from 'react';
import { Button, Card, CardHeader, Field, Input, PageHeader, Select, Textarea } from '@/components/ui';
import { StudentPicker } from '@/components/student-picker';
import { api } from '@/lib/api';

export default function DisciplinePage() {
  const [student, setStudent] = useState<{ id: string; nom: string; prenom: string; matricule: string } | null>(null);
  const [type, setType] = useState('AVERTISSEMENT');
  const [msg, setMsg] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    if (!student) return;
    const f = Object.fromEntries(new FormData(e.currentTarget)) as Record<string, string>;
    setLoading(true);
    try {
      await api('admin/discipline', {
        method: 'POST',
        json: {
          studentId: student.id,
          type,
          motif: f.motif,
          sanction: f.sanction || undefined,
          dateIncident: new Date(f.dateIncident).toISOString(),
          convocationDate: f.convocationDate ? new Date(f.convocationDate).toISOString() : undefined,
        },
      });
      setMsg('Enregistré. Les parents et l’étudiant ont été notifiés.');
      (e.target as HTMLFormElement).reset();
    } catch (err) {
      setMsg((err as Error).message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <>
      <PageHeader title="Vie scolaire & discipline" description="Avertissements, sanctions, félicitations et convocations des parents" />
      <Card>
        <CardHeader title="Nouvel élément" description="Une convocation exige un accusé de réception du parent dans l’application" />
        <div className="space-y-4 p-5">
          <StudentPicker onSelect={setStudent} />
          {student && <p className="text-sm">Étudiant : <b>{student.prenom} {student.nom}</b> ({student.matricule})</p>}
          <form onSubmit={submit} className="grid gap-4 md:grid-cols-2">
            <Field label="Type">
              <Select value={type} onChange={(e) => setType(e.target.value)}>
                <option value="AVERTISSEMENT">Avertissement</option>
                <option value="BLAME">Blâme</option>
                <option value="EXCLUSION_TEMPORAIRE">Exclusion temporaire</option>
                <option value="CONVOCATION_PARENT">Convocation des parents</option>
                <option value="FELICITATION">Félicitations</option>
                <option value="ENCOURAGEMENT">Encouragements</option>
              </Select>
            </Field>
            <Field label="Date des faits"><Input name="dateIncident" type="date" required /></Field>
            <div className="md:col-span-2"><Field label="Motif"><Textarea name="motif" rows={3} required maxLength={500} /></Field></div>
            <Field label="Sanction / décision"><Input name="sanction" maxLength={300} /></Field>
            {type === 'CONVOCATION_PARENT' && <Field label="Date et heure de convocation"><Input name="convocationDate" type="datetime-local" required /></Field>}
            <div className="md:col-span-2 flex justify-end"><Button type="submit" loading={loading} disabled={!student}>Enregistrer et notifier</Button></div>
          </form>
          {msg && <p className="text-sm">{msg}</p>}
        </div>
      </Card>
    </>
  );
}
