import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

import '../services/dialog/dialog_service.dart';
import '../services/firebase/auth/auth_service.dart';
import '../services/locator/locator.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_style.dart';
import '../utilities/console_log.dart';
import 'app_filled_button.dart';
import 'app_progress_indicator.dart';

//App Dialog
class AppDialog {
  static final AuthService _authService = locator<AuthService>();
  static final DialogService _dialogService = locator<DialogService>();

  static int _restartCount = 0;

  static Future<DialogResponse?>? showDialog({
    String? title,
    Widget? child,
    String? text,
    EdgeInsetsGeometry? padding,
    String? leftButtonText,
    String? rightButtonText = 'Tutup',
    Color? backgroundColor,
    Function()? onTapLeftButton,
    Function()? onTapRightButton,
    bool dismissible = true,
    bool showButtons = true,
    bool enableRightButton = true,
    bool enableLeftButton = true,
    Color leftButtonTextColor = AppColors.blackLv2,
    Color rightButtonTextColor = AppColors.orangeLv1,
    double? elevation,
  }) async {
    return await _dialogService.showDialog(
      AppDialogWidget(
        title: title,
        text: text,
        padding: padding,
        rightButtonText: rightButtonText,
        leftButtonText: leftButtonText,
        backgroundColor: backgroundColor,
        onTapLeftButton: onTapLeftButton,
        onTapRightButton: onTapRightButton,
        dismissible: kDebugMode ? true : dismissible,
        showButtons: showButtons,
        elevation: elevation,
        enableRightButton: enableRightButton,
        enableLeftButton: enableLeftButton,
        leftButtonTextColor: leftButtonTextColor,
        rightButtonTextColor: rightButtonTextColor,
        child: child,
      ),
    );
  }

  static void showDialogProgress({bool dismissible = false}) {
    _dialogService.showDialogProgress(
      AppDialogWidget(
        dismissible: kDebugMode ? true : dismissible,
        backgroundColor: Colors.transparent,
        elevation: 0,
        showButtons: false,
        child: const AppProgressIndicator(
          color: Colors.white,
          textColor: Colors.white,
        ),
      ),
    );
  }

  static void closeDialogProgress() {
    _dialogService.closeDialogProgress();
  }

  static Future showErrorDialog({
    bool dismissible = false,
    String? messages,
    String? error,
    String? buttonText,
    Function()? onTap,
  }) async {
    consoleLog(error, title: 'Error Dialog');
    await _dialogService.showDialog(
      AppDialogWidget(
        dismissible: kDebugMode ? true : dismissible,
        title: 'Terjadi Kesalahan',
        rightButtonText: buttonText ?? 'Restart',
        onTapRightButton: onTap ??
            () {
              if (_restartCount < 3) {
                _restartCount += 1;
                Restart.restartApp();
              } else {
                _authService.auth.signOut();
                _restartCount = 0;
                Restart.restartApp();
              }
            },
        child: Column(
          children: [
            Text(
              messages ??
                  'Terjadi kesalahan tak terduga, coba lagi atau restart aplikasi',
              textAlign: TextAlign.center,
              style: AppTextStyle.medium(size: 12),
            ),
            // error != null && kDebugMode
            error != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      error.substring(
                        0,
                        error.length > 100 ? 100 : error.length,
                      ),
                      textAlign: TextAlign.center,
                      style: AppTextStyle.semibold(
                        size: 8,
                        color: AppColors.blackLv2,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class DialogResponse {
  final Object? rightButtonCallback;
  final Object? leftButtonCallback;
  final bool confirmed;
  DialogResponse({
    this.rightButtonCallback,
    this.leftButtonCallback,
    this.confirmed = true,
  });
}

// Custom Dialog
class AppDialogWidget extends StatelessWidget {
  final String? title;
  final Widget? child;
  final String? text;
  final EdgeInsetsGeometry? padding;
  final String? leftButtonText;
  final String? rightButtonText;
  final Color? backgroundColor;
  final Function()? onTapLeftButton;
  final Function()? onTapRightButton;
  final bool dismissible;
  final bool showButtons;
  final bool enableRightButton;
  final bool enableLeftButton;
  final Color leftButtonTextColor;
  final Color rightButtonTextColor;
  final double? elevation;

  const AppDialogWidget({
    super.key,
    this.title,
    this.child,
    this.text,
    this.padding,
    this.rightButtonText = 'Tutup',
    this.leftButtonText,
    this.backgroundColor,
    this.onTapLeftButton,
    this.onTapRightButton,
    this.dismissible = true,
    this.showButtons = true,
    this.enableRightButton = true,
    this.enableLeftButton = true,
    this.leftButtonTextColor = AppColors.blackLv2,
    this.rightButtonTextColor = AppColors.orangeLv1,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: dismissible,
      child: Dialog(
        elevation: elevation,
        backgroundColor: backgroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 512),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                dialogTitle(),
                dialogBody(),
                dialogButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dialogTitle() {
    return title != null
        ? Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: AppColors.blackLv3,
                ),
              ),
            ),
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: AppTextStyle.bold(size: 14),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget dialogBody() {
    return Container(
      padding: padding ?? const EdgeInsets.all(18),
      child: text != null
          ? Text(
              text!,
              textAlign: TextAlign.center,
              style: AppTextStyle.medium(size: 12),
            )
          : child ?? const SizedBox.shrink(),
    );
  }

  Widget dialogButtons(BuildContext context) {
    return !showButtons
        ? const SizedBox.shrink()
        : Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 0.5,
                  color: AppColors.blackLv3,
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                leftButtonText != null
                    ? Expanded(
                        child: AppFilledButton(
                          height: 48,
                          buttonColor: Colors.white,
                          text: leftButtonText!,
                          fontSize: 12,
                          textColor: enableRightButton
                              ? leftButtonTextColor
                              : AppColors.blackLv3,
                          onTap: () async {
                            if (enableLeftButton) {
                              final dialogService = locator<DialogService>();

                              if (onTapLeftButton != null) {
                                Navigator.of(context).pop();
                                AppDialog.showDialogProgress();

                                final val = await onTapLeftButton!();

                                dialogService.dialogComplete(
                                  DialogResponse(
                                    confirmed: false,
                                    leftButtonCallback: val,
                                  ),
                                );

                                AppDialog.closeDialogProgress();
                              } else {
                                Navigator.of(context).pop();
                                dialogService.dialogComplete(
                                  DialogResponse(confirmed: false),
                                );
                              }
                            }
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                leftButtonText != null && rightButtonText != null
                    ? Container(
                        height: 18,
                        width: 1,
                        color: AppColors.blackLv3,
                      )
                    : const SizedBox.shrink(),
                rightButtonText != null
                    ? Expanded(
                        child: AppFilledButton(
                          height: 48,
                          buttonColor: Colors.white,
                          text: rightButtonText!,
                          fontSize: 12,
                          textColor: enableRightButton
                              ? rightButtonTextColor
                              : AppColors.blackLv2,
                          onTap: () async {
                            if (enableRightButton) {
                              final dialogService = locator<DialogService>();

                              if (onTapRightButton != null) {
                                Navigator.of(context).pop();
                                AppDialog.showDialogProgress();

                                final val = await onTapRightButton!();

                                dialogService.dialogComplete(
                                  DialogResponse(
                                    confirmed: true,
                                    rightButtonCallback: val,
                                  ),
                                );

                                AppDialog.closeDialogProgress();
                              } else {
                                Navigator.of(context).pop();
                                dialogService.dialogComplete(
                                  DialogResponse(confirmed: true),
                                );
                              }
                            }
                          },
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          );
  }
}
