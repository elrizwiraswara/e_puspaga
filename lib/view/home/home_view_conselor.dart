import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:provider/provider.dart';

import '../../app/const/app_const.dart';
import '../../app/services/locator/locator.dart';
import '../../app/themes/app_colors.dart';
import '../../app/themes/app_text_style.dart';
import '../../app/utilities/date_formatter.dart';
import '../../app/widgets/app_dialog.dart';
import '../../app/widgets/app_filled_button.dart';
import '../../app/widgets/app_logo.dart';
import '../../app/widgets/app_outlined_button.dart';
import '../../model/schedule/schedule_model.dart';
import '../../view_model/home_conselor_view_model.dart';
import '../room/room_view.dart';
import 'widgets/conseling_history_table.dart';
import 'widgets/profile_card.dart';
import 'widgets/profile_photo.dart';

class HomeViewConselor extends StatefulWidget {
  const HomeViewConselor({super.key});

  static const String routeName = '/home-conselor';

  @override
  State<HomeViewConselor> createState() => _HomeViewConselorState();
}

class _HomeViewConselorState extends State<HomeViewConselor> {
  ScrollController scrollController = ScrollController();

  final _homeConselorViewModel = locator<HomeConselorViewModel>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeConselorViewModel.init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeConselorViewModel>(builder: (context, model, _) {
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
                          waitingCard(model),
                          Expanded(child: waitingListCard(model)),
                        ],
                      ),
                    )
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
                          waitingCard(model),
                          SizedBox(height: 200, child: waitingListCard(model)),
                        ],
                      ),
                    ),
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

  Widget waitingCard(HomeConselorViewModel model) {
    if (model.nearestSchedule == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: screenSize.width > 678
          ? const EdgeInsets.only(right: 32)
          : const EdgeInsets.only(bottom: 32),
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
              DateTime.now().compareTo(DateTime.parse(
                        model.nearestSchedule!.dateTime!,
                      )) >=
                      0
                  ? 'Sedang Berjalan'
                  : 'Segera Dimulai',
              style: AppTextStyle.bold(size: 20),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                ProfilePhoto(
                  size: 44,
                  imgUrl: model.nearestSchedule?.client?.imageUrl,
                ),
                const SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.nearestSchedule?.client?.name ?? '',
                      style: AppTextStyle.bold(size: 16),
                    ),
                    Text(
                      model.nearestSchedule?.client?.phone ?? '',
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
                  DateFormatter.normal(model.nearestSchedule!.dateTime!),
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
                    model.nearestSchedule!.dateTime!,
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
                  model.nearestSchedule!.medium?.name ?? '-',
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
                  model.nearestSchedule!.serviceType?.name ?? '',
                  style: AppTextStyle.bold(
                    size: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            CountdownTimer(
              endTime: DateTime.parse(
                model.nearestSchedule!.dateTime!,
              ).millisecondsSinceEpoch,
              widgetBuilder: (_, time) {
                if (time == null) {
                  return Column(
                    children: [
                      enterConselingButton(model),
                      const SizedBox(height: 18),
                      closeRoomButton(model),
                    ],
                  );
                }

                return timerButton(time);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget enterConselingButton(HomeConselorViewModel model) {
    if (model.nearestSchedule!.medium?.id == 'offline') {
      return const SizedBox.shrink();
    }

    return AppFilledButton(
      width: double.infinity,
      onTap: () async {
        await Navigator.pushNamed(
          context,
          RoomView.routeName,
          arguments: {
            "schedule_id": model.nearestSchedule!.id!,
            "room_id": model.nearestSchedule!.roomId!,
            "user": model.nearestSchedule!.conselor,
            "opponent_user": model.nearestSchedule!.client,
          },
        );
        model.init();
      },
      text: 'Masuk Halaman Konseling',
    );
  }

  Widget closeRoomButton(HomeConselorViewModel model) {
    return GestureDetector(
      onTap: () {
        AppDialog.showDialog(
          title: 'Konfirmasi',
          text:
              'Apakah kamu yakin ingin menutup dan menyelesaikan sesi konseling ini?',
          rightButtonText: 'Ya',
          leftButtonText: 'Batal',
          onTapRightButton: () {
            model.closeConselingSession();
          },
        );
      },
      child: Text(
        'Tutup Sesi Konseling',
        style: AppTextStyle.semibold(
          size: 12,
          color: AppColors.orangeLv1,
        ),
      ),
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

  Widget waitingListCard(HomeConselorViewModel model) {
    if (model.incomingSchedules == null) {
      return const SizedBox.shrink();
    }

    return AppOutlinedButton(
      height: null,
      padding: const EdgeInsets.all(32),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Akan Datang (${model.incomingSchedules!.length})',
            style: AppTextStyle.bold(size: 20),
          ),
          const SizedBox(height: 18),
          model.incomingSchedules!.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(
                          model.incomingSchedules!.length,
                          (i) => waitingListTile(model.incomingSchedules![i]),
                        )
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    '(Kosong)',
                    style: AppTextStyle.bold(
                      size: 12,
                      color: AppColors.blackLv2,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget waitingListTile(ScheduleModel schedule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppOutlinedButton(
        height: null,
        padding: const EdgeInsets.all(18),
        buttonColor: AppColors.white,
        child: Row(
          children: [
            ProfilePhoto(
              size: 60,
              imgUrl: schedule.client!.imageUrl,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.client?.name ?? '',
                    style: AppTextStyle.semibold(
                      size: 12,
                    ),
                  ),
                  Text(
                    DateFormatter.normalWithClock(schedule.dateTime!),
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
            )
          ],
        ),
      ),
    );
  }
}
