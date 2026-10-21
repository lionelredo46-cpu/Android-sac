import { computeSemester, decisionFor, GradeInput, mentionFor, normalizeTo20, rankOf } from './grade-calculator';

const g = (over: Partial<GradeInput>): GradeInput => ({
  valeur: 10,
  bareme: 20,
  assessmentCoefficient: 1,
  courseId: 'c1',
  courseCode: 'INF301',
  courseNom: 'Flutter',
  courseCoefficient: 2,
  courseCredits: 4,
  ...over,
});

describe('grade-calculator', () => {
  it('ramène une note sur 20 selon le barème', () => {
    expect(normalizeTo20(15, 30)).toBe(10);
    expect(() => normalizeTo20(5, 0)).toThrow();
  });

  it('pondère les évaluations par leur coefficient', () => {
    const r = computeSemester([
      g({ valeur: 10, assessmentCoefficient: 1 }),
      g({ valeur: 16, assessmentCoefficient: 2 }),
    ]);
    expect(r.matieres[0].moyenne).toBe(14);
  });

  it('pondère la moyenne générale par le coefficient des matières et compte les crédits', () => {
    const r = computeSemester([
      g({ valeur: 16, courseId: 'a', courseCode: 'A', courseCoefficient: 3, courseCredits: 6 }),
      g({ valeur: 8, courseId: 'b', courseCode: 'B', courseCoefficient: 1, courseCredits: 2 }),
    ]);
    expect(r.moyenneGenerale).toBe(14);
    expect(r.creditsAcquis).toBe(6);
    expect(r.creditsTotal).toBe(8);
    expect(r.decision).toBe('Admis avec dettes');
    expect(r.mention).toBe('Bien');
  });

  it('retourne null sans notes', () => {
    const r = computeSemester([]);
    expect(r.moyenneGenerale).toBeNull();
    expect(r.decision).toBeNull();
  });

  it('attribue mentions, décisions et rangs', () => {
    expect(mentionFor(9.99)).toBeNull();
    expect(mentionFor(16)).toBe('Très bien');
    expect(decisionFor(9, 0, 30)).toBe('Ajourné');
    expect(decisionFor(12, 30, 30)).toBe('Admis');
    expect(rankOf(14, [12, 14, 15, 14])).toBe(2);
  });
});
