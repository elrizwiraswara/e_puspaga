import 'dart:async';

import '../../widgets/app_dialog.dart';

class DialogService {
  Function(AppDialogWidget) _showDialogListener = (dialog) {};
  Function(AppDialogWidget) _dialogProgressListener = (dialog) {};
  Function() _closeDialogProgressListener = () {};
  Completer<DialogResponse?>? _dialogCompleter;

  /// Registers a callback function. Typically to show the dialog
  void registerDialogListener(Function(AppDialogWidget) dialog) {
    _showDialogListener = dialog;
  }

  void registerDialogProgressListener(Function(AppDialogWidget) dialog) {
    _dialogProgressListener = dialog;
  }

  void registerCloseDialogProgressListener(Function() dialog) {
    _closeDialogProgressListener = dialog;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future<DialogResponse?>? showDialog(AppDialogWidget dialog) async {
    _dialogCompleter = Completer<DialogResponse?>();
    _showDialogListener(dialog);
    return _dialogCompleter?.future;
  }

  void showDialogProgress(AppDialogWidget dialog) async {
    _dialogProgressListener(dialog);
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete(DialogResponse dialogResponse) {
    _dialogCompleter?.complete(dialogResponse);
    _dialogCompleter = null;
  }

  void closeDialogProgress() {
    _closeDialogProgressListener();
  }
}
