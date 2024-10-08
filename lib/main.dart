import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/const/app_const.dart';
import 'app/locale/app_locale.dart';
import 'app/routes/app_route.dart';
import 'app/services/dialog/dialog_manager.dart';
import 'app/services/locator/locator.dart';
import 'app/themes/app_theme.dart';
import 'view/splash/splash_view.dart';
import 'view_model/auth_view_model.dart';
import 'view_model/home_admin_view_model.dart';
import 'view_model/home_client_view_model.dart';
import 'view_model/home_conselor_view_model.dart';
import 'view_model/main_view_model.dart';
import 'view_model/profile_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

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
      providers: [
        ChangeNotifierProvider(create: (_) => locator<MainViewModel>()),
        ChangeNotifierProvider(create: (_) => locator<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => locator<ProfileViewModel>()),
        ChangeNotifierProvider(create: (_) => locator<HomeClientViewModel>()),
        ChangeNotifierProvider(create: (_) => locator<HomeConselorViewModel>()),
        ChangeNotifierProvider(create: (_) => locator<HomeAdminViewModel>()),
      ],
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
