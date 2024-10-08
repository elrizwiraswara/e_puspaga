import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

void consoleLog(dynamic text, {String? title, dynamic json}) {
  if (kDebugMode) {
    String jsonPrettier(jsonObject) {
      var encoder = const JsonEncoder.withIndent("     ");
      return encoder.convert(jsonObject);
    }

    var logger = Logger(
      printer: PrettyPrinter(),
    );

    logger.d(
      '${title != null ? ('$title :') : ''}: $text ${json != null ? jsonPrettier(json) : ''}',
    );
  }
}
