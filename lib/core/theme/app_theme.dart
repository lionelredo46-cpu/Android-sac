import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_text_styles.dart';
import 'strato.dart';

/// Thèmes Material 3 construits sur les jetons « Stratosphère ».
///
/// Les pages sont transparentes : le ciel animé (StratoBackground) est peint une
/// seule fois derrière le navigateur, les surfaces sont du verre translucide.
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => _build(Strato.night);
  static ThemeData get lightTheme => _build(Strato.dawn);

  /// Barres système transparentes (le ciel passe dessous), icônes contrastées, sans voile ajouté par Android.
  static SystemUiOverlayStyle overlayStyle(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      statusBarBrightness: brightness,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarContrastEnforced: false,
    );
  }

  static ThemeData _build(Strato s) {
    final dark = s.isDark;
    final scheme = ColorScheme(
      brightness: s.brightness,
      primary: s.accent,
      onPrimary: Colors.white,
      primaryContainer: s.accent.withValues(alpha: 0.18),
      onPrimaryContainer: s.text,
      secondary: s.gold,
      onSecondary: s.onGold,
      secondaryContainer: s.gold.withValues(alpha: 0.18),
      onSecondaryContainer: s.text,
      tertiary: const Color(0xFF8B7BFF),
      onTertiary: Colors.white,
      error: s.danger,
      onError: Colors.white,
      surface: s.elevated,
      onSurface: s.text,
      onSurfaceVariant: s.textMuted,
      surfaceContainerLowest: s.base,
      surfaceContainerLow: s.elevated,
      surfaceContainer: s.elevated,
      surfaceContainerHigh: Color.alphaBlend(s.glass, s.elevated),
      surfaceContainerHighest: Color.alphaBlend(s.glassStrong, s.elevated),
      outline: s.hairlineStrong,
      outlineVariant: s.hairline,
      shadow: s.shadow,
      scrim: Colors.black,
      inverseSurface: s.text,
      onInverseSurface: s.base,
      inversePrimary: s.accentDeep,
      surfaceTint: Colors.transparent,
    );

    final base = ThemeData(useMaterial3: true, brightness: s.brightness, colorScheme: scheme, fontFamily: AppTextStyles.inter);
    final body = base.textTheme.apply(fontFamily: 'Inter');
    final textTheme = body
        .copyWith(
          displayLarge: AppTextStyles.display.copyWith(fontSize: 52),
          displayMedium: AppTextStyles.display,
          displaySmall: AppTextStyles.h1.copyWith(fontSize: 34),
          headlineLarge: AppTextStyles.h1,
          headlineMedium: AppTextStyles.h2,
          headlineSmall: AppTextStyles.h2.copyWith(fontSize: 20),
          titleLarge: AppTextStyles.h3.copyWith(fontSize: 20),
          titleMedium: AppTextStyles.h3.copyWith(fontSize: 16),
          titleSmall: AppTextStyles.h3.copyWith(fontSize: 14),
          labelLarge: AppTextStyles.button.copyWith(fontSize: 14.5),
        )
        .apply(bodyColor: s.text, displayColor: s.text);

    final radius16 = BorderRadius.circular(16);
    final radius18 = BorderRadius.circular(18);
    OutlineInputBorder field(Color c, [double w = 1]) => OutlineInputBorder(borderRadius: radius18, borderSide: BorderSide(color: c, width: w));
    final fieldFill = dark ? const Color(0x14FFFFFF) : const Color(0xD9FFFFFF);

    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: s.elevated,
      cardColor: s.glass,
      dividerColor: s.hairline,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: IconThemeData(color: s.text, size: 22),
      highlightColor: s.accent.withValues(alpha: 0.06),
      splashColor: s.accent.withValues(alpha: 0.10),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: StratoPageTransitionsBuilder(),
        TargetPlatform.iOS: StratoPageTransitionsBuilder(),
        TargetPlatform.macOS: StratoPageTransitionsBuilder(),
        TargetPlatform.windows: StratoPageTransitionsBuilder(),
        TargetPlatform.linux: StratoPageTransitionsBuilder(),
      }),
      extensions: [s],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: s.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        toolbarHeight: 64,
        titleTextStyle: AppTextStyles.h2.copyWith(color: s.text, fontSize: 24),
        iconTheme: IconThemeData(color: s.text),
        actionsIconTheme: IconThemeData(color: s.text),
        systemOverlayStyle: overlayStyle(s.brightness),
      ),
      cardTheme: CardThemeData(
        color: s.glass,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: BorderSide(color: s.hairline)),
        margin: EdgeInsets.zero,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: s.textMuted,
        textColor: s.text,
        titleTextStyle: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w600),
        subtitleTextStyle: AppTextStyles.bodySmall.copyWith(color: s.textMuted),
        leadingAndTrailingTextStyle: AppTextStyles.bodySmall.copyWith(color: s.textMuted),
        shape: RoundedRectangleBorder(borderRadius: radius18),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
        minVerticalPadding: 10,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: s.gold,
          foregroundColor: s.onGold,
          disabledBackgroundColor: s.glassStrong,
          disabledForegroundColor: s.textFaint,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: radius18),
          textStyle: AppTextStyles.button,
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        // Action principale des dialogues et cartes : or impérial, comme les grands boutons.
        style: FilledButton.styleFrom(
          backgroundColor: s.gold,
          foregroundColor: s.onGold,
          disabledBackgroundColor: s.glassStrong,
          disabledForegroundColor: s.textFaint,
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: radius16),
          textStyle: AppTextStyles.button.copyWith(fontSize: 14.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: s.text,
          backgroundColor: s.glass,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: s.hairlineStrong),
          shape: RoundedRectangleBorder(borderRadius: radius18),
          textStyle: AppTextStyles.button.copyWith(fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: s.accent,
          textStyle: AppTextStyles.button.copyWith(fontSize: 14.5),
          shape: RoundedRectangleBorder(borderRadius: radius16),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(foregroundColor: s.text)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: s.gold,
        foregroundColor: s.onGold,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        extendedTextStyle: AppTextStyles.button.copyWith(fontSize: 15),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        border: field(s.hairline),
        enabledBorder: field(s.hairline),
        disabledBorder: field(s.hairline.withValues(alpha: 0.4)),
        focusedBorder: field(s.gold, 1.6),
        errorBorder: field(s.danger.withValues(alpha: 0.8)),
        focusedErrorBorder: field(s.danger, 1.6),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: s.textMuted),
        floatingLabelStyle: AppTextStyles.bodyMedium.copyWith(color: s.gold, fontWeight: FontWeight.w600),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: s.textFaint),
        helperStyle: AppTextStyles.bodySmall.copyWith(color: s.textFaint),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: s.danger),
        prefixIconColor: WidgetStateColor.resolveWith((st) => st.contains(WidgetState.focused) ? s.gold : s.textMuted),
        suffixIconColor: s.textMuted,
        suffixStyle: AppTextStyles.bodyMedium.copyWith(color: s.textMuted),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith((st) => st.contains(WidgetState.selected) ? s.accent.withValues(alpha: dark ? 0.22 : 0.14) : s.glass),
          foregroundColor: WidgetStateColor.resolveWith((st) => st.contains(WidgetState.selected) ? s.text : s.textMuted),
          iconColor: WidgetStateColor.resolveWith((st) => st.contains(WidgetState.selected) ? s.gold : s.textMuted),
          side: WidgetStatePropertyAll(BorderSide(color: s.hairline)),
          textStyle: WidgetStatePropertyAll(AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: radius16)),
          minimumSize: const WidgetStatePropertyAll(Size(0, 46)),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: s.onGold,
        unselectedLabelColor: s.textMuted,
        labelStyle: AppTextStyles.button.copyWith(fontSize: 14),
        unselectedLabelStyle: AppTextStyles.button.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        dividerHeight: 0,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        indicator: BoxDecoration(
          gradient: Strato.goldGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: s.gold.withValues(alpha: dark ? 0.35 : 0.25), blurRadius: 16, offset: const Offset(0, 4))],
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: s.glass,
        selectedColor: s.accent.withValues(alpha: dark ? 0.26 : 0.16),
        disabledColor: s.glass,
        checkmarkColor: s.gold,
        deleteIconColor: s.textMuted,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: s.text, fontWeight: FontWeight.w600),
        secondaryLabelStyle: AppTextStyles.bodySmall.copyWith(color: s.text, fontWeight: FontWeight.w700),
        side: BorderSide(color: s.hairline),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        showCheckmark: false,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: s.elevated,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28), side: BorderSide(color: s.hairline)),
        titleTextStyle: AppTextStyles.h3.copyWith(color: s.text, fontSize: 19),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: s.textMuted),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: s.elevated,
        modalBackgroundColor: s.elevated,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        dragHandleColor: s.hairlineStrong,
        dragHandleSize: const Size(44, 5),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          side: BorderSide(color: s.hairline),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark ? const Color(0xFF123472) : const Color(0xFF0B1533),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        actionTextColor: s.gold,
        elevation: 0,
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: radius18),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: s.elevated,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shadowColor: s.shadow,
        shape: RoundedRectangleBorder(borderRadius: radius16, side: BorderSide(color: s.hairline)),
        textStyle: AppTextStyles.bodyMedium.copyWith(color: s.text),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(s.elevated),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: radius16, side: BorderSide(color: s.hairline))),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        iconColor: s.gold,
        collapsedIconColor: s.textMuted,
        textColor: s.text,
        collapsedTextColor: s.text,
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: s.gold,
        linearTrackColor: s.hairline,
        circularTrackColor: Colors.transparent,
        refreshBackgroundColor: s.elevated,
      ),
      dividerTheme: DividerThemeData(color: s.hairline, thickness: 1, space: 24),
      badgeTheme: BadgeThemeData(
        backgroundColor: s.danger,
        textColor: Colors.white,
        textStyle: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateColor.resolveWith((st) => st.contains(WidgetState.selected) ? s.onGold : s.textMuted),
        trackColor: WidgetStateColor.resolveWith((st) => st.contains(WidgetState.selected) ? s.gold : s.glassStrong),
        trackOutlineColor: WidgetStateColor.resolveWith((st) => st.contains(WidgetState.selected) ? Colors.transparent : s.hairlineStrong),
      ),
      radioTheme: RadioThemeData(fillColor: WidgetStateColor.resolveWith((st) => st.contains(WidgetState.selected) ? s.gold : s.textMuted)),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((st) => st.contains(WidgetState.selected) ? s.gold : Colors.transparent),
        checkColor: WidgetStatePropertyAll(s.onGold),
        side: BorderSide(color: s.hairlineStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: dark ? const Color(0xFF15397D) : const Color(0xFF0B1533), borderRadius: BorderRadius.circular(10)),
        textStyle: AppTextStyles.bodySmall.copyWith(color: Colors.white),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: s.elevated,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: s.accentDeep,
        headerForegroundColor: Colors.white,
        todayBorder: BorderSide(color: s.gold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: s.elevated,
        dialHandColor: s.gold,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: s.elevated, surfaceTintColor: Colors.transparent),
    );
  }
}

/// Transition « fondu traversant » : l'écran sortant s'efface et recule pendant
/// que l'entrant monte légèrement. Indispensable avec des pages transparentes
/// (le ciel est commun), où un glissement superposerait les deux contenus.
class StratoPageTransitionsBuilder extends PageTransitionsBuilder {
  const StratoPageTransitionsBuilder();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 460);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 340);

  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;
    final enter = CurvedAnimation(parent: animation, curve: const Interval(0.25, 1, curve: Curves.easeOutCubic), reverseCurve: const Interval(0.3, 1, curve: Curves.easeInCubic));
    final exit = CurvedAnimation(parent: secondaryAnimation, curve: const Interval(0, 0.55, curve: Curves.easeOut), reverseCurve: const Interval(0.45, 1, curve: Curves.easeIn));
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0).animate(exit),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 0.96).animate(exit),
        child: FadeTransition(
          opacity: enter,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.035), end: Offset.zero).animate(enter),
            child: ScaleTransition(scale: Tween<double>(begin: 1.02, end: 1).animate(enter), child: child),
          ),
        ),
      ),
    );
  }
}
