import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/widgets/ui.dart';
import '../../auth/application/session_controller.dart';
import '../../children/presentation/child_scope.dart';
import '../../notifications/data/notifications_repository.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(sessionProvider).value;
    final unread = ref.watch(unreadCountProvider).value ?? 0;

    Widget tile(IconData icon, String title, String route, {Widget? trailing}) => ListTile(
          leading: Icon(icon, color: AppColors.aframPrimary),
          title: Text(title),
          trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
          onTap: () => context.push(route),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.moreTitle)),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Avatar(user == null ? '?' : user.displayName.split(' ').map((w) => w.isEmpty ? '' : w[0]).take(2).join().toUpperCase(), radius: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user?.displayName ?? '', style: AppTextStyles.h3),
                Text(user?.email ?? user?.telephone ?? '', style: AppTextStyles.bodySmall),
              ]),
            ),
          ]),
        ),
        if (user?.isParent ?? false) const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: ChildSelector()),
        const Divider(),
        tile(Icons.calendar_month_outlined, l.timetableTitle, RoutePaths.timetable),
        tile(Icons.event_outlined, l.calendarTitle, RoutePaths.calendar),
        tile(Icons.folder_open_outlined, l.documentsTitle, RoutePaths.documents),
        tile(Icons.gavel_outlined, l.disciplineTitle, RoutePaths.discipline),
        tile(Icons.campaign_outlined, l.announcementsTitle, RoutePaths.announcements),
        tile(Icons.event_available_outlined, l.appointmentsTitle, RoutePaths.appointments),
        tile(Icons.notifications_outlined, l.notificationsTitle, RoutePaths.notifications,
            trailing: unread > 0 ? Badge(label: Text('$unread')) : const Icon(Icons.chevron_right_rounded)),
        if (user?.isStudent ?? false) tile(Icons.qr_code_scanner_rounded, l.scanQr, RoutePaths.scan),
        const Divider(),
        tile(Icons.person_outline_rounded, l.profile, RoutePaths.profile),
        tile(Icons.settings_outlined, l.settingsTitle, RoutePaths.settings),
        tile(Icons.info_outline_rounded, l.about, RoutePaths.about),
        ListTile(
          leading: const Icon(Icons.logout_rounded, color: AppColors.error),
          title: Text(l.logout, style: const TextStyle(color: AppColors.error)),
          onTap: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                content: Text(l.logoutConfirm),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
                  FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.logout)),
                ],
              ),
            );
            if (ok == true) await ref.read(sessionProvider.notifier).logout();
          },
        ),
        const SizedBox(height: 24),
      ]),
    );
  }
}
