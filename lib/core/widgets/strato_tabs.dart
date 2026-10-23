import 'package:flutter/material.dart';

import '../theme/strato.dart';

/// Onglets en pilule de verre : la pastille dorée (thème) glisse d'un onglet à l'autre.
/// S'utilise en `AppBar.bottom`.
class StratoTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  const StratoTabBar({super.key, required this.tabs});

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: s.glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: s.hairline)),
        child: TabBar(tabs: [for (final t in tabs) Tab(text: t, height: 40)]),
      ),
    );
  }
}
