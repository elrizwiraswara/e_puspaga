import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:provider/provider.dart';

import '../../app/const/app_const.dart';
import '../../app/services/locator/locator.dart';
import '../../app/themes/app_colors.dart';
import '../../app/themes/app_text_style.dart';
import '../../app/utilities/date_formatter.dart';
import '../../app/widgets/app_dialog.dart';
import '../../app/widgets/app_drop_down.dart';
import '../../app/widgets/app_filled_button.dart';
import '../../app/widgets/app_logo.dart';
import '../../app/widgets/app_outlined_button.dart';
import '../../app/widgets/app_text_field.dart';
import '../../model/schedule/schedule_model.dart';
import '../../view_model/home_client_view_model.dart';
import '../room/room_view.dart';
import 'widgets/conseling_history_table.dart';
import 'widgets/profile_card.dart';

class HomeViewClient extends StatefulWidget {
  const HomeViewClient({super.key});

  static const String routeName = '/home-client';

  @override
  State<HomeViewClient> createState() => _HomeViewClientState();
}

class _HomeViewClientState extends State<HomeViewClient> {
  final _homeClientViewModel = locator<HomeClientViewModel>();

  ScrollController scrollController = ScrollController();

  final conselingDateController = TextEditingController();

  @override
  void initState() {
    _homeClientViewModel.conselingDateController = conselingDateController;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeClientViewModel.init();
    });
    super.initState();
  }

  @override
  void dispose() {
    conselingDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeClientViewModel>(builder: (context, model, _) {
      return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const AppLogo(),
              const SizedBox(height: 40),
              screenSize.width > 678
                  ? Container(
                      // TODO RESPONSIVE WIDTH HIEGHT
                      width: screenSize.width,
                      // height: screenSize.height / 3,
                      constraints: const BoxConstraints(
                        maxHeight: 360,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ProfileCard(),
                          const SizedBox(width: 32),
                          scheduleCard(model),
                        ],
                      ))
                  : SizedBox(
                      // TODO RESPONSIVE WIDTH HIEGHT
                      width: screenSize.width,
                      // height: screenSize.height / 3,
                      // constraints: BoxConstraints(
                      //   maxHeight: 360,
                      // ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ProfileCard(expand: true),
                          const SizedBox(height: 32),
                          scheduleCard(model),
                        ],
                      )),
              const SizedBox(height: 32),
              ConselingHistoryTable(
                data: model.scheduleHistory ?? [],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget scheduleCard(HomeClientViewModel model) {
    return model.currentSchedule == null
        ? createScheduleCard(model)
        : model.currentSchedule!.status! < 2
            ? waitingOrConfirmedCard(model)
            : scheduleNotAvailableCard(model);
  }

  Widget createScheduleCard(HomeClientViewModel model) {
    return Container(
      constraints: screenSize.width > 678
          ? const BoxConstraints(
              maxWidth: 356,
            )
          : null,
      child: AppOutlinedButton(
        height: null,
        padding: const EdgeInsets.all(32),
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwalkan Konseling',
              style: AppTextStyle.bold(size: 20),
            ),
            const SizedBox(height: 18),
            Text(
              'Berikut tahapan membuat jadwal konseling',
              style: AppTextStyle.bold(size: 12),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1. ",
                  style: AppTextStyle.medium(
                    size: 12,
                  ),
                ),
                Text(
                  "Klik tombol buat jadwal di bawah",
                  style: AppTextStyle.medium(
                    size: 12,
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
                    size: 12,
                  ),
                ),
                Text(
                  "Tentukan jenis layanan dan waktu konseling",
                  style: AppTextStyle.medium(
                    size: 12,
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
                    size: 12,
                  ),
                ),
                Text(
                  "Tunggu konfirmasi dari Admin",
                  style: AppTextStyle.medium(
                    size: 12,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "4. ",
                  style: AppTextStyle.medium(
                    size: 12,
                  ),
                ),
                Text(
                  "Masuk ke room/halaman konseling",
                  style: AppTextStyle.medium(
                    size: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            createScheduleButton(model),
          ],
        ),
      ),
    );
  }

  Widget createScheduleButton(HomeClientViewModel model,
      {ScheduleModel? current}) {
    return AppFilledButton(
      width: double.infinity,
      onTap: () async {
        if (current != null) {
          await model.cancelSchedule();
        }

        model.resetCreateSceduleState();
        await AppDialog.showDialog(
          title: 'Buat Jadwal',
          child: createScheduleDialog(),
          rightButtonText: 'Batal',
        );
      },
      text: 'Buat Jadwal',
    );
  }

  Widget waitingOrConfirmedCard(HomeClientViewModel model) {
    return Container(
      constraints: screenSize.width > 678
          ? const BoxConstraints(
              maxWidth: 356,
            )
          : null,
      child: AppOutlinedButton(
        height: null,
        padding: const EdgeInsets.all(32),
        alignment: Alignment.topLeft,
        buttonColor: AppColors.tangerineLv6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.currentSchedule!.status == 0
                  ? 'Menunggu Konfirmasi'
                  : 'Jadwal Dikonfirmasi',
              style: AppTextStyle.bold(size: 20),
            ),
            const SizedBox(height: 18),
            Text(
              model.currentSchedule!.status == 0
                  ? 'Jadwal konseling telah dibuat, mohon tunggu konfirmasi dari Admin'
                  : model.currentSchedule!.medium?.id == 'online'
                      ? 'Jadwal konseling telah dikonfirmasi, silahkan buka kembali halaman web ini pada jadwal yang telah dibuat'
                      : 'Jadwal konseling telah dikonfirmasi, silahkan untuk datang ke kantor Puspaga Kota Dumai di Jl. Puteri Tujuh, Teluk Binjai, Dumai Timur pada jadwal yang telah ditentukan',
              style: AppTextStyle.bold(size: 12),
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
                  DateFormatter.normal(model.currentSchedule!.dateTime!),
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
                    model.currentSchedule!.dateTime!,
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
                  model.currentSchedule!.medium?.name ?? '-',
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
                  model.currentSchedule!.serviceType?.name ?? '',
                  style: AppTextStyle.bold(
                    size: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const SizedBox(height: 8),
            model.currentSchedule!.status == 0 &&
                    model.currentSchedule!.conselor != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          model.currentSchedule!.conselor?.name ?? '-',
                          style: AppTextStyle.bold(
                            size: 11,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(height: 8),
            model.currentSchedule!.status == 0
                ? GestureDetector(
                    onTap: () {
                      AppDialog.showDialog(
                        title: 'Konfirmasi',
                        text:
                            'Apakah Anda yakin ingin membatalkan jawal konseling ini?',
                        rightButtonText: 'Ya',
                        leftButtonText: 'Tidak',
                        onTapRightButton: () {
                          model.cancelSchedule();
                        },
                      );
                    },
                    child: Text(
                      'Batalkan',
                      style: AppTextStyle.semibold(
                        size: 12,
                        color: AppColors.tangerineLv1,
                      ),
                    ),
                  )
                // : enterConselingButton(model),
                : CountdownTimer(
                    endTime: DateTime.parse(model.currentSchedule!.dateTime!)
                        .millisecondsSinceEpoch,
                    widgetBuilder: (_, time) {
                      if (time == null) {
                        return enterConselingButton(model);
                      }

                      return timerButton(time);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget enterConselingButton(HomeClientViewModel model) {
    if (model.currentSchedule!.medium?.id == 'offline') {
      return const SizedBox.shrink();
    }

    return AppFilledButton(
      width: double.infinity,
      onTap: () async {
        await Navigator.pushNamed(
          context,
          RoomView.routeName,
          arguments: {
            "schedule_id": model.currentSchedule!.id!,
            "room_id": model.currentSchedule!.roomId!,
            "user": model.currentSchedule!.client,
            "opponent_user": model.currentSchedule!.conselor,
          },
        );
        model.init();
      },
      text: 'Masuk Halaman Konseling',
    );
  }

  Widget timerButton(CurrentRemainingTime? time) {
    return AppFilledButton(
      width: double.infinity,
      enable: false,
      onTap: () {},
      text:
          '🕑 ${time?.days ?? '0'}:${time?.hours ?? '0'}:${time?.min ?? '0'}:${time?.sec ?? '0'}',
    );
  }

  Widget scheduleNotAvailableCard(HomeClientViewModel model) {
    return Container(
      constraints: screenSize.width > 678
          ? const BoxConstraints(
              maxWidth: 356,
            )
          : null,
      child: AppOutlinedButton(
        height: null,
        padding: const EdgeInsets.all(32),
        alignment: Alignment.topLeft,
        buttonColor: AppColors.redLv6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal Tidak Tersedia',
              style: AppTextStyle.bold(size: 20),
            ),
            const SizedBox(height: 18),
            Text(
              'Jadwal konseling yang kamu buat untuk tanggal ${DateFormatter.stripDateWithClock(model.currentSchedule!.dateTime!)} tidak tersedia, silahkan membuat jadwal baru dengan menekan tombol Buat Jadwal.',
              style: AppTextStyle.bold(size: 12),
            ),
            const SizedBox(height: 18),
            Text(
              model.currentSchedule?.adminMessage ?? '',
              style: AppTextStyle.bold(size: 12),
            ),
            const SizedBox(height: 18),
            createScheduleButton(model, current: model.currentSchedule),
          ],
        ),
      ),
    );
  }

  Widget createScheduleDialog() {
    return Consumer<HomeClientViewModel>(builder: (context, model, _) {
      return Column(
        children: [
          AppDropDown(
            labelText: 'Medium Konseling',
            selectedValue: model.selectedMedium.id,
            dropdownItems: List.generate(
              conselingMedium.length,
              (i) => DropdownMenuItem<String>(
                value: conselingMedium[i].id,
                child: Text(conselingMedium[i].name ?? ''),
              ),
            ),
            onChanged: model.onChangedMedium,
          ),
          const SizedBox(height: 18),
          AppDropDown(
            labelText: 'Jenis Layanan (Topik)',
            selectedValue: model.selectedServiceType?.id,
            dropdownItems: List.generate(
              model.serviceType.length,
              (i) => DropdownMenuItem<String>(
                value: model.serviceType[i].id,
                child: Text(model.serviceType[i].name ?? ''),
              ),
            ),
            onChanged: model.onChangedServiceType,
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: model.conselingDateController,
            onTap: () {
              model.onTapDate(context);
            },
            labelText: 'Tanggal & Waktu',
            hintText: 'Pilih tanggal & waktu',
            enabled: false,
            suffixIcon: const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.blackLv2,
              size: 18,
            ),
          ),
          const SizedBox(height: 20),
          AppFilledButton(
            onTap: () {
              Navigator.pop(context);
              model.createSchedule();
            },
            enable: model.enableCreateSchedule(),
            text: 'Buat Jadwal',
          )
        ],
      );
    });
  }
}
