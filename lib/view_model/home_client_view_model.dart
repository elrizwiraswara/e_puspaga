import 'package:flutter/material.dart';

import '../app/const/app_const.dart';
import '../app/services/firebase/firestore/firestore_service.dart';
import '../app/services/locator/locator.dart';
import '../app/utilities/console_log.dart';
import '../app/utilities/date_formatter.dart';
import '../app/widgets/app_dialog.dart';
import '../model/schedule/schedule_model.dart';
import '../model/user/gender_model.dart';
import 'profile_view_model.dart';

class HomeClientViewModel extends ChangeNotifier {
  final _firestoreService = locator<FirestoreService>();
  final _profileViewModel = locator<ProfileViewModel>();

  ScheduleModel? currentSchedule;
  List<ScheduleModel>? scheduleHistory = [];

  List<MenuItemModel> serviceType = [];

  MenuItemModel selectedMedium = conselingMedium.first;
  MenuItemModel? selectedServiceType;
  String? selecteddateTime;

  TextEditingController conselingDateController = TextEditingController();

  void resetCreateSceduleState() {
    selectedMedium = conselingMedium.first;
    selectedServiceType = serviceType.first;
    selecteddateTime = null;
    conselingDateController.clear();
    notifyListeners();
  }

  Future init() async {
    getServiceTypes();
    scheduleListener();
  }

  void scheduleListener() {
    _firestoreService.scheduleListener((event) {
      getCurrentSchedule();
      getScheduleHistory();
    });
  }

  Future<void> getServiceTypes() async {
    serviceType = await _firestoreService.getAllServiceType();
    selectedServiceType = serviceType.first;
    notifyListeners();
  }

  Future<void> getCurrentSchedule() async {
    currentSchedule = await _firestoreService.getUserScheduleById(
      _profileViewModel.user.id!,
    );
    notifyListeners();
    consoleLog(currentSchedule?.toJson());
  }

  Future<void> getScheduleHistory() async {
    scheduleHistory = await _firestoreService.getClientScheduleHistory(
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

  Future<void> createSchedule() async {
    if (!enableCreateSchedule()) {
      return;
    }

    AppDialog.showDialogProgress();

    var schedule = ScheduleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medium: selectedMedium,
      serviceType: selectedServiceType,
      client: _profileViewModel.user,
      conselor: null,
      status: 0,
      dateTime: selecteddateTime,
      dateCreated: DateTime.now().toIso8601String(),
      roomId: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    await _firestoreService.createOrUpdateSchedule(schedule).catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
    });

    currentSchedule = schedule;
    notifyListeners();

    AppDialog.closeDialogProgress();
  }

  Future<void> cancelSchedule() async {
    if (currentSchedule == null) {
      return;
    }

    AppDialog.showDialogProgress();

    currentSchedule!.status = 4;

    await _firestoreService
        .createOrUpdateSchedule(currentSchedule!)
        .catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
    });

    currentSchedule = null;
    notifyListeners();

    AppDialog.closeDialogProgress();
  }

  void onChangedMedium(dynamic value) {
    selectedMedium = conselingMedium.firstWhere(
      (e) => e.id == value,
    );
    notifyListeners();
  }

  void onChangedServiceType(dynamic value) {
    selectedServiceType = serviceType.firstWhere(
      (e) => e.id == value,
    );
    notifyListeners();
  }

  void onTapDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (date != null) {
      final time = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        var dt = date.copyWith(
          hour: time.hour,
          minute: time.minute,
        );

        selecteddateTime = dt.toIso8601String();
        conselingDateController.text = DateFormatter.stripDateWithClock(
          dt.toIso8601String(),
        );

        notifyListeners();
      }
    }
  }

  bool enableCreateSchedule() {
    if (selectedServiceType != null && selecteddateTime != null) {
      return true;
    } else {
      return false;
    }
  }
}
