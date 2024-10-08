import 'package:intl/intl.dart';

// For develompment purpose
String dateNow = DateTime.now().toIso8601String();

// Currency Formatter
class DateFormatter {
  // This class is not meant to be instatiated or extended; this constructor
  // prevents instantiation and extension.
  // ignore: unused_element
  DateFormatter._();

  static String normal(String iso8601String) {
    return DateFormat('d MMMM y').format(
      DateTime.parse(iso8601String),
    );
  }

  static String normalWithClock(String iso8601String) {
    return DateFormat('d MMMM y • HH:mm').format(
      DateTime.parse(iso8601String),
    );
  }

  static String detailed(String iso8601String) {
    return DateFormat('EEEE, d MMMM y').format(
      DateTime.parse(iso8601String),
    );
  }

  static String detailedWithClock(String iso8601String) {
    return DateFormat('EEEE, d MMMM y • HH:mm').format(
      DateTime.parse(iso8601String),
    );
  }

  static String dayShorted(String iso8601String) {
    return DateFormat('EEE, d MMMM y').format(
      DateTime.parse(iso8601String),
    );
  }

  static String slashDate(String iso8601String) {
    return DateFormat('dd/MM/y').format(
      DateTime.parse(iso8601String),
    );
  }

  static String slashDateWithClock(String iso8601String) {
    return DateFormat('dd/MM/y • HH:mm').format(
      DateTime.parse(iso8601String),
    );
  }

  static String slashDateShortedYearWithClock(String iso8601String) {
    return DateFormat('dd/MM/yy • HH:mm').format(
      DateTime.parse(iso8601String),
    );
  }

  static String onlyDate(String iso8601String) {
    return DateFormat('d').format(
      DateTime.parse(iso8601String),
    );
  }

  static String onlyDateWithZero(String iso8601String) {
    return DateFormat('dd').format(
      DateTime.parse(iso8601String),
    );
  }

  static String onlyDayShorted(String iso8601String) {
    return DateFormat('EEE').format(
      DateTime.parse(iso8601String),
    );
  }

  static String onlyClockWithDivider(String iso8601String) {
    return DateFormat('HH:mm').format(
      DateTime.parse(iso8601String),
    );
  }

  static String onlyClockWithoutDivider(String iso8601String) {
    return DateFormat('HHmm').format(
      DateTime.parse(iso8601String),
    );
  }

  static String stripDateWithClock(String iso8601String) {
    return DateFormat('dd-MM-yyyy • HH:mm').format(
      DateTime.parse(iso8601String),
    );
  }

  static String stripDate(String iso8601String) {
    return DateFormat('yyyy-MM-dd').format(
      DateTime.parse(iso8601String),
    );
  }

  static String onlyHour(String iso8601String) {
    return DateFormat('H').format(
      DateTime.parse(iso8601String),
    );
  }

  static String onlyMinute(String iso8601String) {
    return DateFormat('m').format(
      DateTime.parse(iso8601String),
    );
  }
}
