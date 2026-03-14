import 'package:flutter/material.dart';

extension ExtString on String? {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z\d._-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$");
    return emailRegExp.hasMatch(this ?? "");
  }

  bool get isValidName {
    final nameRegExp = RegExp(
      r"^\s*([A-Za-z]+([.,] |[-']| ))+[A-Za-z]+\.?\s*$",
    );
    return nameRegExp.hasMatch(this ?? "");
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?\d)(?=.*?[!@#\$&*~]).{8,}$',
    );
    return passwordRegExp.hasMatch(this ?? "");
  }

  bool get isNotNull {
    return this != null;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0\d{10}$");
    return phoneRegExp.hasMatch(this ?? "");
  }
}

extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but the callback has index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}

extension TypographyUtils on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colors => theme.colorScheme;

  TextStyle? get displayLarge => textTheme.displayLarge;

  TextStyle? get displayMedium => textTheme.displayMedium;

  TextStyle? get displaySmall => textTheme.displaySmall;

  TextStyle? get headlineLarge => textTheme.headlineLarge;

  TextStyle? get headlineMedium => textTheme.headlineMedium;

  TextStyle? get headlineSmall => textTheme.headlineSmall;

  TextStyle? get titleLarge => textTheme.titleLarge;

  TextStyle? get titleMedium => textTheme.titleMedium;

  TextStyle? get titleSmall => textTheme.titleSmall;

  TextStyle? get labelLarge => textTheme.labelLarge;

  TextStyle? get labelMedium => textTheme.labelMedium;

  TextStyle? get labelSmall => textTheme.labelSmall;

  TextStyle? get bodyLarge => textTheme.bodyLarge;

  TextStyle? get bodyMedium => textTheme.bodyMedium;

  TextStyle? get bodySmall => textTheme.bodySmall;

  Color get primaryColor => colors.primary;
  Color get banner => colors.surfaceDim;
  Color get primaryColorShade50 => colors.onPrimary;
  Color get secondaryColor => colors.secondary;
  Color get primaryColorShade200 => colors.onSecondary;
  Color get dangerColorShade50 => colors.error;
  Color get dangerColorShade400 => colors.onError;
  Color get titleText => colors.onSurface;
  Color get grayText => colors.onSecondaryContainer;
  Color get white => colors.surfaceContainer;
  Color get tertiaryColor => colors.onTertiaryFixedVariant;
  Color get lightScaffoldBackground => theme.scaffoldBackgroundColor;
  Color get accentColor => colors.tertiary;
  Color get accentColorShade50 => colors.onTertiary;
  Color get accentColorShade700 => colors.secondaryContainer;
  Color get successShade50 => colors.outline;
  Color get successShade600 => colors.outlineVariant;
  Color get warningShade400 => colors.onSurfaceVariant;
  Color get neutralN40 => colors.shadow;
  Color get warning => colors.onError;
  Color get neutralN400 => colors.surfaceTint;
}
