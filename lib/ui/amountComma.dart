import 'package:intl/intl.dart';

final format = NumberFormat.decimalPattern('en_IN'); // Indian style commas

String formatNumber(dynamic number) {
  if (number == null) return "0";
  try {
    return format.format(double.parse(number.toString()));
  } catch (e) {
    return number.toString(); // fallback if invalid
  }
}
