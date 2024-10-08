import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utilities/console_log.dart';
import '../../../widgets/app_dialog.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? verifId;

  Future registerUser(NavigatorState navigator, String phone) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential authCredential) async {
        await signIn(authCredential);
        navigator.pushNamedAndRemoveUntil('/main', (route) => false);
      },
      verificationFailed: (authException) {
        AppDialog.showErrorDialog(error: authException.message);
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        verifId = verificationId;
        AppDialog.closeDialogProgress();
        consoleLog(verifId, title: 'Verification ID');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        consoleLog("code Auto Retrieval Timeout");
      },
    );
  }

  Future<AuthCredential?> submitOtp(String otpCode, String verifId) async {
    return PhoneAuthProvider.credential(
      verificationId: verifId,
      smsCode: otpCode,
    );
  }

  Future<User?> signIn(AuthCredential authCredential) async {
    return (await auth.signInWithCredential(authCredential)).user;
  }

  void checkIsSignedIn(NavigatorState navigator) {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        consoleLog('User Signed In (${user.phoneNumber})');

        navigator.pushNamedAndRemoveUntil('/main', (route) => false);
      } else {
        consoleLog('User Not Signed In');

        navigator.pushNamedAndRemoveUntil('/welcome', (route) => false);
      }
    });
  }

  Future signOut(NavigatorState navigator) async {
    await auth.signOut();
    await auth.currentUser?.delete();
    verifId = null;

    consoleLog('User signed out');
  }
}
