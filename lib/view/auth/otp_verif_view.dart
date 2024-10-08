import 'package:app_image/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../app/const/app_const.dart';
import '../../app/services/locator/locator.dart';
import '../../app/themes/app_assets.dart';
import '../../app/themes/app_colors.dart';
import '../../app/themes/app_text_style.dart';
import '../../app/widgets/app_filled_button.dart';
import '../../app/widgets/app_logo.dart';
import '../../app/widgets/app_text_field.dart';
import '../../view_model/auth_view_model.dart';

class OtpVerifView extends StatefulWidget {
  const OtpVerifView({super.key});

  static const String routeName = '/otp-verif';

  @override
  State<OtpVerifView> createState() => _OtpVerifViewState();
}

class _OtpVerifViewState extends State<OtpVerifView> {
  final _signIn = locator<AuthViewModel>();
  final TextEditingController _otpController = TextEditingController();

  late NavigatorState _navigator;

  @override
  void initState() {
    _navigator = Navigator.of(context);
    _signIn.startOtpTimer();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _signIn.resetOtpTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: screenSize.height,
        child: Stack(
          alignment: Alignment.center,
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
            SingleChildScrollView(
              child: verifForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget verifForm() {
    return Consumer<AuthViewModel>(builder: (context, model, _) {
      return Container(
        width: 500,
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
            const AppLogo(),
            const SizedBox(height: 32),
            Text(
              'Verifikasi',
              style: AppTextStyle.bold(
                size: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masukkan kode OTP yang telah dikirimkan ke nomor tersebut',
              style: AppTextStyle.medium(
                size: 12,
              ),
            ),
            const SizedBox(height: 46),
            AppTextField(
              controller: _otpController,
              labelText: 'Kode OTP',
              hintText: 'Masukkan kode OTP',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.phone,
              maxLength: 6,
              onChanged: model.onChangeField,
            ),
            const SizedBox(height: 32),
            AppFilledButton(
              enable: model.enableButton(_otpController.text, 6),
              text: 'Verifikasi',
              onTap: () {
                FocusScope.of(context).unfocus();
                model.submitOtp(_navigator, _otpController.text);
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tidak mendapatkan kode? ',
                  style: AppTextStyle.regular(
                    size: 12,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (model.resendOtpTime == 0) {
                      model.resendOtp(_navigator);
                    }
                  },
                  child: Text(
                    "Kirim Ulang ${model.resendOtpTime > 0 ? '(${model.resendOtpTime})' : ''}",
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
      );
    });
  }
}
