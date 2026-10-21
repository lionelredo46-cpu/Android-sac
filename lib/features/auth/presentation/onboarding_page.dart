import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/widgets/ui.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  Future<void> _finish() async {
    await ref.read(sharedPrefsProvider).setCompletedOnboarding(true);
    if (mounted) context.go(RoutePaths.login);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pages = [
      (Icons.visibility_rounded, l.onboardingTitle1, l.onboardingBody1),
      (Icons.verified_user_rounded, l.onboardingTitle2, l.onboardingBody2),
      (Icons.notifications_active_rounded, l.onboardingTitle3, l.onboardingBody3),
    ];
    final last = _index == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _finish, child: Text(l.start))),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    padding: const EdgeInsets.all(36),
                    decoration: BoxDecoration(color: AppColors.aframPrimary.withValues(alpha: 0.08), shape: BoxShape.circle),
                    child: Icon(pages[i].$1, size: 72, color: AppColors.aframPrimary),
                  ),
                  const SizedBox(height: 40),
                  Text(pages[i].$2, textAlign: TextAlign.center, style: AppTextStyles.h2),
                  const SizedBox(height: 14),
                  Text(pages[i].$3, textAlign: TextAlign.center, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondaryLight)),
                ]),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.all(4),
                width: i == _index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(color: i == _index ? AppColors.aframPrimary : AppColors.borderLight, borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: last ? _finish : () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
              child: Text(last ? l.start : l.next),
            ),
          ),
        ]),
      ),
    );
  }
}
