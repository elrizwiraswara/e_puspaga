import 'package:app_image/app_image.dart';
import 'package:flutter/material.dart';

import '../themes/app_assets.dart';
import '../themes/app_text_style.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 50,
          child: AppImage(
            image: AppAssets.logo,
            imgProvider: ImgProvider.assetImage,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'E-Konseling Puspaga Dumai',
                style: AppTextStyle.bold(
                  size: 22,
                ),
              ),
              Text(
                'Tempat belajar orang tua menuju keluarga setara dan sesuai hak anak',
                style: AppTextStyle.medium(
                  size: 12,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
