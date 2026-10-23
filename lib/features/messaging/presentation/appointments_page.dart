import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_animations.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/ui.dart';
import '../data/messaging_repository.dart';
import '../domain/messaging_models.dart';

String appointmentStatusLabel(String s) => switch (s) {
      'DEMANDE' => 'En attente',
      'CONFIRME' => 'Confirmé',
      'ANNULE' => 'Annulé',
      _ => 'Terminé',
    };

class AppointmentsPage extends ConsumerWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.appointmentsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        label: Text(l.newAppointment),
        onPressed: () => showModalBottomSheet<void>(context: context, isScrollControlled: true, showDragHandle: true, builder: (_) => const _NewAppointmentSheet()),
      ),
      body: CachedAsyncView<List<Appointment>>(
        value: ref.watch(appointmentsProvider),
        onRetry: () => ref.invalidate(appointmentsProvider),
        isEmpty: (a) => a.isEmpty,
        emptyTitle: l.noAppointments,
        emptyIcon: Icons.event_available_outlined,
        builder: (context, list) {
          final s = context.strato;
          return ListView(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 100 + context.bottomInset),
            children: [
              for (var i = 0; i < list.length; i++)
                Reveal(
                  index: i,
                  child: Builder(builder: (context) {
                    final a = list[i];
                    final d = a.debut.toLocal();
                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 56,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [s.gold.withValues(alpha: 0.25), s.gold.withValues(alpha: 0.06)]),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: s.gold.withValues(alpha: 0.4)),
                          ),
                          child: Column(children: [
                            Text('${d.day}', style: AppTextStyles.h2.copyWith(color: s.text, fontSize: 22)),
                            Text(Fmt.dayMonth(d).replaceAll(RegExp(r'[0-9.\s]'), '').toUpperCase(), maxLines: 1, style: AppTextStyles.overline.copyWith(color: s.gold, fontSize: 9.5, letterSpacing: 1)),
                          ]),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(a.objet, style: AppTextStyles.bodyLarge.copyWith(color: s.text, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 3),
                            Text('${Fmt.time(a.debut)} · ${a.hote.label}${a.lieu != null ? '\n${a.lieu}' : ''}', style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
                            const SizedBox(height: 8),
                            Row(children: [
                              StatusChip.status(a.statut, appointmentStatusLabel(a.statut)),
                              const Spacer(),
                              if (a.statut == 'DEMANDE' || a.statut == 'CONFIRME')
                                TextButton(
                                  style: TextButton.styleFrom(foregroundColor: s.danger, visualDensity: VisualDensity.compact),
                                  onPressed: () async {
                                    try {
                                      await ref.read(messagingRepositoryProvider).cancelAppointment(a.id);
                                      ref.invalidate(appointmentsProvider);
                                    } catch (e) {
                                      if (context.mounted) context.showError(e);
                                    }
                                  },
                                  child: Text(l.cancel),
                                ),
                            ]),
                          ]),
                        ),
                      ]),
                    );
                  }),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _NewAppointmentSheet extends ConsumerStatefulWidget {
  const _NewAppointmentSheet();

  @override
  ConsumerState<_NewAppointmentSheet> createState() => _NewAppointmentSheetState();
}

class _NewAppointmentSheetState extends ConsumerState<_NewAppointmentSheet> {
  final _subject = TextEditingController();
  String? _hostId;
  DateTime _day = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 0);
  bool _loading = false;

  Future<void> _submit() async {
    final l = context.l10n;
    if (_hostId == null || _subject.text.trim().isEmpty) return context.showSnack(l.fieldRequired, error: true);
    final start = DateTime(_day.year, _day.month, _day.day, _time.hour, _time.minute);
    setState(() => _loading = true);
    try {
      await ref.read(messagingRepositoryProvider).requestAppointment(_hostId!, _subject.text.trim(), start, start.add(const Duration(minutes: 30)));
      ref.invalidate(appointmentsProvider);
      if (!mounted) return;
      Navigator.pop(context);
      context.showSnack(l.appointmentRequested);
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hosts = ref.watch(appointmentHostsProvider).value ?? const <AppointmentHost>[];
    final s = context.strato;
    return AnimatedPadding(
      duration: AppMotion.fast,
      padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.viewInsetsOf(context).bottom + 16),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.newAppointment, style: AppTextStyles.h2.copyWith(color: s.text, fontSize: 21)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _hostId,
          isExpanded: true,
          decoration: InputDecoration(labelText: l.withLabel),
          items: hosts.map((h) => DropdownMenuItem(value: h.id, child: Text(h.label, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: (v) => setState(() => _hostId = v),
        ),
        const SizedBox(height: 12),
        TextField(controller: _subject, decoration: InputDecoration(labelText: l.subject)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today_rounded),
              label: Text(Fmt.date(_day)),
              onPressed: () async {
                final d = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)), initialDate: _day);
                if (d != null) setState(() => _day = d);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.schedule_rounded),
              label: Text(_time.format(context)),
              onPressed: () async {
                final t = await showTimePicker(context: context, initialTime: _time);
                if (t != null) setState(() => _time = t);
              },
            ),
          ),
        ]),
        const SizedBox(height: 16),
        AppButton(text: l.send, icon: Icons.send_rounded, isLoading: _loading, onPressed: _submit),
      ]),
    );
  }
}
