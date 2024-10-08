import 'package:app_image/app_image.dart';
import 'package:flutter/material.dart';

import '../../app/const/app_const.dart';
import '../../app/themes/app_assets.dart';
import '../../app/themes/app_colors.dart';
import '../../app/themes/app_text_style.dart';
import '../../app/widgets/app_filled_button.dart';
import '../auth/auth_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  static const String routeName = '/welcome';

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            welcome(),
            features(),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget welcome() {
    return SizedBox(
      width: double.infinity,
      height:
          screenSize.width > 678 ? screenSize.height : screenSize.height / 1.4,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: screenSize.width > 678
                  ? screenSize.width / 2
                  : screenSize.width / 1.5,
              child: const AppImage(
                image: AppAssets.welcomeBg,
                imgProvider: ImgProvider.assetImage,
              ),
            ),
          ),
          Container(
            // width: screenSize.width / 2,
            padding: EdgeInsets.symmetric(horizontal: screenSize.width / 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenSize.width > 678 ? 192 : 100,
                  child: const AppImage(
                    image: AppAssets.logo,
                    imgProvider: ImgProvider.assetImage,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selamat Datang di Aplikasi',
                  style: AppTextStyle.medium(
                    size: screenSize.width > 678 ? 32 : 24,
                  ),
                ),
                Text(
                  'E-Konseling Puspaga Dumai',
                  style: AppTextStyle.bold(
                    size: screenSize.width > 678 ? 38 : 30,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tempat belajar orang tua menuju keluarga setara dan sesuai hak anak',
                  style: AppTextStyle.medium(
                    size: screenSize.width > 678 ? 20 : 14,
                  ),
                ),
                const SizedBox(height: 32),
                AppFilledButton(
                  width: 165,
                  text: 'Login',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AuthView.routeName,
                      arguments: true,
                    );
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: AppTextStyle.regular(
                        size: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AuthView.routeName,
                          arguments: false,
                        );
                      },
                      child: Text(
                        'Daftar Sekarang',
                        style: AppTextStyle.semibold(
                          size: 12,
                          color: AppColors.tangerineLv1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget features() {
    return Container(
      padding: EdgeInsets.all(screenSize.width / 16),
      decoration: const BoxDecoration(
        color: AppColors.blackLv6,
      ),
      child: SizedBox(
        width: double.infinity,
        height: screenSize.width > 678 ? 600 : 1200,
        child: screenSize.width > 678
            ? Row(
                children: [
                  feature1(),
                  SizedBox(width: screenSize.width / 20),
                  feature2(),
                ],
              )
            : Column(
                children: [
                  feature1(),
                  SizedBox(height: screenSize.width / 20),
                  feature2(),
                ],
              ),
      ),
    );
  }

  Widget feature1() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(37),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const AppImage(
                image: AppAssets.features1,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'INGIN KONSELING SECARA ONLINE?',
              style: AppTextStyle.bold(
                size: 22,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'PUSPAGA Kota Dumai menyediakan fitur layanan konseling keluarga berbasis digital yang memungkinkan klien untuk konseling kapan pun dan di mana pun',
              style: AppTextStyle.medium(
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget feature2() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(37),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const AppImage(
                image: AppAssets.features2,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'INGIN KONSELING SECARA LANGSUNG?',
              style: AppTextStyle.bold(
                size: 22,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Melalui aplikasi PUSPAGA Kota Dumai, anda dapat membuat jadwal konseling, dan menemui konselor secara langsung pada jadwal yang telah ditentukan',
              style: AppTextStyle.medium(
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget footer() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Text(
        'E-Konseling Puspaga Kota Dumai',
        style: AppTextStyle.semibold(
          size: 16,
        ),
      ),
    );
  }
}
