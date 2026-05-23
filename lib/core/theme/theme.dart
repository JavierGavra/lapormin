import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0839A4),
      surfaceTint: Color(0xff0839A4),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffDFEAFD),
      onPrimaryContainer: Color(0xff041A4C),
      secondary: Color(0xff1F4074),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffD7E3FF),
      onSecondaryContainer: Color(0xff001B3E),
      tertiary: Color(0xffEC255A),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffF9BBCC),
      onTertiaryContainer: Color(0xff631026),
      error: Color(0xffB52600),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffFFDAD2),
      onErrorContainer: Color(0xff3D0700),
      surface: Color(0xffFAF8FF),
      onSurface: Color(0xff1A1B21),
      onSurfaceVariant: Color(0xff4F4644),
      outline: Color(0xff79716F),
      outlineVariant: Color(0xffC9C1BE),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      // inverseSurface: Color(0xff2b3133),
      // inversePrimary: Color(0xff82d3e1),
      surfaceDim: Color(0xffDBD6D5),
      surfaceBright: Color(0xffFFFCFB),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffF4F3FA),
      surfaceContainer: Color(0xffEEEDF4),
      surfaceContainerHigh: Color(0xffE9E7EF),
      surfaceContainerHighest: Color(0xffE3E1E9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    fontFamily: "DM Sans",
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );
}

extension SuccessColorScheme on ColorScheme {
  Color get success => Color(0xFF4BC57C);
  Color get onSuccess => Color(0xFFFFFFFF);
  Color get successContainer => Color(0xFFC7EDD6);
  Color get onSuccessContainer => Color(0xFF205334);
}

extension WarningColorScheme on ColorScheme {
  Color get warning => Color(0xFFEE9F0A);
  Color get onWarning => Color(0xFF000000);
  Color get warningContainer => Color(0xFFFFDDB4);
  Color get onWarningContainer => Color(0xFF633F00);
}
