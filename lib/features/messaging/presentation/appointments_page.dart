import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text_styles.dart';
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
        builder: (context, list) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: list
              .map((a) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(a.objet, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                      subtitle: Text('${Fmt.dateTime(a.debut)}\n${a.hote.label}${a.lieu != null ? '\n${a.lieu}' : ''}'),
                      isThreeLine: true,
                      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                        StatusChip.status(a.statut, appointmentStatusLabel(a.statut)),
                        if (a.statut == 'DEMANDE' || a.statut == 'CONFIRME')
                          InkWell(
                            onTap: () async {
                              try {
                                await ref.read(messagingRepositoryProvider).cancelAppointment(a.id);
                                ref.invalidate(appointmentsProvider);
                              } catch (e) {
                                if (context.mounted) context.showError(e);
                              }
                            },
                            child: Padding(padding: const EdgeInsets.only(top: 6), child: Text(l.cancel, style: const TextStyle(color: Colors.red))),
                          ),
                      ]),
                    ),
                  ))
              .toList(),
        ),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.viewInsetsOf(context).bottom + 16),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.newAppointment, style: AppTextStyles.h3),
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
        AppButton(text: l.send, isLoading: _loading, onPressed: _submit),
      ]),
    );
  }
}
