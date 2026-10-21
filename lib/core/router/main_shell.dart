import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/messaging/data/messaging_repository.dart';
import '../widgets/offline_banner.dart';
import '../widgets/ui.dart';

/// Coque principale : navigation inférieure à 5 onglets (cahier des charges §11)
/// Accueil · Finances · Suivi (présences + notes) · Messages · Plus.
class MainShell extends ConsumerWidget {
  final StatefulNavigationShell shell;
  const MainShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final unreadMessages = ref.watch(conversationsProvider).value?.data.items.fold<int>(0, (s, c) => s + c.nonLus) ?? 0;

    return Scaffold(
      body: Column(children: [const OfflineBanner(), Expanded(child: shell)]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home_rounded), label: l.navHome),
          NavigationDestination(icon: const Icon(Icons.account_balance_wallet_outlined), selectedIcon: const Icon(Icons.account_balance_wallet_rounded), label: l.navFinances),
          NavigationDestination(icon: const Icon(Icons.insights_outlined), selectedIcon: const Icon(Icons.insights_rounded), label: l.navTracking),
          NavigationDestination(
            icon: Badge(isLabelVisible: unreadMessages > 0, label: Text('$unreadMessages'), child: const Icon(Icons.chat_bubble_outline_rounded)),
            selectedIcon: const Icon(Icons.chat_bubble_rounded),
            label: l.navMessages,
          ),
          NavigationDestination(icon: const Icon(Icons.menu_rounded), selectedIcon: const Icon(Icons.menu_open_rounded), label: l.navMore),
        ],
      ),
    );
  }
}
