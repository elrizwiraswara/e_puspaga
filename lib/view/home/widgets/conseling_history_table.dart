import 'package:excel_dart/excel_dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/const/app_const.dart';
import '../../../app/themes/app_colors.dart';
import '../../../app/themes/app_text_style.dart';
import '../../../app/utilities/date_formatter.dart';
import '../../../app/widgets/app_dialog.dart';
import '../../../app/widgets/app_drop_down.dart';
import '../../../app/widgets/app_filled_button.dart';
import '../../../app/widgets/app_fluent_button.dart';
import '../../../model/schedule/schedule_model.dart';
import '../../../view_model/home_admin_view_model.dart';
import '../../../view_model/profile_view_model.dart';

class ConselingHistoryTable extends StatefulWidget {
  final List<ScheduleModel> data;

  const ConselingHistoryTable({
    super.key,
    required this.data,
  });

  @override
  State<ConselingHistoryTable> createState() => _ConselingHistoryTableState();
}

class _ConselingHistoryTableState extends State<ConselingHistoryTable> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void downloadData() async {
    var excel = Excel.createExcel();

    Sheet sheetObject = excel['DATA KONSELING'];

    excel.setDefaultSheet('DATA KONSELING');

    for (int i = 0; i < 7; i++) {
      var cell = sheetObject.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = excelCellHeader(i);
      cell.cellStyle = CellStyle(backgroundColorHex: "#B0B0B0");
    }

    for (int i = 0; i < widget.data.length; i++) {
      for (int j = 0; j < 7; j++) {
        var cell = sheetObject.cell(
          CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1),
        );

        cell.value = excelCellValue(i, j, widget.data[i]);
      }
    }

    String now = DateTime.now().toIso8601String();
    String fileName = 'CONSELING$now';

    excel.save(fileName: "$fileName.xlsx");
  }

  String excelCellHeader(int i) {
    return i == 0
        ? 'NO'
        : i == 1
            ? 'WAKTU KONSELING'
            : i == 2
                ? 'CLIENT'
                : i == 3
                    ? 'KONSELOR'
                    : i == 4
                        ? 'JENIS LAYANAN'
                        : i == 5
                            ? 'MEDIUM LAYANAN'
                            : i == 6
                                ? 'STATUS'
                                : '';
  }

  dynamic excelCellValue(int no, int j, ScheduleModel data) {
    return j == 0
        ? no + 1
        : j == 1
            ? data.dateTime
            : j == 2
                ? data.client?.name ?? ''
                : j == 3
                    ? data.conselor?.name ?? ''
                    : j == 4
                        ? data.serviceType?.name ?? ''
                        : j == 5
                            ? data.medium?.name ?? ''
                            : j == 6
                                ? scheduleStatusName(data.status)
                                : '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Riwayat Konseling Saya',
                style: AppTextStyle.bold(size: 18),
              ),
              AppFluentButton(
                onTap: () {
                  downloadData();
                },
                text: 'Download Excel',
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: screenSize.width > 1024 ? screenSize.width : 1024,
                child: Column(
                  children: [
                    header(),
                    widget.data.isNotEmpty
                        ? ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: widget.data.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, i) {
                              return row(i);
                            },
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18.0),
                            decoration: const BoxDecoration(
                              color: AppColors.blackLv6,
                            ),
                            child: const Center(
                              child: Text(
                                '(Kosong)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget row(int i) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: i.isEven ? AppColors.white : AppColors.blackLv6,
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                (i + 1).toString(),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 12),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormatter.normalWithClock(widget.data[i].dateTime!),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 12),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data[i].client?.name ?? '',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 12),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data[i].conselor?.name ?? '-',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 12),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data[i].serviceType?.name ?? '',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 12),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data[i].medium?.name ?? '',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 12),
              ),
            ),
          ),
          Consumer2<ProfileViewModel, HomeAdminViewModel>(
              builder: (context, profile, admin, _) {
            return Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      scheduleStatusName(widget.data[i].status),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.bold(
                        size: 12,
                        color: scheduleStatusColor(widget.data[i].status),
                      ),
                    ),
                    profile.user.role == 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: AppFluentButton(
                              onTap: () {
                                admin.onActionSchedule = widget.data[i];
                                AppDialog.showDialog(
                                  title: 'Ubah Status',
                                  child: statusActionDialog(),
                                  showButtons: false,
                                );
                              },
                              text: 'Ubah Status',
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget statusActionDialog() {
    return Consumer<HomeAdminViewModel>(builder: (context, model, _) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDropDown(
              labelText: 'Ubah Status',
              selectedValue: model.onActionSchedule?.status,
              dropdownItems: List.generate(
                scheduleStatusId.length,
                (i) => DropdownMenuItem<int>(
                  value: scheduleStatusId[i],
                  child: Text(scheduleStatusName(scheduleStatusId[i])),
                ),
              ),
              onChanged: model.onChangedScheduleStatus,
            ),
            const SizedBox(height: 18),
            AppFilledButton(
              onTap: () {
                Navigator.pop(context);
                model.updateSchedule();
              },
              text: 'Submit',
            ),
          ],
        ),
      );
    });
  }

  Widget header() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: AppColors.blackLv4,
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'NO',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 14),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'WAKTU KONSELING',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 14),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                'CLIENT',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 14),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'KONSELOR',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 14),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'JENIS LAYANAN',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 14),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'MEDIUM LAYANAN',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 14),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'STATUS',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
