import 'package:flutter/material.dart';

import '../app/services/firebase/firestore/firestore_service.dart';
import '../app/services/locator/locator.dart';
import '../app/utilities/console_log.dart';
import '../app/widgets/app_dialog.dart';
import '../model/schedule/schedule_model.dart';
import 'profile_view_model.dart';

class HomeConselorViewModel extends ChangeNotifier {
  final _firestoreService = locator<FirestoreService>();
  final _profileViewModel = locator<ProfileViewModel>();

  ScheduleModel? nearestSchedule;
  List<ScheduleModel>? incomingSchedules = [];
  List<ScheduleModel>? scheduleHistory = [];

  Future init() async {
    scheduleListener();
  }

  void scheduleListener() {
    _firestoreService.scheduleListener((event) {
      getIncomingSchedules();
      getScheduleHistory();
    });
  }

  Future<void> getIncomingSchedules() async {
    incomingSchedules = await _firestoreService.getIncomingSchedules(
      _profileViewModel.user.id!,
    );

    if (incomingSchedules == null || incomingSchedules!.isEmpty) {
      incomingSchedules = [];
      nearestSchedule = null;
      notifyListeners();
      return;
    }

    incomingSchedules?.sort(
      (a, b) => a.dateTime!.compareTo(b.dateTime!),
    );

    nearestSchedule = incomingSchedules?.first;
    incomingSchedules?.removeAt(0);
    consoleLog(nearestSchedule?.toJson());

    notifyListeners();
  }

  Future<void> getScheduleHistory() async {
    scheduleHistory = await _firestoreService.getConselorScheduleHistory(
      _profileViewModel.user.id!,
    );

    if (scheduleHistory == null || scheduleHistory!.isEmpty) {
      scheduleHistory = [];
      notifyListeners();
      return;
    }

    scheduleHistory?.sort(
      (a, b) => a.dateTime!.compareTo(b.dateTime!),
    );

    notifyListeners();
  }

  Future<void> closeConselingSession() async {
    if (nearestSchedule == null) {
      return;
    }

    AppDialog.showDialogProgress();

    nearestSchedule!.status = 3;

    await _firestoreService
        .createOrUpdateSchedule(nearestSchedule!)
        .catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
    });

    nearestSchedule = null;
    getIncomingSchedules();
    getScheduleHistory();
    notifyListeners();

    AppDialog.closeDialogProgress();
  }
}
