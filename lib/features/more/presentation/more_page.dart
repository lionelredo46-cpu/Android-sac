import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/widgets/ui.dart';
import '../../auth/application/session_controller.dart';
import '../../children/presentation/child_scope.dart';
import '../../notifications/data/notifications_repository.dart';

/// Libellé lisible d'un rôle (ETUDIANT → Étudiant).
String roleLabel(String role) => switch (role) {
      'PARENT' => 'Parent',
      'ETUDIANT' => 'Étudiant',
      'ENSEIGNANT' => 'Enseignant',
      'SCOLARITE' => 'Scolarité',
      'COMPTABLE' => 'Comptabilité',
      'DIRECTION' => 'Direction',
      'SUPPORT' => 'Support',
      'SUPER_ADMIN' => 'Administration',
      _ => role,
    };

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = context.strato;
    final user = ref.watch(sessionProvider).value;
    final unread = ref.watch(unreadCountProvider).value ?? 0;
    final initials = user == null ? '?' : user.displayName.split(' ').map((w) => w.isEmpty ? '' : w[0]).take(2).join().toUpperCase();

    final features = [
      (Icons.calendar_month_rounded, l.timetableTitle, RoutePaths.timetable, s.accent, 0),
      (Icons.event_rounded, l.calendarTitle, RoutePaths.calendar, const Color(0xFF22D3EE), 0),
      (Icons.folder_open_rounded, l.documentsTitle, RoutePaths.documents, s.gold, 0),
      (Icons.gavel_rounded, l.disciplineTitle, RoutePaths.discipline, const Color(0xFFFB923C), 0),
      (Icons.campaign_rounded, l.announcementsTitle, RoutePaths.announcements, const Color(0xFF8B7BFF), 0),
      (Icons.event_available_rounded, l.appointmentsTitle, RoutePaths.appointments, s.success, 0),
      (Icons.notifications_rounded, l.notificationsTitle, RoutePaths.notifications, s.danger, unread),
      if (user?.isStudent ?? false) (Icons.qr_code_scanner_rounded, l.scanQr, RoutePaths.scan, s.gold, 0),
    ];

    var i = 0;
    Widget r(Widget w) => Reveal(index: i++, child: w);

    Widget row(IconData icon, String title, VoidCallback onTap, {Color? color}) => GlassCard(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
          radius: 20,
          onTap: onTap,
          semanticLabel: title,
          child: Row(children: [
            GlowIcon(icon, color: color ?? s.textMuted, size: 38, radius: 12),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: AppTextStyles.bodyLarge.copyWith(color: color == s.danger ? s.danger : s.text, fontWeight: FontWeight.w600))),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: s.textFaint),
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.moreTitle)),
      body: ListView(padding: EdgeInsets.fromLTRB(16, 4, 16, 28 + context.bottomInset), children: [
        r(GlassCard(
          gradient: s.heroGradient,
          glow: s.accentDeep,
          radius: 28,
          padding: const EdgeInsets.all(18),
          onTap: () => context.push(RoutePaths.profile),
          semanticLabel: l.profile,
          child: Row(children: [
            Avatar(initials, radius: 32, spin: true),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user?.displayName ?? '', style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 21), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(user?.email ?? user?.telephone ?? '', style: AppTextStyles.bodySmall.copyWith(color: const Color(0xB3FFFFFF)), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(gradient: Strato.goldGradient, borderRadius: BorderRadius.circular(99)),
                  child: Text(roleLabel(user?.role ?? '').toUpperCase(), style: AppTextStyles.overline.copyWith(color: s.onGold, fontSize: 9.5)),
                ),
              ]),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xB3FFFFFF)),
          ]),
        )),
        if (user?.isParent ?? false) ...[const SizedBox(height: 12), r(const ChildSelector())],
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.75,
          children: [
            for (final f in features)
              r(GlassCard(
                padding: const EdgeInsets.all(14),
                radius: 22,
                onTap: () => context.push(f.$3),
                semanticLabel: f.$2,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    GlowIcon(f.$1, color: f.$4, size: 40),
                    const Spacer(),
                    if (f.$5 > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: s.danger, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: s.danger.withValues(alpha: 0.6), blurRadius: 10)]),
                        child: Text('${f.$5}', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                      ),
                  ]),
                  const Spacer(),
                  Text(f.$2, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w700, height: 1.2)),
                ]),
              )),
          ],
        ),
        SectionLabel(l.settingsTitle),
        r(row(Icons.person_rounded, l.profile, () => context.push(RoutePaths.profile), color: s.accent)),
        r(row(Icons.tune_rounded, l.settingsTitle, () => context.push(RoutePaths.settings), color: s.gold)),
        r(row(Icons.info_rounded, l.about, () => context.push(RoutePaths.about), color: const Color(0xFF22D3EE))),
        r(row(Icons.logout_rounded, l.logout, () async {
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              icon: Icon(Icons.logout_rounded, color: ctx.strato.danger, size: 30),
              content: Text(l.logoutConfirm, textAlign: TextAlign.center),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
                FilledButton(style: FilledButton.styleFrom(backgroundColor: ctx.strato.danger, foregroundColor: Colors.white), onPressed: () => Navigator.pop(ctx, true), child: Text(l.logout)),
              ],
            ),
          );
          if (ok == true) await ref.read(sessionProvider.notifier).logout();
        }, color: s.danger)),
      ]),
    );
  }
}
