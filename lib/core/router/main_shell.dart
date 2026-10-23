import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/messaging/data/messaging_repository.dart';
import '../constants/app_text_styles.dart';
import '../theme/app_animations.dart';
import '../widgets/offline_banner.dart';
import '../widgets/ui.dart';

/// Coque principale : dock flottant à 5 onglets (cahier des charges §11)
/// Accueil · Finances · Suivi (présences + notes) · Messages · Plus.
class MainShell extends ConsumerWidget {
  final StatefulNavigationShell shell;
  const MainShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final unreadMessages = ref.watch(conversationsProvider).value?.data.items.fold<int>(0, (s, c) => s + c.nonLus) ?? 0;

    return Scaffold(
      // Le contenu défile sous le dock flottant (les listes ajoutent context.bottomInset).
      extendBody: true,
      body: Stack(children: [
        Column(children: [
          const OfflineBanner(),
          Expanded(child: _TabFade(index: shell.currentIndex, child: shell)),
        ]),
        // Voile bas : le contenu s'évanouit dans le ciel avant de passer sous le dock.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: MediaQuery.paddingOf(context).bottom + 28,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [context.strato.base.withValues(alpha: 0), context.strato.base.withValues(alpha: 0.92)],
                  stops: const [0, 0.55],
                ),
              ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: StratoDock(
        index: shell.currentIndex,
        onSelect: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        items: [
          DockItem(Icons.home_outlined, Icons.home_rounded, l.navHome),
          DockItem(Icons.account_balance_wallet_outlined, Icons.account_balance_wallet_rounded, l.navFinances),
          DockItem(Icons.insights_outlined, Icons.insights_rounded, l.navTracking),
          DockItem(Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, l.navMessages, badge: unreadMessages),
          DockItem(Icons.grid_view_outlined, Icons.grid_view_rounded, l.navMore),
        ],
      ),
    );
  }
}

/// Changement d'onglet : le nouvel écran émerge en fondu et monte légèrement.
/// L'enfant garde son élément (les piles de navigation des onglets sont conservées).
class _TabFade extends StatefulWidget {
  final int index;
  final Widget child;
  const _TabFade({required this.index, required this.child});

  @override
  State<_TabFade> createState() => _TabFadeState();
}

class _TabFadeState extends State<_TabFade> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 420), value: 1);
  late final Animation<double> _t = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void didUpdateWidget(_TabFade old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index && !AppMotion.reduced(context)) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _t,
        child: widget.child,
        builder: (_, child) => Opacity(
          opacity: 0.2 + 0.8 * _t.value,
          child: Transform.translate(offset: Offset(0, 16 * (1 - _t.value)), child: child),
        ),
      );
}

class DockItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badge;
  const DockItem(this.icon, this.activeIcon, this.label, {this.badge = 0});
}

/// Barre de navigation en verre flottant : une pastille dorée glisse sous
/// l'onglet actif, l'icône s'illumine et le libellé apparaît.
class StratoDock extends StatelessWidget {
  final int index;
  final List<DockItem> items;
  final ValueChanged<int> onSelect;
  const StratoDock({super.key, required this.index, required this.items, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: s.isDark ? const Color(0xFC0A1430) : const Color(0xFCFFFFFF),
            border: Border.all(color: s.hairlineStrong),
            boxShadow: [
              BoxShadow(color: s.isDark ? Colors.black.withValues(alpha: 0.5) : s.shadow, blurRadius: 30, offset: const Offset(0, 12)),
              if (s.isDark) BoxShadow(color: s.accent.withValues(alpha: 0.10), blurRadius: 40, spreadRadius: -10),
            ],
          ),
          child: LayoutBuilder(builder: (context, c) {
            final w = c.maxWidth / items.length;
            return Stack(children: [
              // Pastille active.
              AnimatedPositioned(
                duration: const Duration(milliseconds: 520),
                curve: Curves.easeOutBack,
                left: w * index + 6,
                top: 7,
                width: w - 12,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [s.gold.withValues(alpha: s.isDark ? 0.22 : 0.18), s.gold.withValues(alpha: 0.04)],
                    ),
                    border: Border.all(color: s.gold.withValues(alpha: 0.35)),
                  ),
                ),
              ),
              Row(children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _DockButton(
                      item: items[i],
                      selected: i == index,
                      onTap: () {
                        if (i != index) HapticFeedback.selectionClick();
                        onSelect(i);
                      },
                    ),
                  ),
              ]),
            ]);
          }),
        ),
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  final DockItem item;
  final bool selected;
  final VoidCallback onTap;
  const _DockButton({required this.item, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final color = selected ? s.gold : s.textMuted;
    Widget icon = AnimatedScale(
      scale: selected ? 1.12 : 1,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      child: AnimatedSwitcher(
        duration: AppMotion.fast,
        child: Icon(selected ? item.activeIcon : item.icon, key: ValueKey(selected), color: color, size: 23),
      ),
    );
    if (item.badge > 0) {
      icon = Badge(label: Text('${item.badge}'), child: icon);
    }
    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            icon,
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: AppMotion.medium,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 10.5,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: selected ? 0.3 : 0,
              ),
              child: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ]),
        ),
      ),
    );
  }
}
