import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/pulsing_indicator.dart';
import '../../../core/widgets/spring_pressable.dart';
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
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          _Header(firstName: user?.firstName ?? '', unread: unread),
          Expanded(child: ChildScope(builder: (context, child) => _DashboardBody(child: child))),
        ]),
      ),
    );
  }
}

/// En-tête : date du jour en sur-titre, salutation et cloche des notifications.
class _Header extends StatelessWidget {
  final String firstName;
  final int unread;
  const _Header({required this.firstName, required this.unread});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 6),
      child: Row(children: [
        Expanded(
          child: Reveal(
            offset: 12,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${Fmt.weekday(now)} · ${Fmt.dayMonth(now)}'.toUpperCase(), style: AppTextStyles.overline.copyWith(color: s.gold)),
              const SizedBox(height: 6),
              Text(context.l10n.hello(firstName), style: AppTextStyles.h1.copyWith(color: s.text, fontSize: 28), maxLines: 1, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ),
        Reveal(
          index: 1,
          offset: 12,
          child: SpringPressable(
            onTap: () => context.push(RoutePaths.notifications),
            semanticLabel: context.l10n.notificationsTitle,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(shape: BoxShape.circle, color: s.glass, border: Border.all(color: s.hairlineStrong)),
              child: Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
                Icon(unread > 0 ? Icons.notifications_active_rounded : Icons.notifications_none_rounded, color: s.text),
                if (unread > 0)
                  Positioned(
                    top: 6,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      constraints: const BoxConstraints(minWidth: 18),
                      decoration: BoxDecoration(
                        color: s.danger,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: s.base, width: 1.5),
                        boxShadow: [BoxShadow(color: s.danger.withValues(alpha: 0.6), blurRadius: 8)],
                      ),
                      child: Text('$unread', textAlign: TextAlign.center, style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10)),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      ]),
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

    return CachedAsyncView<Dashboard>(
      value: value,
      onRetry: () => ref.invalidate(dashboardProvider(child.id)),
      builder: (context, d) {
        var i = 0;
        Widget r(Widget w) => Reveal(index: i++, child: w);
        return RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 28 + context.bottomInset),
            children: [
              r(const ChildSelector()),
              if (d.alertes.isNotEmpty) ...[const SizedBox(height: 12), r(_Alerts(d.alertes))],
              const SizedBox(height: 12),
              r(_OrbitStats(d)),
              const SizedBox(height: 12),
              r(_QuickActions(child: child, invoiceId: d.finances.prochaineEcheance?.invoiceId)),
              const SizedBox(height: 12),
              r(_FinanceHero(d.finances, canPay: child.estPayeur)),
              const SizedBox(height: 12),
              r(_TodayCard(d.aujourdhui)),
              const SizedBox(height: 12),
              r(_ResultsCard(d.resultats)),
              const SizedBox(height: 12),
              r(_PresenceCard(d.presence)),
              if (d.actualites.isNotEmpty) ...[
                SectionLabel(context.l10n.newsCard, trailing: TextButton(onPressed: () => context.push(RoutePaths.announcements), child: Text(context.l10n.seeAll))),
                r(_NewsCarousel(d.actualites)),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Alerts extends StatelessWidget {
  final List<DashboardAlert> alerts;
  const _Alerts(this.alerts);

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Column(
      children: alerts.map((a) {
        final color = switch (a.niveau) { 'danger' => s.danger, 'warning' => s.warning, _ => s.info };
        final route = switch (a.type) {
          'IMPAYE' => RoutePaths.finances,
          'ABSENCES_REPETEES' => RoutePaths.tracking,
          'CONVOCATION' => RoutePaths.discipline,
          _ => RoutePaths.documents,
        };
        return GlassCard(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.fromLTRB(8, 10, 14, 10),
          radius: 20,
          tint: color.withValues(alpha: s.isDark ? 0.12 : 0.08),
          borderColor: color.withValues(alpha: 0.5),
          glow: a.niveau == 'danger' ? color : null,
          onTap: () => route.startsWith('/finances') || route.startsWith('/tracking') ? context.go(route) : context.push(route),
          child: Row(children: [
            PulsingIndicator(color: color, size: 9),
            const SizedBox(width: 6),
            Expanded(child: Text(a.message, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: s.text))),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color),
          ]),
        );
      }).toList(),
    );
  }
}

/// Trois jauges orbitales : part payée, assiduité du mois, moyenne générale.
class _OrbitStats extends StatelessWidget {
  final Dashboard d;
  const _OrbitStats(this.d);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final f = d.finances;
    final paid = f.totalDu == 0 ? 1.0 : f.totalPaye / f.totalDu;
    final rate = d.presence.tauxAssiduiteMois;
    final avg = d.resultats.moyenneGenerale;

    Widget gauge(double? value, Color color, Widget center, String label, VoidCallback onTap) => Expanded(
          child: SpringPressable(
            onTap: onTap,
            semanticLabel: label,
            child: Column(children: [
              OrbitGauge(value: value, color: color, size: 86, stroke: 7, center: center),
              const SizedBox(height: 10),
              Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.caption.copyWith(color: s.textMuted, fontWeight: FontWeight.w700)),
            ]),
          ),
        );
    TextStyle big() => AppTextStyles.h2.copyWith(color: s.text, fontSize: 20, fontFeatures: const [FontFeature.tabularFigures()]);

    return GlassCard(
      padding: const EdgeInsets.fromLTRB(8, 18, 8, 16),
      child: Row(children: [
        gauge(paid, switch (f.statut) { 'EN_RETARD' => s.danger, 'A_PAYER' => s.gold, _ => s.success }, CountUp(value: paid * 100, format: (v) => '${v.round()}%', style: big()), l.totalPaid, () => context.go(RoutePaths.finances)),
        gauge(rate == null ? null : rate / 100, s.scale(rate == null ? null : rate / 100), rate == null ? Text('—', style: big()) : CountUp(value: rate, format: (v) => '${v.round()}%', style: big()), l.attendanceCard,
            () => context.go(RoutePaths.tracking)),
        gauge(avg == null ? null : avg / 20, avg == null ? s.info : (avg >= 12 ? s.success : avg >= 10 ? s.warning : s.danger),
            avg == null ? Text('—', style: big()) : CountUp(value: avg, format: (v) => v.toStringAsFixed(1).replaceAll('.', ','), style: big()), l.generalAverage, () => context.go('${RoutePaths.tracking}?tab=1')),
      ]),
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
    final s = context.strato;
    final actions = [
      if (child.estPayeur)
        (Icons.payments_rounded, l.quickPay, s.gold, () => invoiceId != null ? context.push(RoutePaths.pay(invoiceId!)) : context.go(RoutePaths.finances)),
      (Icons.edit_note_rounded, l.quickWrite, const Color(0xFF8B7BFF), () => context.push(RoutePaths.newTicket)),
      (Icons.folder_open_rounded, l.quickDocuments, s.info, () => context.push(RoutePaths.documents)),
      (Icons.calendar_month_rounded, l.quickTimetable, s.success, () => context.push(RoutePaths.timetable)),
    ];
    return Row(
      children: [
        for (var i = 0; i < actions.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 5, right: i == actions.length - 1 ? 0 : 5),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                radius: 22,
                onTap: actions[i].$4,
                semanticLabel: actions[i].$2,
                child: Column(children: [
                  GlowIcon(actions[i].$1, color: actions[i].$3, size: 44),
                  const SizedBox(height: 9),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(actions[i].$2, style: AppTextStyles.caption.copyWith(color: s.text, fontWeight: FontWeight.w700), maxLines: 1),
                  ),
                ]),
              ),
            ),
          ),
      ],
    );
  }
}

/// Carte héroïque : montant restant qui défile, progression dorée, prochaine échéance.
class _FinanceHero extends StatelessWidget {
  final DashboardFinances f;
  final bool canPay;
  const _FinanceHero(this.f, {required this.canPay});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final (label, status) = switch (f.statut) {
      'EN_RETARD' => (l.overdue, 'EN_RETARD'),
      'A_PAYER' => (l.toPay, 'A_PAYER'),
      _ => (l.upToDate, 'PAYE'),
    };
    final color = StatusStyle.of(status).color;
    const muted = Color(0xB3FFFFFF);
    final next = f.prochaineEcheance;

    return GlassCard(
      gradient: s.heroGradient,
      glow: s.accentDeep,
      radius: 28,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      onTap: () => context.go(RoutePaths.finances),
      semanticLabel: l.financialSituation,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFFFBE0A4), size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(l.financialSituation.toUpperCase(), style: AppTextStyles.overline.copyWith(color: muted))),
          _HeroChip(label: label, color: color),
        ]),
        const SizedBox(height: 16),
        Text(l.remaining, style: AppTextStyles.bodySmall.copyWith(color: muted)),
        const SizedBox(height: 2),
        CountUp(
          value: f.resteAPayer.toDouble(),
          format: (v) => Fmt.money(v, f.devise),
          style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 36),
        ),
        const SizedBox(height: 14),
        ProgressBar(f.totalDu == 0 ? 1 : f.totalPaye / f.totalDu, color: const Color(0xFFF2C063)),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _HeroFigure(l.totalDue, Fmt.money(f.totalDu, f.devise))),
          Container(width: 1, height: 34, color: Colors.white.withValues(alpha: 0.14)),
          const SizedBox(width: 16),
          Expanded(child: _HeroFigure(l.totalPaid, Fmt.money(f.totalPaye, f.devise), color: const Color(0xFF6EE7B7))),
        ]),
        if (next != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: 0.12))),
            child: Row(children: [
              const Icon(Icons.event_rounded, color: Color(0xFFFBE0A4), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${l.nextDue} · ${Fmt.dayMonth(next.date)}', style: AppTextStyles.caption.copyWith(color: muted)),
                  Text(Fmt.money(next.montant, f.devise), style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 16)),
                ]),
              ),
              if (canPay)
                SpringPressable(
                  onTap: () => context.push(RoutePaths.pay(next.invoiceId)),
                  semanticLabel: l.pay,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: Strato.goldGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: s.gold.withValues(alpha: 0.45), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: Text(l.pay, style: AppTextStyles.button.copyWith(color: s.onGold, fontSize: 14)),
                  ),
                ),
            ]),
          ),
        ],
      ]),
    );
  }
}

class _HeroFigure extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _HeroFigure(this.label, this.value, {this.color = Colors.white});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: const Color(0xB3FFFFFF))),
        const SizedBox(height: 2),
        FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(value, style: AppTextStyles.h3.copyWith(color: color, fontSize: 15.5))),
      ]);
}

/// Pastille de statut lisible sur une surface héroïque (toujours sombre).
class _HeroChip extends StatelessWidget {
  final String label;
  final Color color;
  const _HeroChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: color.withValues(alpha: 0.6)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          PulsingIndicator(color: color, size: 6),
          Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
        ]),
      );
}

/// Cours du jour en frise : horaires, fil lumineux, cours en direct qui pulse.
class _TodayCard extends StatelessWidget {
  final List<TodaySlot> slots;
  const _TodayCard(this.slots);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final now = DateTime.now();
    return SectionCard(
      title: l.todayCard,
      icon: Icons.today_rounded,
      iconColor: s.info,
      onTap: () => context.push(RoutePaths.timetable),
      child: slots.isEmpty
          ? Row(children: [
              Icon(Icons.wb_sunny_outlined, color: s.gold, size: 20),
              const SizedBox(width: 10),
              Text(l.noClassToday, style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted)),
            ])
          : Column(children: [
              for (var i = 0; i < slots.length; i++)
                _TimelineRow(
                  slot: slots[i],
                  live: !now.isBefore(slots[i].debut.toLocal()) && now.isBefore(slots[i].fin.toLocal()) && slots[i].statut != 'ANNULE',
                  past: now.isAfter(slots[i].fin.toLocal()),
                  last: i == slots.length - 1,
                ),
            ]),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final TodaySlot slot;
  final bool live;
  final bool past;
  final bool last;
  const _TimelineRow({required this.slot, required this.live, required this.past, required this.last});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final cancelled = slot.statut == 'ANNULE';
    final dot = cancelled ? s.danger : live ? s.gold : (past ? s.textFaint : s.accent);
    return Opacity(
      opacity: past && !live ? 0.6 : 1,
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            width: 50,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(Fmt.time(slot.debut), style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w800)),
              Text(Fmt.time(slot.fin), style: AppTextStyles.caption.copyWith(color: s.textFaint)),
            ]),
          ),
          SizedBox(
            width: 26,
            child: Column(children: [
              const SizedBox(height: 4),
              live
                  ? PulsingIndicator(color: dot, size: 8)
                  : Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.all(7),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: dot, boxShadow: [BoxShadow(color: dot.withValues(alpha: 0.6), blurRadius: 8)]),
                    ),
              if (!last) Expanded(child: Container(width: 1.5, margin: const EdgeInsets.symmetric(vertical: 2), color: s.hairlineStrong)),
            ]),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                    child: Text(
                      slot.matiere,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: s.text,
                        fontWeight: FontWeight.w700,
                        decoration: cancelled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  if (cancelled) StatusChip.status('ANNULE', l.cancelledClass),
                  if (live) Text('LIVE', style: AppTextStyles.overline.copyWith(color: s.gold)),
                ]),
                const SizedBox(height: 2),
                Text('${l.room(slot.salle)} · ${slot.campus}', style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _ResultsCard extends StatelessWidget {
  final DashboardResults r;
  const _ResultsCard(this.r);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final avg = r.moyenneGenerale;
    return SectionCard(
      title: l.resultsCard,
      icon: Icons.auto_awesome_rounded,
      iconColor: s.gold,
      onTap: () => context.go('${RoutePaths.tracking}?tab=1'),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          avg == null
              ? Text('—', style: AppTextStyles.display.copyWith(color: s.text, fontSize: 34))
              : CountUp(
                  value: avg,
                  format: (v) => v.toStringAsFixed(2).replaceAll('.', ','),
                  style: AppTextStyles.display.copyWith(color: avg >= 10 ? s.text : s.danger, fontSize: 34),
                ),
          Padding(padding: const EdgeInsets.only(bottom: 5, left: 4), child: Text('/ 20', style: AppTextStyles.h3.copyWith(color: s.textFaint))),
          const Spacer(),
          if (r.semestre != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: s.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: s.gold.withValues(alpha: 0.35))),
              child: Text(r.semestre!.code, style: AppTextStyles.caption.copyWith(color: s.gold, fontWeight: FontWeight.w800)),
            ),
        ]),
        Text(l.generalAverage, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
        const SizedBox(height: 12),
        if (r.dernieresNotes.isEmpty)
          Text(l.noGrades, style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted))
        else
          for (final g in r.dernieresNotes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                    child: Text('${g.matiere} — ${g.evaluation}', style: AppTextStyles.bodyMedium.copyWith(color: s.text), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 8),
                  Text(Fmt.grade(g.valeur, g.bareme),
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: g.valeur / g.bareme >= 0.5 ? s.success : s.danger)),
                ]),
                const SizedBox(height: 6),
                ProgressBar(g.valeur / g.bareme, color: g.valeur / g.bareme >= 0.5 ? s.success : s.danger, height: 4),
              ]),
            ),
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
    final s = context.strato;
    final rate = p.tauxAssiduiteMois;
    return SectionCard(
      title: l.attendanceCard,
      icon: Icons.how_to_reg_rounded,
      iconColor: s.success,
      onTap: () => context.go(RoutePaths.tracking),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _Pill(Fmt.percent(rate), l.attendanceRateMonth, s.scale(rate == null ? null : rate / 100)),
          const SizedBox(width: 8),
          _Pill('${p.absencesMois}', l.absent, s.danger),
          const SizedBox(width: 8),
          _Pill('${p.retardsMois}', l.late, s.warning),
        ]),
        const SizedBox(height: 12),
        if (p.dernieresAbsences.isEmpty)
          Row(children: [
            Icon(Icons.verified_rounded, color: s.success, size: 18),
            const SizedBox(width: 8),
            Text(l.noAbsence, style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted)),
          ])
        else
          for (final a in p.dernieresAbsences)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(children: [
                Icon(StatusStyle.of(a.statut).icon, size: 18, color: StatusStyle.of(a.statut).color),
                const SizedBox(width: 10),
                Expanded(child: Text('${a.cours} · ${Fmt.dayMonth(a.date)}', style: AppTextStyles.bodyMedium.copyWith(color: s.text), overflow: TextOverflow.ellipsis)),
                if (a.justification == 'VALIDE') StatusChip.status('VALIDE', l.justified),
              ]),
            ),
      ]),
    );
  }
}

class _Pill extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _Pill(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: s.isDark ? 0.10 : 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.28)),
        ),
        child: Column(children: [
          Text(value, style: AppTextStyles.h3.copyWith(color: color, fontSize: 18)),
          const SizedBox(height: 2),
          Text(label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.caption.copyWith(color: s.textMuted, height: 1.2)),
        ]),
      ),
    );
  }
}

class _NewsCarousel extends StatelessWidget {
  final List<NewsItem> news;
  const _NewsCarousel(this.news);

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return SizedBox(
      height: 156,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: news.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final n = news[i];
          return SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.74,
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              onTap: () => context.push(RoutePaths.announcements),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  GlowIcon(Icons.campaign_rounded, color: s.gold, size: 32, radius: 10),
                  const Spacer(),
                  Text(Fmt.dayMonth(n.datePublication), style: AppTextStyles.caption.copyWith(color: s.textFaint)),
                ]),
                const SizedBox(height: 10),
                Text(n.titre, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyLarge.copyWith(color: s.text, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Expanded(child: Text(n.contenu, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted))),
              ]),
            ),
          );
        },
      ),
    );
  }
}
