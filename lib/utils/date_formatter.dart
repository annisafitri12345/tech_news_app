import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) return iso;
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(date.toLocal());
  }
}