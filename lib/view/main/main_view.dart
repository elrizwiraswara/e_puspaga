import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/services/locator/locator.dart';
import '../../app/widgets/app_progress_indicator.dart';
import '../../view_model/main_view_model.dart';
import '../../view_model/profile_view_model.dart';
import '../home/home_view_admin.dart';
import '../home/home_view_client.dart';
import '../home/home_view_conselor.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  static const String routeName = '/main';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    final navigator = Navigator.of(context);
    final mainViewModel = locator<MainViewModel>();
    mainViewModel.isLoaded = false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await mainViewModel.initMainView(navigator);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MainViewModel, ProfileViewModel>(
        builder: (context, mainModel, profileModel, _) {
      if (!mainModel.isLoaded) {
        return const Scaffold(
          body: AppProgressIndicator(),
        );
      }
      return profileModel.user.role == 0
          ? const HomeViewAdmin()
          : profileModel.user.role == 1
              ? const HomeViewConselor()
              : const HomeViewClient();
    });
  }
}
