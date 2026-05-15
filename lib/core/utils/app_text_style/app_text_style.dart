import 'dart:ui';
import 'package:flutter/painting.dart';

/// Helper class untuk TextStyle yang otomatis menyetel [fontSize] dan [height]
/// sesuai design system Figma.
///
/// Mapping fontSize → lineHeight:
/// ```
/// 12 → 16  |  13 → 16  |  14 → 20  |  15 → 20
/// 16 → 24  |  22 → 28  |  24 → 32
/// ```
///
/// Cara pakai:
/// ```dart
/// // Tanpa atribut tambahan
/// Text('Hello', style: AppTextStyle.s14())
///
/// // Dengan atribut tambahan (fontSize & height tetap otomatis)
/// Text('Hello', style: AppTextStyle.s14(
///   color: Colors.red,
///   fontWeight: FontWeight.bold,
/// ))
/// ```
abstract final class AppTextStyle {
  static TextStyle s12({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    Color? backgroundColor,
    String? fontFamily,
    TextOverflow? overflow,
    bool inherit = true,
  }) => _build(
    fontSize: 12,
    lineHeight: 16,
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    backgroundColor: backgroundColor,
    fontFamily: fontFamily,
    overflow: overflow,
    inherit: inherit,
  );

  static TextStyle s13({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    Color? backgroundColor,
    String? fontFamily,
    TextOverflow? overflow,
    bool inherit = true,
  }) => _build(
    fontSize: 13,
    lineHeight: 16,
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    backgroundColor: backgroundColor,
    fontFamily: fontFamily,
    overflow: overflow,
    inherit: inherit,
  );

  static TextStyle s14({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    Color? backgroundColor,
    String? fontFamily,
    TextOverflow? overflow,
    bool inherit = true,
  }) => _build(
    fontSize: 14,
    lineHeight: 20,
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    backgroundColor: backgroundColor,
    fontFamily: fontFamily,
    overflow: overflow,
    inherit: inherit,
  );

  static TextStyle s15({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    Color? backgroundColor,
    String? fontFamily,
    TextOverflow? overflow,
    bool inherit = true,
  }) => _build(
    fontSize: 15,
    lineHeight: 20,
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    backgroundColor: backgroundColor,
    fontFamily: fontFamily,
    overflow: overflow,
    inherit: inherit,
  );

  static TextStyle s16({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    Color? backgroundColor,
    String? fontFamily,
    TextOverflow? overflow,
    bool inherit = true,
  }) => _build(
    fontSize: 16,
    lineHeight: 24,
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    backgroundColor: backgroundColor,
    fontFamily: fontFamily,
    overflow: overflow,
    inherit: inherit,
  );

  static TextStyle s22({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    Color? backgroundColor,
    String? fontFamily,
    TextOverflow? overflow,
    bool inherit = true,
  }) => _build(
    fontSize: 22,
    lineHeight: 28,
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    backgroundColor: backgroundColor,
    fontFamily: fontFamily,
    overflow: overflow,
    inherit: inherit,
  );

  static TextStyle s24({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    Color? backgroundColor,
    String? fontFamily,
    TextOverflow? overflow,
    bool inherit = true,
  }) => _build(
    fontSize: 24,
    lineHeight: 32,
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    backgroundColor: backgroundColor,
    fontFamily: fontFamily,
    overflow: overflow,
    inherit: inherit,
  );

  static TextStyle _build({
    required double fontSize,
    required double lineHeight,
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    Color? backgroundColor,
    String? fontFamily,
    TextOverflow? overflow,
    bool inherit = true,
  }) {
    return TextStyle(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      height: lineHeight / fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      fontFamily: fontFamily,
      overflow: overflow,
    );
  }
}
