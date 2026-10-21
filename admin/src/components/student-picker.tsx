'use client';

import { useState } from 'react';
import { Input } from '@/components/ui';
import { Page, useApi } from '@/lib/api';

export interface StudentUser {
  id: string;
  studentProfile: { id: string; nom: string; prenom: string; matricule: string; group?: { nom: string } } | null;
}

/** Recherche d'étudiant (nom, prénom, matricule). */
export function StudentPicker({ onSelect }: { onSelect: (s: NonNullable<StudentUser['studentProfile']>) => void }) {
  const [q, setQ] = useState('');
  const { data } = useApi<Page<StudentUser>>(q.length >= 2 ? `admin/users?role=ETUDIANT&search=${encodeURIComponent(q)}&take=8` : null);
  return (
    <div className="relative">
      <Input placeholder="Rechercher un étudiant (nom ou matricule)…" value={q} onChange={(e) => setQ(e.target.value)} aria-label="Rechercher un étudiant" />
      {data && q.length >= 2 && (
        <ul className="absolute z-10 mt-1 w-full overflow-hidden rounded-lg border border-border bg-surface shadow-lg">
          {data.items.length === 0 && <li className="px-3 py-2 text-sm text-subtle">Aucun résultat</li>}
          {data.items
            .filter((u) => u.studentProfile)
            .map((u) => (
              <li key={u.id}>
                <button
                  type="button"
                  className="w-full px-3 py-2 text-left text-sm hover:bg-muted"
                  onClick={() => {
                    onSelect(u.studentProfile!);
                    setQ('');
                  }}
                >
                  <span className="font-medium">
                    {u.studentProfile!.nom} {u.studentProfile!.prenom}
                  </span>{' '}
                  <span className="text-subtle">· {u.studentProfile!.matricule} · {u.studentProfile!.group?.nom}</span>
                </button>
              </li>
            ))}
        </ul>
      )}
    </div>
  );
}
