import 'package:flutter/material.dart';

import '../app/locale/app_locale.dart';
import '../app/services/firebase/firestore/firestore_service.dart';
import '../app/services/locator/locator.dart';
import '../app/widgets/app_dialog.dart';
import '../model/schedule/schedule_model.dart';
import '../model/user/gender_model.dart';
import '../model/user/user_model.dart';

class HomeAdminViewModel extends ChangeNotifier {
  final _firestoreService = locator<FirestoreService>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  List<ScheduleModel>? allSchedule = [];
  List<ScheduleModel>? waitingConfirmSchedules = [];

  List<UserModel>? allConselor = [];

  List<MenuItemModel>? allServiceType = [];

  ScheduleModel? onActionSchedule;
  UserModel? selectedConselor;

  void clearTextController() {
    phoneController.clear();
    nameController.clear();
  }

  Future init() async {
    scheduleListener();
    getAllServiceType();
    getAllConselor();
  }

  void scheduleListener() {
    _firestoreService.scheduleListener((event) {
      getAllSchedule();
    });
  }

  Future<void> getAllServiceType() async {
    allServiceType = await _firestoreService.getAllServiceType();

    if (allServiceType == null || allServiceType!.isEmpty) {
      allServiceType = [];
      notifyListeners();
      return;
    }

    notifyListeners();
  }

  Future<void> getAllSchedule() async {
    allSchedule = await _firestoreService.getAllSchedule();

    if (allSchedule == null || allSchedule!.isEmpty) {
      allSchedule = [];
      notifyListeners();
      return;
    }

    allSchedule?.sort(
      (a, b) => a.dateTime!.compareTo(b.dateTime!),
    );

    // Waiting schedule
    waitingConfirmSchedules = allSchedule?.where((e) => e.status == 0).toList();

    waitingConfirmSchedules?.sort(
      (a, b) => a.dateTime!.compareTo(b.dateTime!),
    );

    notifyListeners();
  }

  Future<void> getAllConselor() async {
    allConselor = await _firestoreService.getAllConselor();

    if (allConselor == null || allConselor!.isEmpty) {
      allConselor = [];
      notifyListeners();
      return;
    }

    // allConselor?.sort(
    //   (a, b) => a.dateCreated!.compareTo(b.dateCreated!),
    // );

    notifyListeners();
  }

  Future<void> createConselor() async {
    if (!enableCreateConselor()) {
      return;
    }

    AppDialog.showDialogProgress();

    // Check is user has been added into firestore
    UserModel? userData = await _firestoreService
        .getUser(AppLocale.defaultPhoneCode + phoneController.text)
        .catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
      return null;
    });

    if (userData == null) {
      var user = UserModel(
        id: AppLocale.defaultPhoneCode + phoneController.text,
        phone: AppLocale.defaultPhoneCode + phoneController.text,
        name: nameController.text,
        role: 1,
        dateCreated: DateTime.now().toIso8601String(),
      );

      await _firestoreService.createOrUpdateUser(user).catchError((e) {
        AppDialog.showErrorDialog(error: e.toString());
      });

      await getAllConselor();

      AppDialog.closeDialogProgress();
    } else {
      AppDialog.closeDialogProgress();
      AppDialog.showDialog(
        title: 'Nomor Sudah Terdaftar',
        text: 'Nomor yang anda masukkan sudah terdaftar!',
      );
    }
  }

  Future<void> deleteConselor(UserModel user) async {
    AppDialog.showDialogProgress();

    await _firestoreService.deleteUser(user).catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
    });

    await getAllConselor();

    AppDialog.closeDialogProgress();
  }

  bool enableCreateConselor() {
    if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> createOrUpdateServiceType({String? id}) async {
    if (!enableCreateServiceType()) {
      return;
    }

    AppDialog.showDialogProgress();

    var serviceType = MenuItemModel(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
    );

    await _firestoreService
        .createOrUpdateServiceType(serviceType)
        .catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
    });

    await getAllServiceType();

    AppDialog.closeDialogProgress();
  }

  Future<void> deleteServiceType(MenuItemModel serviceType) async {
    AppDialog.showDialogProgress();

    await _firestoreService.deleteServiceType(serviceType).catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
    });

    await getAllServiceType();

    AppDialog.closeDialogProgress();
  }

  bool enableCreateServiceType() {
    if (nameController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void onChangedPhone(String val) {
    notifyListeners();
  }

  void onChangedName(String val) {
    notifyListeners();
  }

  void onChangedScheduleStatus(dynamic val) {
    if (val != null) onActionSchedule?.status = val;
    // notifyListeners();
  }

  void onChangedScheduleConfirmation(int? val) {
    if (val != null) onActionSchedule?.status = val;

    selectedConselor = allConselor != null && allConselor!.isNotEmpty
        ? allConselor!.first
        : null;
    onActionSchedule?.conselor = selectedConselor;
    notifyListeners();
  }

  void onChangedScheduleConselor(dynamic val) {
    selectedConselor = allConselor?.firstWhere((e) => e.id == val);
    onActionSchedule?.conselor = selectedConselor;
    notifyListeners();
  }

  void onChangedScheduleMessage(String val) {
    onActionSchedule?.adminMessage = val;
    notifyListeners();
  }

  Future<void> updateSchedule() async {
    if (onActionSchedule == null) {
      return;
    }

    AppDialog.showDialogProgress();

    await _firestoreService
        .createOrUpdateSchedule(onActionSchedule!)
        .catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
    });

    await getAllSchedule();

    AppDialog.closeDialogProgress();
  }

  bool confirmScheduleEnable() {
    if (onActionSchedule == null) {
      return false;
    }

    if (onActionSchedule!.status == 1) {
      if (selectedConselor != null) {
        return true;
      } else {
        return false;
      }
    }

    if (onActionSchedule!.status == 4) {
      if (nameController.text.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }
}
