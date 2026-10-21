import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/domain/attendance_models.dart';
import '../../features/attendance/presentation/justify_absence_page.dart';
import '../../features/auth/application/session_controller.dart';
import '../../features/auth/presentation/activation_page.dart';
import '../../features/auth/presentation/forgot_password_page.dart';
import '../../features/auth/presentation/lock_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/onboarding_page.dart';
import '../../features/auth/presentation/otp_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/documents/presentation/discipline_page.dart';
import '../../features/documents/presentation/documents_page.dart';
import '../../features/finance/presentation/finances_page.dart';
import '../../features/finance/presentation/invoice_page.dart';
import '../../features/finance/presentation/payment_page.dart';
import '../../features/finance/presentation/payment_status_page.dart';
import '../../features/messaging/presentation/announcements_page.dart';
import '../../features/messaging/presentation/appointments_page.dart';
import '../../features/messaging/presentation/conversation_page.dart';
import '../../features/messaging/presentation/conversations_page.dart';
import '../../features/messaging/presentation/new_ticket_page.dart';
import '../../features/more/presentation/about_page.dart';
import '../../features/more/presentation/more_page.dart';
import '../../features/more/presentation/profile_page.dart';
import '../../features/more/presentation/scan_page.dart';
import '../../features/more/presentation/settings_page.dart';
import '../../features/notifications/presentation/notifications_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/timetable/domain/nfc_payload.dart';
import '../../features/timetable/domain/timetable_models.dart';
import '../../features/timetable/presentation/calendar_page.dart';
import '../../features/timetable/presentation/shared_timetable_page.dart';
import '../../features/timetable/presentation/slot_detail_page.dart';
import '../../features/timetable/presentation/timetable_page.dart';
import '../../features/tracking/presentation/tracking_page.dart';
import '../providers.dart';
import '../security/app_lock.dart';
import 'main_shell.dart';
import 'route_paths.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Rafraîchit le routeur quand la session ou le verrouillage changent.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(sessionProvider, (_, __) => notifyListeners());
    ref.listen(appLockProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  GoRoute page(String path, Widget Function(GoRouterState s) build) =>
      GoRoute(path: path, parentNavigatorKey: rootNavigatorKey, builder: (_, s) => build(s));

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final loc = state.matchedLocation;
      // Lien profond ouvert application fermée (ex. tag NFC /salle/S104) : la destination est
      // conservée pendant le chargement de session et le verrouillage, puis rejointe.
      final from = state.uri.queryParameters['from'];
      String hold(String target) {
        final next = loc == RoutePaths.splash || loc == RoutePaths.lock ? from : state.uri.toString();
        return next == null || next == RoutePaths.splash ? target : Uri(path: target, queryParameters: {'from': next}).toString();
      }

      if (session.isLoading) return loc == RoutePaths.splash ? null : hold(RoutePaths.splash);

      final loggedIn = session.value != null;
      final isPublic = RoutePaths.publicRoutes.contains(loc);
      if (!loggedIn) {
        if (!ref.read(sharedPrefsProvider).hasCompletedOnboarding) return loc == RoutePaths.onboarding ? null : RoutePaths.onboarding;
        return isPublic && loc != RoutePaths.splash ? null : RoutePaths.login;
      }

      if (ref.read(appLockProvider)) return loc == RoutePaths.lock ? null : hold(RoutePaths.lock);
      if (isPublic || loc == RoutePaths.lock) {
        final target = from == null ? null : Uri.tryParse(from);
        final internal = target != null && !target.hasScheme && target.path.startsWith('/') && !RoutePaths.publicRoutes.contains(target.path);
        return internal ? from : RoutePaths.home;
      }
      return null;
    },
    routes: [
      GoRoute(path: RoutePaths.splash, builder: (_, __) => const SplashPage()),
      GoRoute(path: RoutePaths.onboarding, builder: (_, __) => const OnboardingPage()),
      GoRoute(path: RoutePaths.login, builder: (_, __) => const LoginPage()),
      GoRoute(path: RoutePaths.otp, builder: (_, s) => OtpPage(phone: s.extra as String? ?? '')),
      GoRoute(path: RoutePaths.activate, builder: (_, s) => ActivationPage(initialCode: s.uri.queryParameters['code'])),
      GoRoute(path: RoutePaths.forgotPassword, builder: (_, __) => const ForgotPasswordPage()),
      GoRoute(path: RoutePaths.lock, builder: (_, __) => const LockPage()),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: RoutePaths.home, builder: (_, __) => const DashboardPage())]),
          StatefulShellBranch(routes: [GoRoute(path: RoutePaths.finances, builder: (_, __) => const FinancesPage())]),
          StatefulShellBranch(routes: [GoRoute(path: RoutePaths.tracking, builder: (_, s) => TrackingPage(initialTab: int.tryParse(s.uri.queryParameters['tab'] ?? '') ?? 0))]),
          StatefulShellBranch(routes: [GoRoute(path: RoutePaths.messages, builder: (_, __) => const ConversationsPage())]),
          StatefulShellBranch(routes: [GoRoute(path: RoutePaths.more, builder: (_, __) => const MorePage())]),
        ],
      ),
      page('/finances/invoice/:id', (s) => InvoicePage(invoiceId: s.pathParameters['id']!)),
      page('/finances/pay/:id', (s) => PaymentPage(invoiceId: s.pathParameters['id']!)),
      page('/finances/payment/:id', (s) => PaymentStatusPage(paymentId: s.pathParameters['id']!, initialUrl: s.extra as String?)),
      page('/tracking/justify', (s) => JustifyAbsencePage(item: s.extra! as AttendanceItem)),
      page(RoutePaths.timetable, (s) {
        final q = s.uri.queryParameters;
        return TimetablePage(initialWeek: q['week'], sheet: q['sheet'], nfcMode: q['nfc']);
      }),
      GoRoute(
        path: '/timetable/slot/:id',
        parentNavigatorKey: rootNavigatorKey,
        // Fondu : la carte du cours vole vers sa place (Hero) pendant la transition.
        pageBuilder: (_, s) => CustomTransitionPage(
          key: s.pageKey,
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic), child: child),
          child: s.extra is TimetableSlot ? SlotDetailPage(slot: s.extra! as TimetableSlot) : const TimetablePage(),
        ),
      ),
      page(RoutePaths.timetableShared, (s) => s.extra is NfcTimetableShare ? SharedTimetablePage(share: s.extra! as NfcTimetableShare) : const TimetablePage()),
      // Tag NFC de salle (URI https://uniparent.aframgabon.com/salle/<code>) lu application fermée.
      page('/salle/:code', (s) => TimetablePage(roomCode: s.pathParameters['code'])),
      page(RoutePaths.calendar, (_) => const CalendarPage()),
      page(RoutePaths.newTicket, (_) => const NewTicketPage()),
      page('/messages/thread/:id', (s) => ConversationPage(conversationId: s.pathParameters['id']!)),
      page(RoutePaths.announcements, (_) => const AnnouncementsPage()),
      page(RoutePaths.appointments, (_) => const AppointmentsPage()),
      page(RoutePaths.documents, (_) => const DocumentsPage()),
      page(RoutePaths.discipline, (_) => const DisciplinePage()),
      page(RoutePaths.notifications, (_) => const NotificationsPage()),
      page(RoutePaths.settings, (_) => const SettingsPage()),
      page(RoutePaths.profile, (_) => const ProfilePage()),
      page(RoutePaths.about, (_) => const AboutPage()),
      page(RoutePaths.scan, (_) => const ScanPage()),
    ],
  );
});
