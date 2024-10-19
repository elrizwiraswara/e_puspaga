import 'package:app_image/app_image.dart';
import 'package:flutter/material.dart';

import '../../app/services/firebase/auth/auth_service.dart';
import '../../app/services/locator/locator.dart';
import '../../app/themes/app_assets.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  static const String routeName = '/';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = Navigator.of(context);
      final auth = locator<AuthService>();
      auth.checkIsSignedIn(navigator);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 192,
          child: AppImage(
            image: AppAssets.logo,
            imgProvider: ImgProvider.assetImage,
          ),
        ),
      ),
    );
  }
}
