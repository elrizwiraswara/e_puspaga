import 'package:app_image/app_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/const/app_const.dart';
import '../../app/services/locator/locator.dart';
import '../../app/themes/app_assets.dart';
import '../../app/themes/app_colors.dart';
import '../../app/themes/app_text_style.dart';
import '../../app/widgets/app_drop_down.dart';
import '../../app/widgets/app_filled_button.dart';
import '../../app/widgets/app_logo.dart';
import '../../app/widgets/app_outlined_button.dart';
import '../../app/widgets/app_text_field.dart';
import '../../view_model/profile_view_model.dart';
import '../auth/auth_view.dart';

class EditProfileView extends StatefulWidget {
  final bool isNewUser;

  const EditProfileView({super.key, required this.isNewUser});

  static const String routeName = '/edit-profile';

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController birthPlaceController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final _profileViewModel = locator<ProfileViewModel>();

  @override
  void initState() {
    _profileViewModel.nameController = nameController;
    _profileViewModel.birthPlaceController = birthPlaceController;
    _profileViewModel.birthDateController = birthDateController;
    _profileViewModel.addressController = addressController;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _profileViewModel.initProfileView();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(builder: (context, model, _) {
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
              widget.isNewUser
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(82),
                      child: signUpForm(model),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const AppLogo(),
                          const SizedBox(height: 40),
                          editProfileForm(model),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }

  Widget signUpForm(ProfileViewModel model) {
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
            'Daftar',
            style: AppTextStyle.bold(
              size: 18,
            ),
          ),
          const SizedBox(height: 14),
          termsAndConditions(),
          const SizedBox(height: 32),
          name(model),
          const SizedBox(height: 18),
          gender(model),
          const SizedBox(height: 18),
          birthPlace(model),
          const SizedBox(height: 18),
          birthDate(model),
          const SizedBox(height: 18),
          religion(model),
          const SizedBox(height: 18),
          address(model),
          const SizedBox(height: 18),
          district(model),
          const SizedBox(height: 18),
          village(model),
          const SizedBox(height: 32),
          registerButton(model),
          const SizedBox(height: 32),
          signInText(),
        ],
      ),
    );
  }

  Widget editProfileForm(ProfileViewModel model) {
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
          Row(
            children: [
              const BackButton(),
              Text(
                'Edit Profile',
                style: AppTextStyle.bold(
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          name(model),
          const SizedBox(height: 18),
          gender(model),
          const SizedBox(height: 18),
          birthPlace(model),
          const SizedBox(height: 18),
          birthDate(model),
          const SizedBox(height: 18),
          religion(model),
          const SizedBox(height: 18),
          address(model),
          const SizedBox(height: 18),
          district(model),
          const SizedBox(height: 18),
          village(model),
          const SizedBox(height: 32),
          saveButton(model),
        ],
      ),
    );
  }

  Widget termsAndConditions() {
    return AppOutlinedButton(
      height: null,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Syarat dan Ketentuan',
            style: AppTextStyle.bold(
              size: 10,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            """"Dengan mengisi formulir registrasi ini, Saya menyatakan bersedia berpartisipasi dalam proses konseling online untuk menceritakan permasalahan dan kehidupan pribadi secara sukarela tanpa ada paksaan dan atau untuk melakukan rangkaian proses konseling psikologis online.
             \nDalam kegiatan ini, Psikolog Klinis berkewajiban menjelaskan :\n""",
            style: AppTextStyle.medium(
              size: 10,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. ",
                style: AppTextStyle.medium(
                  size: 10,
                ),
              ),
              Expanded(
                child: Text(
                  "Proses rinci tentang kegiatan yang akan dilangsungkan merupakan bagian proses penerapan konseling online",
                  style: AppTextStyle.medium(
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "2. ",
                style: AppTextStyle.medium(
                  size: 10,
                ),
              ),
              Expanded(
                child: Text(
                  "Tujuan konseling online ini adalah mengenal lebih dalam klien dengan segala issue yang terkait dengannya yang dirasakan penting untuk dibawa dalam proses terapeutik",
                  style: AppTextStyle.medium(
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "3. ",
                style: AppTextStyle.medium(
                  size: 10,
                ),
              ),
              Expanded(
                child: Text(
                  'Identitas diri akan dirahasiakan dari pihak mana pun juga sesuai dengan kode etik Psikologi."',
                  style: AppTextStyle.medium(
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget name(ProfileViewModel model) {
    return AppTextField(
      controller: model.nameController,
      onChanged: model.onChangedName,
      labelText: 'Nama Lengkap',
      hintText: 'Masukkan nama lengkap',
    );
  }

  Widget gender(ProfileViewModel model) {
    return AppDropDown(
      labelText: 'Jenis Kelamin',
      selectedValue: model.selectedGender.id,
      dropdownItems: List.generate(
        genderMenuItems.length,
        (i) => DropdownMenuItem<String>(
          value: genderMenuItems[i].id,
          child: Text(genderMenuItems[i].name ?? ''),
        ),
      ),
      onChanged: model.onChangedGender,
    );
  }

  Widget birthPlace(ProfileViewModel model) {
    return AppTextField(
      controller: model.birthPlaceController,
      onChanged: model.onChangedBirthPlace,
      labelText: 'Tempat Lahir',
      hintText: 'Masukkan tempat lahir',
    );
  }

  Widget birthDate(ProfileViewModel model) {
    return AppTextField(
      controller: model.birthDateController,
      onTap: () {
        model.onTapBirthdate(context);
      },
      labelText: 'Tanggal Lahir',
      hintText: 'Masukkan tanggal lahir',
      enabled: false,
      suffixIcon: const Icon(
        Icons.calendar_month_outlined,
        color: AppColors.blackLv2,
        size: 18,
      ),
    );
  }

  Widget religion(ProfileViewModel model) {
    return AppDropDown(
      labelText: 'Agama',
      selectedValue: model.selectedReligion.id,
      dropdownItems: List.generate(
        religionMenuItems.length,
        (i) => DropdownMenuItem<String>(
          value: religionMenuItems[i].id,
          child: Text(religionMenuItems[i].name ?? ''),
        ),
      ),
      onChanged: model.onChangedReligion,
    );
  }

  Widget address(ProfileViewModel model) {
    return AppTextField(
      controller: model.addressController,
      onChanged: model.onChangedAddress,
      labelText: 'Alamat',
      hintText: 'Masukkan alamat',
    );
  }

  Widget district(ProfileViewModel model) {
    return AppDropDown(
      labelText: 'Kecamatan',
      selectedValue: dumaiLocations
          .firstWhere((e) => e['id'] == model.city['id'])['district']
          .firstWhere((e) => e['id'] == model.district['id']),
      dropdownItems: List.generate(
        dumaiLocations
            .firstWhere((e) => e['id'] == model.city['id'])['district']
            .length,
        (i) {
          return DropdownMenuItem<Map<String, dynamic>>(
            value: dumaiLocations
                .firstWhere((e) => e['id'] == model.city['id'])['district'][i],
            child: Text(
              dumaiLocations.firstWhere(
                  (e) => e['id'] == model.city['id'])['district'][i]['name'],
            ),
          );
        },
      ),
      onChanged: (value) => model.onChangedDistrict(value),
    );
  }

  Widget village(ProfileViewModel model) {
    return AppDropDown(
      labelText: 'Kelurahan',
      selectedValue: dumaiLocations
          .firstWhere((e) => e['id'] == model.city['id'])['district']
          .firstWhere((e) => e['id'] == model.district['id'])['village']
          .firstWhere((e) => e['id'] == model.village['id']),
      dropdownItems: List.generate(
        dumaiLocations
            .firstWhere((e) => e['id'] == model.city['id'])['district']
            .firstWhere((e) => e['id'] == model.district['id'])['village']
            .length,
        (i) {
          return DropdownMenuItem<Map<String, dynamic>>(
            value: dumaiLocations
                .firstWhere((e) => e['id'] == model.city['id'])['district']
                .firstWhere(
                    (e) => e['id'] == model.district['id'])['village'][i],
            child: Text(
              dumaiLocations
                  .firstWhere((e) => e['id'] == model.city['id'])['district']
                  .firstWhere((e) =>
                      e['id'] == model.district['id'])['village'][i]['name'],
            ),
          );
        },
      ),
      onChanged: (value) => model.onChangedVillage(value),
    );
  }

  Widget registerButton(ProfileViewModel model) {
    return AppFilledButton(
      onTap: () {
        FocusScope.of(context).unfocus();
        final navigator = Navigator.of(context);

        model.createOrUpdateUser(navigator, true);
      },
      text: 'Daftar',
    );
  }

  Widget saveButton(ProfileViewModel model) {
    return AppFilledButton(
      onTap: () {
        FocusScope.of(context).unfocus();
        final navigator = Navigator.of(context);

        model.createOrUpdateUser(navigator, false);
      },
      text: 'Simpan',
    );
  }

  Widget signInText() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sudah punya akun? ',
          style: AppTextStyle.regular(
            size: 12,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AuthView.routeName);
          },
          child: Text(
            'Masuk',
            style: AppTextStyle.semibold(
              size: 12,
              color: AppColors.tangerineLv1,
            ),
          ),
        ),
      ],
    );
  }
}
