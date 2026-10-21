import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/ui.dart';
import '../../auth/application/session_controller.dart';
import '../../children/application/children_providers.dart';
import '../../children/domain/child.dart';
import '../../children/presentation/child_scope.dart';
import '../../notifications/data/notifications_repository.dart';
import '../application/dashboard_providers.dart';
import '../domain/dashboard.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider).value;
    final unread = ref.watch(unreadCountProvider).value ?? 0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(context.l10n.hello(user?.firstName ?? '')),
        actions: [
          IconButton(
            tooltip: context.l10n.notificationsTitle,
            icon: Badge(isLabelVisible: unread > 0, label: Text('$unread'), child: const Icon(Icons.notifications_outlined)),
            onPressed: () => context.push(RoutePaths.notifications),
          ),
        ],
      ),
      body: ChildScope(builder: (context, child) => _DashboardBody(child: child)),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  final Child child;
  const _DashboardBody({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(dashboardProvider(child.id));
    Future<void> refresh() async {
      ref.invalidate(unreadCountProvider);
      ref.invalidate(childrenProvider);
      ref.invalidate(dashboardProvider(child.id));
      await ref.read(dashboardProvider(child.id).future);
    }

    return Column(children: [
      Container(
        color: AppColors.aframPrimary,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: const ChildSelector(onDark: true),
      ),
      Expanded(
        child: CachedAsyncView<Dashboard>(
          value: value,
          onRetry: () => ref.invalidate(dashboardProvider(child.id)),
          builder: (context, d) => RefreshIndicator(
            onRefresh: refresh,
            child: ListView(padding: const EdgeInsets.all(16), children: [
              if (d.alertes.isNotEmpty) ...[_Alerts(d.alertes), const SizedBox(height: 12)],
              _QuickActions(child: child, invoiceId: d.finances.prochaineEcheance?.invoiceId),
              const SizedBox(height: 12),
              _FinanceCard(d.finances, canPay: child.estPayeur),
              const SizedBox(height: 12),
              _PresenceCard(d.presence),
              const SizedBox(height: 12),
              _ResultsCard(d.resultats),
              const SizedBox(height: 12),
              _TodayCard(d.aujourdhui),
              if (d.actualites.isNotEmpty) ...[const SizedBox(height: 12), _NewsCard(d.actualites)],
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ),
    ]);
  }
}

class _Alerts extends StatelessWidget {
  final List<DashboardAlert> alerts;
  const _Alerts(this.alerts);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: alerts.map((a) {
        final color = switch (a.niveau) { 'danger' => AppColors.error, 'warning' => AppColors.warning, _ => AppColors.info };
        final route = switch (a.type) {
          'IMPAYE' => RoutePaths.finances,
          'ABSENCES_REPETEES' => RoutePaths.tracking,
          'CONVOCATION' => RoutePaths.discipline,
          _ => RoutePaths.documents,
        };
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: color.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: color.withValues(alpha: 0.4))),
          child: ListTile(
            leading: Icon(a.niveau == 'info' ? Icons.info_rounded : Icons.warning_amber_rounded, color: color),
            title: Text(a.message, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            trailing: Icon(Icons.chevron_right_rounded, color: color),
            onTap: () => route.startsWith('/finances') || route.startsWith('/tracking') ? context.go(route) : context.push(route),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final Child child;
  final String? invoiceId;
  const _QuickActions({required this.child, this.invoiceId});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final actions = [
      if (child.estPayeur) (Icons.payments_rounded, l.quickPay, () => invoiceId != null ? context.push(RoutePaths.pay(invoiceId!)) : context.go(RoutePaths.finances)),
      (Icons.edit_note_rounded, l.quickWrite, () => context.push(RoutePaths.newTicket)),
      (Icons.folder_open_rounded, l.quickDocuments, () => context.push(RoutePaths.documents)),
      (Icons.calendar_month_rounded, l.quickTimetable, () => context.push(RoutePaths.timetable)),
    ];
    return Row(
      children: actions
          .map((a) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: a.$3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(children: [
                          Icon(a.$1, color: AppColors.aframPrimary),
                          const SizedBox(height: 6),
                          Text(a.$2, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ]),
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _FinanceCard extends StatelessWidget {
  final DashboardFinances f;
  final bool canPay;
  const _FinanceCard(this.f, {required this.canPay});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, status) = switch (f.statut) {
      'EN_RETARD' => (l.overdue, 'EN_RETARD'),
      'A_PAYER' => (l.toPay, 'A_PAYER'),
      _ => (l.upToDate, 'PAYE'),
    };
    final color = StatusStyle.of(status).color;
    return SectionCard(
      title: l.financialSituation,
      icon: Icons.account_balance_wallet_outlined,
      trailing: StatusChip.status(status, label),
      onTap: () => context.go(RoutePaths.finances),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.remaining, style: AppTextStyles.caption),
        Text(Fmt.money(f.resteAPayer, f.devise), style: AppTextStyles.h1.copyWith(color: color)),
        const SizedBox(height: 10),
        ProgressBar(f.totalDu == 0 ? 1 : f.totalPaye / f.totalDu),
        const SizedBox(height: 8),
        KeyValueRow(l.totalDue, Fmt.money(f.totalDu, f.devise)),
        KeyValueRow(l.totalPaid, Fmt.money(f.totalPaye, f.devise), valueColor: AppColors.success),
        if (f.prochaineEcheance != null) ...[
          const Divider(height: 20),
          Row(children: [
            Expanded(
              child: Text('${l.nextDue} : ${Fmt.date(f.prochaineEcheance!.date)}\n${Fmt.money(f.prochaineEcheance!.montant, f.devise)}',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ),
            if (canPay)
              FilledButton(onPressed: () => context.push(RoutePaths.pay(f.prochaineEcheance!.invoiceId)), child: Text(l.pay)),
          ]),
        ],
      ]),
    );
  }
}

class _PresenceCard extends StatelessWidget {
  final DashboardPresence p;
  const _PresenceCard(this.p);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rate = p.tauxAssiduiteMois;
    final color = rate == null ? AppColors.info : rate >= 90 ? AppColors.success : rate >= 75 ? AppColors.warning : AppColors.error;
    return SectionCard(
      title: l.attendanceCard,
      icon: Icons.how_to_reg_outlined,
      iconColor: AppColors.success,
      onTap: () => context.go(RoutePaths.tracking),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(Fmt.percent(rate), style: AppTextStyles.h1.copyWith(color: color)),
          const SizedBox(width: 10),
          Expanded(child: Text('${l.attendanceRateMonth}\n${p.absencesMois} ${l.absent.toLowerCase()} · ${p.retardsMois} ${l.late.toLowerCase()}', style: AppTextStyles.bodySmall)),
        ]),
        const SizedBox(height: 8),
        if (p.dernieresAbsences.isEmpty)
          Text(l.noAbsence, style: AppTextStyles.bodyMedium)
        else
          ...p.dernieresAbsences.map((a) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(children: [
                  Icon(StatusStyle.of(a.statut).icon, size: 16, color: StatusStyle.of(a.statut).color),
                  const SizedBox(width: 8),
                  Expanded(child: Text('${a.cours} · ${Fmt.dayMonth(a.date)}', style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis)),
                  if (a.justification == 'VALIDE') StatusChip.status('VALIDE', l.justified),
                ]),
              )),
      ]),
    );
  }
}

class _ResultsCard extends StatelessWidget {
  final DashboardResults r;
  const _ResultsCard(this.r);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final avg = r.moyenneGenerale;
    return SectionCard(
      title: l.resultsCard,
      icon: Icons.grade_outlined,
      iconColor: AppColors.aframGold,
      onTap: () => context.go('${RoutePaths.tracking}?tab=1'),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(avg == null ? '—' : Fmt.grade(avg), style: AppTextStyles.h1.copyWith(color: avg == null || avg >= 10 ? AppColors.aframPrimary : AppColors.error)),
          const SizedBox(width: 8),
          Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('${l.generalAverage}${r.semestre != null ? ' · ${r.semestre!.code}' : ''}', style: AppTextStyles.bodySmall)),
        ]),
        const SizedBox(height: 8),
        if (r.dernieresNotes.isEmpty)
          Text(l.noGrades)
        else
          ...r.dernieresNotes.map((g) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(children: [
                  Expanded(child: Text('${g.matiere} — ${g.evaluation}', style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis)),
                  Text(Fmt.grade(g.valeur, g.bareme), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: g.valeur / g.bareme >= 0.5 ? AppColors.success : AppColors.error)),
                ]),
              )),
      ]),
    );
  }
}

class _TodayCard extends StatelessWidget {
  final List<TodaySlot> slots;
  const _TodayCard(this.slots);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SectionCard(
      title: l.todayCard,
      icon: Icons.today_outlined,
      iconColor: AppColors.info,
      onTap: () => context.push(RoutePaths.timetable),
      child: slots.isEmpty
          ? Text(l.noClassToday)
          : Column(
              children: slots
                  .map((s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(children: [
                          SizedBox(width: 92, child: Text('${Fmt.time(s.debut)} – ${Fmt.time(s.fin)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700))),
                          Expanded(
                            child: Text('${s.matiere}\n${l.room(s.salle)} · ${s.campus}',
                                style: AppTextStyles.bodyMedium.copyWith(decoration: s.statut == 'ANNULE' ? TextDecoration.lineThrough : null)),
                          ),
                          if (s.statut == 'ANNULE') StatusChip.status('ANNULE', l.cancelledClass),
                        ]),
                      ))
                  .toList(),
            ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final List<NewsItem> news;
  const _NewsCard(this.news);

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: context.l10n.newsCard,
      icon: Icons.campaign_outlined,
      onTap: () => context.push(RoutePaths.announcements),
      child: Column(
        children: news
            .map((n) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(n.titre, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                  subtitle: Text(n.contenu, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Text(Fmt.dayMonth(n.datePublication), style: AppTextStyles.caption),
                ))
            .toList(),
      ),
    );
  }
}
