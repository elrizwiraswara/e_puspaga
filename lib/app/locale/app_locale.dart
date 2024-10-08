import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocale {
  AppLocale._();

  static Locale defaultLocale = const Locale('id', 'ID');
  static String defaultPhoneCode = '+62';

  static const List<Locale> supportedLocales = [
    Locale('id', 'ID'),
    Locale('en', 'EN'),
  ];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}
