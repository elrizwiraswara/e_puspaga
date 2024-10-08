import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/locale/app_locale.dart';
import '../../app/widgets/app_dialog.dart';
import '../app/services/firebase/auth/auth_service.dart';
import '../app/services/firebase/firestore/firestore_service.dart';
import '../app/services/locator/locator.dart';
import '../app/utilities/console_log.dart';
import '../model/user/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  final _firestoreService = locator<FirestoreService>();

  late String phoneNumber;

  Timer? _timer;
  int resendOtpTime = 60;

  void onChangeField(String text) {
    if (text.isNotEmpty) {
      notifyListeners();
    }
  }

  bool enableButton(String text, int minLength) {
    if (text.isNotEmpty && text.length >= minLength) {
      return true;
    } else {
      return false;
    }
  }

  Future onTapSignInButton(NavigatorState navigator, String phone) async {
    AppDialog.showDialogProgress();

    phoneNumber = AppLocale.defaultPhoneCode + phone;

    // Check is user has been added into firestore
    UserModel? userData =
        await _firestoreService.getUser(phoneNumber).catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
      return null;
    });

    if (userData != null) {
      navigator.pushReplacementNamed('/otp-verif');

      startOtpTimer();

      await _authService.registerUser(navigator, phoneNumber);
    } else {
      AppDialog.closeDialogProgress();
      AppDialog.showDialog(
        title: 'Nomor Belum Terdaftar',
        text:
            'Nomor yang anda masukkan belum terdaftar. Silahkan mendaftar terlebih dahulu',
      );
    }
  }

  Future onTapSignUpButton(NavigatorState navigator, String phone) async {
    AppDialog.showDialogProgress();

    phoneNumber = AppLocale.defaultPhoneCode + phone;

    // Check is user has been added into firestore
    UserModel? userData =
        await _firestoreService.getUser(phoneNumber).catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
      return null;
    });

    if (userData == null) {
      navigator.pushReplacementNamed('/otp-verif');

      startOtpTimer();

      await _authService.registerUser(navigator, phoneNumber);
    } else {
      AppDialog.closeDialogProgress();
      AppDialog.showDialog(
        title: 'Nomor Sudah Terdaftar',
        text:
            'Nomor yang anda masukkan sudah terdaftar. Silahkan masuk menggunakan nomor tersebut',
      );
    }
  }

  void resendOtp(
    NavigatorState navigator,
  ) async {
    AppDialog.showDialogProgress();

    await _authService.registerUser(navigator, phoneNumber);

    startOtpTimer();
  }

  void submitOtp(NavigatorState navigator, String otp) async {
    if (_authService.verifId == null) {
      AppDialog.showDialog(
        title: 'Belum Sign In',
        text: 'Silahkan melakukan sign in terlebih dahulu',
        onTapRightButton: () {
          navigator.pushNamedAndRemoveUntil('/welcome', (route) => false);
        },
      );
      return;
    }

    try {
      AppDialog.showDialogProgress();

      final authCredential = await _authService.submitOtp(
        otp,
        _authService.verifId!,
      );

      if (authCredential != null) {
        await _authService.signIn(authCredential);

        AppDialog.closeDialogProgress();
        navigator.pushNamedAndRemoveUntil('/main', (route) => false);
      } else {
        AppDialog.closeDialogProgress();
        AppDialog.showDialog(
          title: 'Gagal',
          text: 'Kode OTP yang Anda masukkan salah',
        );
      }
    } catch (e) {
      consoleLog(e.toString());
      AppDialog.closeDialogProgress();
      AppDialog.showErrorDialog(
        error: e.toString(),
      );
    }
  }

  void startOtpTimer() {
    resetOtpTimer();

    consoleLog('startOTPTImer');
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        consoleLog('startOTPTImer ${timer.tick}');
        if (resendOtpTime == 0) {
          timer.cancel();
        } else {
          resendOtpTime--;
          notifyListeners();
        }
      },
    );
  }

  void resetOtpTimer() {
    _timer?.cancel();
    _timer = null;
    resendOtpTime = 60;
  }
}
