import 'package:flutter/material.dart';

import '../../widgets/app_dialog.dart';
import '../locator/locator.dart';
import 'dialog_service.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  const DialogManager({super.key, required this.child});

  @override
  State<DialogManager> createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
    _dialogService.registerDialogProgressListener(_showDialogProgress);
    _dialogService.registerCloseDialogProgressListener(_closeDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(AppDialogWidget appDialog) async {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: appDialog.dismissible,
        builder: (context) {
          return appDialog;
        },
      );
    }
  }

  void _showDialogProgress(AppDialogWidget appDialog) async {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: appDialog.dismissible,
        builder: (context) {
          return appDialog;
        },
      );
    }
  }

  void _closeDialog() async {
    Navigator.of(context).pop();
  }
}
