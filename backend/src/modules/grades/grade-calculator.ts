/**
 * Calcul des moyennes (fonctions pures, testées unitairement).
 * - Chaque note est ramenée sur 20 selon son barème.
 * - Moyenne d'une matière = moyenne pondérée par le coefficient des évaluations.
 * - Moyenne générale = moyenne des matières pondérée par le coefficient de la matière.
 * - Crédits ECTS acquis si la moyenne de la matière est ≥ 10/20.
 * Les résultats sont arrondis au centième.
 */
export interface GradeInput {
  valeur: number;
  bareme: number;
  assessmentCoefficient: number;
  courseId: string;
  courseCode: string;
  courseNom: string;
  courseCoefficient: number;
  courseCredits: number;
}

export interface CourseAverage {
  courseId: string;
  code: string;
  nom: string;
  coefficient: number;
  credits: number;
  moyenne: number;
  creditsAcquis: number;
  nombreNotes: number;
}

export interface SemesterResult {
  matieres: CourseAverage[];
  moyenneGenerale: number | null;
  creditsAcquis: number;
  creditsTotal: number;
  mention: string | null;
  decision: string | null;
}

export const PASSING_GRADE = 10;

export const round2 = (n: number) => Math.round(n * 100) / 100;

export function normalizeTo20(valeur: number, bareme: number): number {
  if (bareme <= 0) throw new Error('Barème invalide');
  return (valeur / bareme) * 20;
}

export function mentionFor(moyenne: number | null): string | null {
  if (moyenne === null) return null;
  if (moyenne >= 16) return 'Très bien';
  if (moyenne >= 14) return 'Bien';
  if (moyenne >= 12) return 'Assez bien';
  if (moyenne >= PASSING_GRADE) return 'Passable';
  return null;
}

export function decisionFor(moyenne: number | null, creditsAcquis: number, creditsTotal: number): string | null {
  if (moyenne === null) return null;
  if (moyenne >= PASSING_GRADE && creditsAcquis === creditsTotal) return 'Admis';
  if (moyenne >= PASSING_GRADE) return 'Admis avec dettes';
  return 'Ajourné';
}

export function computeSemester(grades: GradeInput[]): SemesterResult {
  const byCourse = new Map<string, GradeInput[]>();
  for (const g of grades) {
    const list = byCourse.get(g.courseId) ?? [];
    list.push(g);
    byCourse.set(g.courseId, list);
  }

  const matieres: CourseAverage[] = [];
  for (const [courseId, list] of byCourse) {
    const weight = list.reduce((s, g) => s + g.assessmentCoefficient, 0);
    if (weight <= 0) continue;
    const sum = list.reduce((s, g) => s + normalizeTo20(g.valeur, g.bareme) * g.assessmentCoefficient, 0);
    const moyenne = round2(sum / weight);
    const first = list[0];
    matieres.push({
      courseId,
      code: first.courseCode,
      nom: first.courseNom,
      coefficient: first.courseCoefficient,
      credits: first.courseCredits,
      moyenne,
      creditsAcquis: moyenne >= PASSING_GRADE ? first.courseCredits : 0,
      nombreNotes: list.length,
    });
  }
  matieres.sort((a, b) => a.code.localeCompare(b.code));

  const totalCoef = matieres.reduce((s, m) => s + m.coefficient, 0);
  const moyenneGenerale =
    totalCoef > 0 ? round2(matieres.reduce((s, m) => s + m.moyenne * m.coefficient, 0) / totalCoef) : null;
  const creditsAcquis = matieres.reduce((s, m) => s + m.creditsAcquis, 0);
  const creditsTotal = matieres.reduce((s, m) => s + m.credits, 0);

  return {
    matieres,
    moyenneGenerale,
    creditsAcquis,
    creditsTotal,
    mention: mentionFor(moyenneGenerale),
    decision: decisionFor(moyenneGenerale, creditsAcquis, creditsTotal),
  };
}

/** Rang d'un étudiant dans sa promotion (1 = meilleur), ex aequo partagés. */
export function rankOf(target: number, all: number[]): number {
  return all.filter((m) => m > target).length + 1;
}
