import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Main App Color
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  // White
  static const Color white = Color(0xFFFFFFFF);

  // Black
  static const Color blackLv1 = Color(0xFF303030);
  static const Color blackLv2 = Color(0xFFA1A1A1);
  static const Color blackLv3 = Color(0xFFDFDFDF);
  static const Color blackLv4 = Color(0xFFEEEEEE);
  static const Color blackLv5 = Color(0xFFF6F6F6);
  static const Color blackLv6 = Color(0xFFFBFBFB);

  // Tangerine
  static const Color tangerineLv1 = Color(0xFFFF9900);
  static const Color tangerineLv2 = Color(0xFFFFAE34);
  static const Color tangerineLv3 = Color(0xFFFFD18B);
  static const Color tangerineLv4 = Color(0xFFFFD18B);
  static const Color tangerineLv5 = Color(0xFFFFEED6);
  static const Color tangerineLv6 = Color(0xFFFFF2E0);

  // Orange
  static const Color orangeLv1 = Color(0xFFFF9957);
  static const Color orangeLv2 = Color(0xFFFFAE34);
  static const Color orangeLv3 = Color(0xFFFFD18B);
  static const Color orangeLv4 = Color(0xFFFFD18B);
  static const Color orangeLv5 = Color(0xFFFFEED6);
  static const Color orangeLv6 = Color(0xFFFFF2E0);

  // Green
  static const Color greenLv1 = Color(0xFF40C016);
  static const Color greenLv2 = Color(0xFF5FD638);
  static const Color greenLv3 = Color(0xFF7EE55C);
  static const Color greenLv4 = Color(0xFFA1F585);
  static const Color greenLv5 = Color(0xFFE0F5DA);
  static const Color greenLv6 = Color(0xFFE8F7E3);

  // Red
  static const Color redLv1 = Color(0xFFF95B5B);
  static const Color redLv2 = Color(0xFFF57373);
  static const Color redLv3 = Color(0xFFF59090);
  static const Color redLv4 = Color(0xFFF4A9A9);
  static const Color redLv5 = Color(0xFFFEE5E5);
  static const Color redLv6 = Color(0xFFFEEBEB);
}
