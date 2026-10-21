import 'package:flutter_test/flutter_test.dart';
import 'package:uniparent/core/notifications/push_service.dart';
import 'package:uniparent/core/router/route_paths.dart';
import 'package:uniparent/features/attendance/domain/attendance_models.dart';
import 'package:uniparent/features/dashboard/domain/dashboard.dart';
import 'package:uniparent/features/finance/domain/finance_models.dart';

/// Désérialisation des réponses réelles de l'API (extraits).
void main() {
  test('Invoice : montants entiers, lignes et statut payable', () {
    final inv = Invoice.fromJson({
      'id': 'i1',
      'numeroFacture': 'FAC-2026-001001',
      'montantTotal': 330000,
      'montantPaye': 200000,
      'soldeRestant': 130000,
      'devise': 'XAF',
      'statut': 'EN_RETARD',
      'dateEcheance': '2026-10-14T00:00:00.000Z',
      'academicYear': {'id': 'y', 'libelle': '2026-2027'},
      'lines': [
        {'id': 'l1', 'titre': 'Scolarité — 1re tranche', 'type': 'SCOLARITE_TRANCHE', 'montant': 330000, 'dateLimite': '2026-10-14T00:00:00.000Z', 'montantPaye': 200000, 'resteAPayer': 130000, 'statut': 'EN_RETARD'},
      ],
    });
    expect(inv.payable, isTrue);
    expect(inv.title, 'Scolarité — 1re tranche');
    expect(inv.progress, closeTo(0.606, 0.001));
    expect(inv.lines.single.resteAPayer, 130000);
  });

  test('Dashboard : sections optionnelles et alertes', () {
    final d = Dashboard.fromJson({
      'finances': {'devise': 'XAF', 'totalDu': 1110000, 'totalPaye': 295000, 'resteAPayer': 815000, 'prochaineEcheance': null, 'statut': 'EN_RETARD'},
      'presence': {'tauxAssiduiteMois': 91.3, 'seancesMois': 23, 'absencesMois': 2, 'retardsMois': 1, 'dernieresAbsences': []},
      'resultats': {'semestre': null, 'moyenneGenerale': 14.54, 'creditsAcquis': 12, 'dernieresNotes': []},
      'aujourdhui': [],
      'alertes': [{'type': 'IMPAYE', 'niveau': 'danger', 'message': '1 échéance en retard'}],
      'actualites': [],
    });
    expect(d.finances.resteAPayer, 815000);
    expect(d.presence.tauxAssiduiteMois, 91.3);
    expect(d.alertes.single.type, 'IMPAYE');
  });

  test('AttendanceStats : compteurs par statut', () {
    final s = AttendanceStats.fromJson({
      'tauxGlobal': 94.4,
      'totaux': {'seances': 36, 'PRESENT': 33, 'ABSENT': 2, 'RETARD': 1, 'absencesNonJustifiees': 1},
      'parMatiere': [],
      'parSemaine': [],
    });
    expect(s.totaux.absents, 2);
    expect(s.totaux.excuses, 0);
  });

  test('Notification push → écran cible', () {
    expect(PushService.routeFor({'type': 'PAYMENT_VALIDATED'}), RoutePaths.finances);
    expect(PushService.routeFor({'type': 'MESSAGE', 'conversationId': 'c1'}), RoutePaths.conversation('c1'));
    expect(PushService.routeFor({'type': 'GRADES_PUBLISHED'}), RoutePaths.tracking);
    expect(PushService.routeFor({}), RoutePaths.notifications);
  });
}
