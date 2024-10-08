import 'package:app_image/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../app/const/app_const.dart';
import '../../app/themes/app_assets.dart';
import '../../app/themes/app_colors.dart';
import '../../app/themes/app_text_style.dart';
import '../../app/widgets/app_filled_button.dart';
import '../../app/widgets/app_logo.dart';
import '../../app/widgets/app_text_field.dart';
import '../../view_model/auth_view_model.dart';

class AuthView extends StatefulWidget {
  final bool isSignIn;

  const AuthView({super.key, required this.isSignIn});

  static const String routeName = '/auth';

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
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
              child: signInForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget signInForm() {
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
              widget.isSignIn ? 'Masuk' : 'Daftar',
              style: AppTextStyle.bold(
                size: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Silahkan ${widget.isSignIn ? 'masuk' : 'mendaftar'} dengan nomor handphone Anda',
              style: AppTextStyle.medium(
                size: 12,
              ),
            ),
            const SizedBox(height: 46),
            AppTextField(
              controller: _phoneController,
              onChanged: model.onChangeField,
              labelText: 'Nomor Handphone',
              hintText: 'Masukkan nomor handphone',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.phone,
              maxLength: 12,
              prefixIcon: SizedBox(
                width: 50,
                child: Center(
                  child: Text(
                    '+62',
                    style: AppTextStyle.bold(
                      size: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            AppFilledButton(
              enable: model.enableButton(_phoneController.text, 6),
              onTap: () async {
                FocusScope.of(context).unfocus();

                final navigator = Navigator.of(context);

                if (widget.isSignIn) {
                  model.onTapSignInButton(navigator, _phoneController.text);
                } else {
                  model.onTapSignUpButton(navigator, _phoneController.text);
                }
              },
              text: widget.isSignIn ? 'Masuk' : 'Daftar',
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isSignIn ? 'Belum punya akun? ' : 'Sudah punya akun? ',
                  style: AppTextStyle.regular(
                    size: 12,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AuthView.routeName,
                      arguments: !widget.isSignIn,
                    );
                  },
                  child: Text(
                    widget.isSignIn ? 'Daftar Sekarang' : 'Masuk',
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
