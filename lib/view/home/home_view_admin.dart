import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../app/const/app_const.dart';
import '../../app/services/locator/locator.dart';
import '../../app/themes/app_colors.dart';
import '../../app/themes/app_text_style.dart';
import '../../app/utilities/date_formatter.dart';
import '../../app/widgets/app_dialog.dart';
import '../../app/widgets/app_drop_down.dart';
import '../../app/widgets/app_filled_button.dart';
import '../../app/widgets/app_fluent_button.dart';
import '../../app/widgets/app_logo.dart';
import '../../app/widgets/app_outlined_button.dart';
import '../../app/widgets/app_text_field.dart';
import '../../model/schedule/schedule_model.dart';
import '../../model/user/gender_model.dart';
import '../../model/user/user_model.dart';
import '../../view_model/home_admin_view_model.dart';
import 'widgets/conseling_history_table.dart';
import 'widgets/profile_card.dart';
import 'widgets/profile_photo.dart';

class HomeViewAdmin extends StatefulWidget {
  const HomeViewAdmin({super.key});

  static const String routeName = '/home-admin';

  @override
  State<HomeViewAdmin> createState() => _HomeViewAdminState();
}

class _HomeViewAdminState extends State<HomeViewAdmin> {
  final _homeAdminViewModel = locator<HomeAdminViewModel>();

  ScrollController scrollController = ScrollController();

  // final conselingDateController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeAdminViewModel.init();
    });
    super.initState();
  }

  @override
  void dispose() {
    // conselingDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeAdminViewModel>(builder: (context, model, _) {
      return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const AppLogo(),
              const SizedBox(height: 40),
              screenSize.width > 678
                  ? SizedBox(
                      // TODO RESPONSIVE WIDTH HIEGHT
                      width: screenSize.width,
                      height: screenSize.height / 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ProfileCard(expand: true),
                          const SizedBox(width: 32),
                          conselingTotalCard(model),
                          const SizedBox(width: 32),
                          conselingDoneCard(model),
                          const SizedBox(width: 32),
                          conselingCancelledCard(model),
                        ],
                      ),
                    )
                  : SizedBox(
                      // TODO RESPONSIVE WIDTH HIEGHT
                      width: screenSize.width,
                      height: 1024,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ProfileCard(expand: true),
                          const SizedBox(height: 32),
                          conselingTotalCard(model),
                          const SizedBox(height: 32),
                          conselingDoneCard(model),
                          const SizedBox(height: 32),
                          conselingCancelledCard(model),
                        ],
                      ),
                    ),
              const SizedBox(height: 32),
              screenSize.width > 678
                  ? SizedBox(
                      width: screenSize.width,
                      height: screenSize.height / 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          waitingToConfirmCard(model),
                          const SizedBox(width: 32),
                          conselorList(model),
                          const SizedBox(width: 32),
                          serviceList(model),
                        ],
                      ),
                    )
                  : SizedBox(
                      width: screenSize.width,
                      height: 1200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          waitingToConfirmCard(model),
                          const SizedBox(height: 32),
                          conselorList(model),
                          const SizedBox(height: 32),
                          serviceList(model),
                        ],
                      ),
                    ),
              const SizedBox(height: 32),
              ConselingHistoryTable(
                data: model.allSchedule ?? [],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget conselingTotalCard(HomeAdminViewModel model) {
    return Expanded(
      child: AppOutlinedButton(
        height: null,
        padding: const EdgeInsets.all(32),
        alignment: Alignment.topLeft,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${model.allSchedule?.length}',
                style: AppTextStyle.bold(size: 70),
              ),
              const SizedBox(height: 12),
              Text(
                'TOTAL KONSELING',
                style: AppTextStyle.bold(size: 20),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget conselingDoneCard(HomeAdminViewModel model) {
    return Expanded(
      child: AppOutlinedButton(
        height: null,
        padding: const EdgeInsets.all(32),
        alignment: Alignment.topLeft,
        buttonColor: AppColors.greenLv6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${model.allSchedule?.where((e) => e.status == 3).length ?? 0}',
                style: AppTextStyle.bold(size: 70),
              ),
              const SizedBox(height: 12),
              Text(
                'KONSELING SELESAI',
                style: AppTextStyle.bold(size: 20),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget conselingCancelledCard(HomeAdminViewModel model) {
    return Expanded(
      child: AppOutlinedButton(
        height: null,
        padding: const EdgeInsets.all(32),
        alignment: Alignment.topLeft,
        buttonColor: AppColors.redLv6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${model.allSchedule?.where((e) => e.status == 4).length ?? 0}',
                style: AppTextStyle.bold(size: 70),
              ),
              const SizedBox(height: 12),
              Text(
                'KONSELING DIBATALKAN',
                style: AppTextStyle.bold(size: 20),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget waitingToConfirmCard(HomeAdminViewModel model) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menunggu Konfirmasi (${model.waitingConfirmSchedules?.length})',
            style: AppTextStyle.bold(size: 20),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: AppOutlinedButton(
              height: null,
              padding: const EdgeInsets.all(32),
              alignment: Alignment.topLeft,
              child: model.waitingConfirmSchedules!.isNotEmpty
                  ? Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List.generate(
                              model.waitingConfirmSchedules!.length,
                              (i) => waitingListTile(
                                model,
                                model.waitingConfirmSchedules![i],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        '(Kosong)',
                        style: AppTextStyle.bold(
                          size: 12,
                          color: AppColors.blackLv2,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget conselorList(HomeAdminViewModel model) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Konselor (${model.allConselor?.length})',
                style: AppTextStyle.bold(size: 20),
              ),
              AppFluentButton(
                onTap: () async {
                  model.clearTextController();
                  await AppDialog.showDialog(
                    title: 'Tambah Akun Konselor',
                    child: createConselorDialog(),
                    rightButtonText: 'Batal',
                  );
                },
                text: '+ Tambah Konselor',
              )
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: AppOutlinedButton(
              height: null,
              padding: const EdgeInsets.all(32),
              alignment: Alignment.topLeft,
              child: model.allConselor!.isNotEmpty
                  ? Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List.generate(
                              model.allConselor!.length,
                              (i) => conselorListTile(
                                model,
                                model.allConselor![i],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        '(Kosong)',
                        style: AppTextStyle.bold(
                          size: 12,
                          color: AppColors.blackLv2,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceList(HomeAdminViewModel model) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Jenis Layanan (${model.allServiceType?.length})',
                style: AppTextStyle.bold(size: 20),
              ),
              AppFluentButton(
                onTap: () async {
                  model.clearTextController();

                  await AppDialog.showDialog(
                    title: 'Tambah Jenis Layanan',
                    child: createServiceTypeDialog(),
                    rightButtonText: 'Batal',
                  );
                },
                text: '+ Tambah Jenis Layanan',
              )
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: AppOutlinedButton(
              height: null,
              padding: const EdgeInsets.all(32),
              alignment: Alignment.topLeft,
              child: model.allServiceType!.isNotEmpty
                  ? Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List.generate(
                              model.allServiceType!.length,
                              (i) => serviceListTile(
                                model,
                                model.allServiceType![i],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        '(Kosong)',
                        style: AppTextStyle.bold(
                          size: 12,
                          color: AppColors.blackLv2,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget waitingListTile(HomeAdminViewModel model, ScheduleModel schedule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppOutlinedButton(
        onTap: () {
          model.onActionSchedule = schedule;
          AppDialog.showDialog(
            child: confirmScheduleDialog(schedule),
            showButtons: false,
          );
        },
        height: null,
        padding: const EdgeInsets.all(18),
        buttonColor: AppColors.tangerineLv6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ProfilePhoto(size: 60, imgUrl: schedule.client?.imageUrl),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.client?.name ?? '',
                      style: AppTextStyle.semibold(
                        size: 12,
                      ),
                    ),
                    Text(
                      DateFormatter.normalWithClock(
                        DateTime.now().toIso8601String(),
                      ),
                      style: AppTextStyle.bold(
                        size: 18,
                      ),
                    ),
                    Text(
                      '${schedule.medium?.name ?? ''} - ${schedule.serviceType?.name ?? ''}',
                      style: AppTextStyle.semibold(
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 14),
            const Icon(
              Icons.arrow_forward_ios,
              size: 26,
              color: AppColors.blackLv1,
            )
          ],
        ),
      ),
    );
  }

  Widget conselorListTile(HomeAdminViewModel model, UserModel user) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppOutlinedButton(
        height: null,
        padding: const EdgeInsets.all(18),
        buttonColor: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ProfilePhoto(size: 60, imgUrl: user.imageUrl),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (user.name ?? ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bold(
                            size: 18,
                          ),
                        ),
                        Text(
                          user.phone ?? '',
                          style: AppTextStyle.semibold(
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            GestureDetector(
              onTap: () {
                AppDialog.showDialog(
                  title: 'Konfirmasi',
                  text: 'Apakah kamu yakin ingin menghapus akun konselor ini?',
                  leftButtonText: 'Batal',
                  rightButtonText: 'Hapus',
                  onTapRightButton: () {
                    model.deleteConselor(user);
                  },
                );
              },
              child: const Icon(
                Icons.delete,
                size: 20,
                color: AppColors.redLv1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget serviceListTile(HomeAdminViewModel model, MenuItemModel serviceType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppOutlinedButton(
        height: null,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 30,
        ),
        buttonColor: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (serviceType.name ?? ''),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bold(
                      size: 18,
                    ),
                  ),
                  // Text(
                  //   'KODE: TKA & PA',
                  //   style: AppTextStyle.semibold(
                  //     size: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    model.clearTextController();
                    model.nameController.text = serviceType.name ?? '';
                    await AppDialog.showDialog(
                      title: 'Edit Jenis Layanan',
                      child: createServiceTypeDialog(serviceType: serviceType),
                      rightButtonText: 'Batal',
                    );
                  },
                  child: const Icon(
                    Icons.edit,
                    size: 20,
                    color: AppColors.orangeLv1,
                  ),
                ),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () {
                    AppDialog.showDialog(
                      title: 'Konfirmasi',
                      text:
                          'Apakah kamu yakin ingin menghapus jenis layanan ini?',
                      leftButtonText: 'Batal',
                      rightButtonText: 'Hapus',
                      onTapRightButton: () {
                        model.deleteServiceType(serviceType);
                      },
                    );
                  },
                  child: const Icon(
                    Icons.delete,
                    size: 20,
                    color: AppColors.redLv1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget createConselorDialog() {
    return Consumer<HomeAdminViewModel>(builder: (context, model, _) {
      return Column(
        children: [
          AppTextField(
            controller: model.phoneController,
            onChanged: model.onChangedPhone,
            labelText: 'Nomor Handphone Conselor',
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
          const SizedBox(height: 18),
          AppTextField(
            controller: model.nameController,
            onChanged: model.onChangedName,
            labelText: 'Nama Lengkap Konselor',
            hintText: 'Masukkan nama lengkap',
          ),
          const SizedBox(height: 20),
          AppFilledButton(
            onTap: () {
              Navigator.pop(context);
              model.createConselor();
            },
            enable: model.enableCreateConselor(),
            text: 'Tambah',
          )
        ],
      );
    });
  }

  Widget createServiceTypeDialog({MenuItemModel? serviceType}) {
    return Consumer<HomeAdminViewModel>(builder: (context, model, _) {
      return Column(
        children: [
          AppTextField(
            controller: model.nameController,
            onChanged: model.onChangedName,
            labelText: 'Nama Jenis Layanan',
            hintText: 'Masukkan nama jenis layanan',
          ),
          const SizedBox(height: 20),
          AppFilledButton(
            onTap: () {
              Navigator.pop(context);
              model.createOrUpdateServiceType(id: serviceType?.id);
            },
            enable: model.enableCreateServiceType(),
            text: serviceType != null ? 'Simpan' : 'Tambah',
          )
        ],
      );
    });
  }

  Widget confirmScheduleDialog(ScheduleModel schedule) {
    return Consumer<HomeAdminViewModel>(builder: (context, model, _) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfilePhoto(
                  size: 44,
                  imgUrl: schedule.client?.imageUrl,
                ),
                const SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.client?.name ?? '',
                      style: AppTextStyle.bold(size: 16),
                    ),
                    Text(
                      schedule.client?.phone ?? '',
                      style: AppTextStyle.medium(size: 12),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormatter.normal(schedule.dateTime!),
                  style: AppTextStyle.bold(
                    size: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.av_timer_rounded,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormatter.onlyClockWithDivider(
                    schedule.dateTime!,
                  ),
                  style: AppTextStyle.bold(
                    size: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.wifi,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  schedule.medium?.name ?? '-',
                  style: AppTextStyle.bold(
                    size: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.topic,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  schedule.serviceType?.name ?? '',
                  style: AppTextStyle.bold(
                    size: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Status Jadwal',
              style: AppTextStyle.bold(size: 14),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                model.onChangedScheduleConfirmation(1);
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: schedule.status,
                      activeColor: AppColors.tangerineLv1,
                      onChanged: model.onChangedScheduleConfirmation,
                    ),
                    Text(
                      'Dikonfirmasi',
                      style: AppTextStyle.semibold(size: 14),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                model.onChangedScheduleConfirmation(2);
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Radio(
                      value: 2,
                      groupValue: schedule.status,
                      activeColor: AppColors.tangerineLv1,
                      onChanged: model.onChangedScheduleConfirmation,
                    ),
                    Text(
                      'Tidak Dapat Dikonfirmasi',
                      style: AppTextStyle.semibold(size: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            schedule.status == 1
                ? AppDropDown(
                    labelText: 'Pilih Konselor',
                    selectedValue: model.selectedConselor?.id,
                    dropdownItems: List.generate(
                      model.allConselor?.length ?? 0,
                      (i) => DropdownMenuItem<String>(
                        value: model.allConselor?[i].id,
                        child: Text(model.allConselor?[i].name ?? ''),
                      ),
                    ),
                    onChanged: model.onChangedScheduleConselor,
                  )
                : schedule.status == 2
                    ? AppTextField(
                        controller: model.nameController,
                        onChanged: model.onChangedName,
                        minLines: 3,
                        maxLines: 3,
                        labelText: 'Pesan untuk client',
                        hintText: 'Pesan untuk client',
                      )
                    : const SizedBox.shrink(),
            const SizedBox(height: 18),
            AppFilledButton(
              onTap: () {
                Navigator.pop(context);
                model.updateSchedule();
              },
              enable: model.confirmScheduleEnable(),
              text: 'Submit',
            ),
          ],
        ),
      );
    });
  }
}
