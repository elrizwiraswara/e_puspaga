import 'package:app_image/app_image.dart';
import 'package:flutter/material.dart';

import '../../app/themes/app_assets.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  static const String routeName = '/';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
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
