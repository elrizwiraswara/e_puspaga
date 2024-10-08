import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/const/app_const.dart';
import '../../app/themes/app_colors.dart';
import '../../app/widgets/app_dialog.dart';
import '../../model/user/user_model.dart';
import '../app/services/firebase/auth/auth_service.dart';
import '../app/services/firebase/firestore/firestore_service.dart';
import '../app/services/firebase/storage/storage_service.dart';
import '../app/services/locator/locator.dart';
import '../app/utilities/console_log.dart';
import '../app/utilities/date_formatter.dart';
import '../model/user/area_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  final _storageService = locator<StorageService>();
  final _firestoreService = locator<FirestoreService>();

  UserModel user = UserModel();

  String? imageUrl;
  var selectedGender = genderMenuItems.first;
  var selectedReligion = religionMenuItems.first;
  Map<String, dynamic> city = dumaiLocations.first;
  Map<String, dynamic> district = dumaiLocations[0]['district'][0];
  Map<String, dynamic> village = dumaiLocations[0]['district'][0]['village'][0];

  TextEditingController nameController = TextEditingController();
  TextEditingController birthPlaceController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void initProfileView() {
    consoleLog(user);

    imageUrl = user.imageUrl;

    selectedGender = genderMenuItems.firstWhere(
      (e) => e.id == (user.gender ?? genderMenuItems.first.id),
    );
    selectedReligion = religionMenuItems.firstWhere(
      (e) => e.id == (user.religion ?? religionMenuItems.first.id),
    );

    city = user.city?.toJson() ?? city;
    district = user.district?.toJson() ?? district;
    village = user.village?.toJson() ?? village;

    nameController.text = user.name ?? '';
    birthPlaceController.text = user.birthPlace ?? '';
    birthDateController.text = user.birthDate ?? '';
    addressController.text = user.address ?? '';

    consoleLog(selectedGender.toJson());

    notifyListeners();
  }

  void onTapEditPhoto(NavigatorState navigator) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile == null) {
      return;
    }

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Photo',
          toolbarColor: AppColors.tangerineLv1,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
        WebUiSettings(
          // ignore: use_build_context_synchronously
          context: navigator.context,
          zoomable: true,
        ),
      ],
    );

    if (croppedFile != null) {
      uploadImage(navigator, croppedFile);
    }
  }

  Future<void> uploadImage(NavigatorState navigator, CroppedFile file) async {
    AppDialog.showDialogProgress();

    Uint8List imageData = await file.readAsBytes();

    user.imageUrl = await _storageService
        .uploadUserPhoto(user.phone!, imageData)
        .catchError((e) {
      AppDialog.closeDialogProgress();
      AppDialog.showErrorDialog(error: e.toString());
      return;
    });

    AppDialog.closeDialogProgress();

    await createOrUpdateUser(navigator, false);
    getUser();
  }

  void onChangedName(String value) {
    user.name = value;

    notifyListeners();
  }

  void onChangedGender(dynamic value) {
    selectedGender = genderMenuItems.firstWhere(
      (e) => e.id == value,
    );
    user.gender = selectedGender.id;
    notifyListeners();
  }

  void onChangedBirthPlace(String value) {
    user.birthPlace = value;
    notifyListeners();
  }

  void onChangedAddress(String value) {
    user.address = value;
    notifyListeners();
  }

  void onChangedReligion(dynamic value) {
    selectedReligion = religionMenuItems.firstWhere(
      (e) => e.id == value,
    );
    user.religion = selectedReligion.id;
    notifyListeners();
  }

  void onTapBirthdate(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      birthDateController.text = DateFormatter.stripDate(
        date.toIso8601String(),
      );
      user.birthDate = birthDateController.text;
      notifyListeners();
    }
  }

  void onChangedCity(Map<String, dynamic> value) {
    city = value;
    // district = value['district'][0];
    // village = value['district'][0]['village'][0];
    user.city = AreaModel.fromJson(city);
    notifyListeners();
  }

  void onChangedDistrict(Map<String, dynamic> value) {
    district = value;
    village = value['village'][0];
    user.district = AreaModel.fromJson(district);
    notifyListeners();
  }

  void onChangedVillage(Map<String, dynamic> value) {
    village = value;
    user.village = AreaModel.fromJson(village);
    notifyListeners();
  }

  bool enableSaveButton() {
    return nameController.text.isNotEmpty && birthDateController.text.isNotEmpty
        ? true
        : false;
  }

  Future getUser() async {
    try {
      user = (await _firestoreService
          .getUser(_authService.auth.currentUser!.phoneNumber!))!;

      consoleLog('User data loaded');
      consoleLog(user.phone, title: 'User phone');
      consoleLog(user.name, title: 'User name');
      consoleLog(user.role, title: 'User role');

      notifyListeners();
    } catch (e) {
      AppDialog.showErrorDialog(error: e.toString());
    }
  }

  Future checkAndGetUserData(NavigatorState navigator) async {
    if (_authService.auth.currentUser?.phoneNumber == null) {
      consoleLog('User phoneNumber null');
      await navigator.pushNamedAndRemoveUntil('/', (route) => false);
    }

    // Check is user has been added into firestore
    UserModel? userData = await _firestoreService
        .getUser(_authService.auth.currentUser!.phoneNumber!)
        .catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
      return null;
    });

    if (userData == null) {
      consoleLog('User data not exist');
      consoleLog('User must complete the profile');

      final newUser = UserModel(
        id: _authService.auth.currentUser!.phoneNumber!,
        phone: _authService.auth.currentUser!.phoneNumber!,
        role: 2,
      );

      user = newUser;

      await navigator.pushNamedAndRemoveUntil(
        '/edit-profile',
        (route) => false,
        arguments: true,
      );
    } else {
      await getUser();
    }
  }

  Future createOrUpdateUser(
    NavigatorState navigator,
    bool isCreateNewUser,
  ) async {
    AppDialog.showDialogProgress();

    if (user.phone == null) {
      AppDialog.showErrorDialog(error: 'user phone null');
      return;
    }

    if (isCreateNewUser) {
      user.dateCreated = DateTime.now().toIso8601String();
    } else {
      user.dateUpdated = DateTime.now().toIso8601String();
    }

    await _firestoreService.createOrUpdateUser(user).catchError((e) {
      AppDialog.showErrorDialog(error: e.toString());
    });

    AppDialog.closeDialogProgress();

    if (isCreateNewUser) {
      navigator.pushNamedAndRemoveUntil('/main', (route) => false);
    } else {
      notifyListeners();
      AppDialog.showDialog(
        title: 'Berhasil',
        text: 'Profile Anda berhasil diperbarui',
        onTapRightButton: () {
          // navigator.pop();
        },
      );
    }
  }
}
