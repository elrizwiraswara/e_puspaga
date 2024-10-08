import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../app/services/locator/locator.dart';
import 'profile_view_model.dart';

class MainViewModel extends ChangeNotifier {
  final _profileViewModel = locator<ProfileViewModel>();

  String? appVersion;

  bool isLoaded = false;

  Future initMainView(NavigatorState navigator) async {
    await _profileViewModel.checkAndGetUserData(navigator);
    getAppVersion();

    isLoaded = true;
    notifyListeners();
  }

  Future getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion = info.version;
  }
}
