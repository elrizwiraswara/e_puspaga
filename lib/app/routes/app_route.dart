import 'package:flutter/material.dart';

import '../../view/auth/auth_view.dart';
import '../../view/auth/otp_verif_view.dart';
import '../../view/home/home_view_admin.dart';
import '../../view/home/home_view_client.dart';
import '../../view/home/home_view_conselor.dart';
import '../../view/main/main_view.dart';
import '../../view/profile/edit_profile_view.dart';
import '../../view/room/room_view.dart';
import '../../view/splash/splash_view.dart';
import '../../view/welcome/welcome_view.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashView.routeName:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case WelcomeView.routeName:
        return MaterialPageRoute(builder: (_) => const WelcomeView());
      case MainView.routeName:
        return MaterialPageRoute(builder: (_) => const MainView());
      case AuthView.routeName:
        return MaterialPageRoute(
          builder: (_) => AuthView(
            isSignIn: settings.arguments as bool,
          ),
        );
      case OtpVerifView.routeName:
        return MaterialPageRoute(builder: (_) => const OtpVerifView());
      case EditProfileView.routeName:
        return MaterialPageRoute(
          builder: (_) => EditProfileView(
            isNewUser: settings.arguments as bool,
          ),
        );
      case HomeViewClient.routeName:
        return MaterialPageRoute(builder: (_) => const HomeViewClient());
      case HomeViewConselor.routeName:
        return MaterialPageRoute(builder: (_) => const HomeViewConselor());
      case HomeViewAdmin.routeName:
        return MaterialPageRoute(builder: (_) => const HomeViewAdmin());
      case RoomView.routeName:
        return MaterialPageRoute(
          builder: (_) => RoomView(
            arguments: settings.arguments as Map,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            );
          },
        );
    }
  }
}
