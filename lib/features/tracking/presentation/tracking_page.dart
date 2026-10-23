import 'package:flutter/material.dart';

import '../../../core/widgets/ui.dart';
import '../../attendance/presentation/attendance_tab.dart';
import '../../children/presentation/child_scope.dart';
import '../../grades/presentation/grades_tab.dart';

/// Onglet « Suivi » : présences + notes (cahier des charges §11).
class TrackingPage extends StatelessWidget {
  final int initialTab;
  const TrackingPage({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DefaultTabController(
      length: 2,
      initialIndex: initialTab.clamp(0, 1),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.trackingTitle),
          bottom: StratoTabBar(tabs: [l.attendanceTitle, l.gradesTitle]),
        ),
        body: ChildScope(builder: (context, child) => TabBarView(children: [AttendanceTab(child: child), GradesTab(child: child)])),
      ),
    );
  }
}
