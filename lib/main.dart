import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/const/app_const.dart';
import 'app/locale/app_locale.dart';
import 'app/routes/app_route.dart';
import 'app/services/dialog/dialog_manager.dart';
import 'app/themes/app_theme.dart';
import 'view/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'e-puspaga',
    options: const FirebaseOptions(
      apiKey: 'apiKey',
      appId: 'appId',
      messagingSenderId: 'messagingSenderId',
      projectId: 'projectId',
      storageBucket: "storageBucket",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: const [],
      child: MaterialApp(
        title: 'E-Puspaga Dumai',
        theme: AppTheme.appTheme(),
        initialRoute: SplashView.routeName,
        onGenerateRoute: AppRoute.generateRoute,
        locale: AppLocale.defaultLocale,
        supportedLocales: AppLocale.supportedLocales,
        localizationsDelegates: AppLocale.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        builder: (context, widget) => Navigator(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) {
              screenSize = MediaQuery.of(context).size;
              return DialogManager(child: widget!);
            },
          ),
        ),
      ),
    );
  }
}
