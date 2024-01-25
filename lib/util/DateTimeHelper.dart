import 'package:intl/intl.dart';

class DateTimeHelper {
  static DateTime format() {
    final now = DateTime.now();
    final dateFormat = DateFormat("y/M/d");
    const timeSpecific = "16:25:00";
    final completeFormat = DateFormat("y/M/d H:m:s");

    final todayDate = dateFormat.format(now);
    final todayDateTime = "$todayDate $timeSpecific";
    var resultToday = completeFormat.parseStrict(todayDateTime);

    var formatted = resultToday.add(const Duration(days: 1));
    final tomorrowDate = dateFormat.format(formatted);
    final tomorrowDateTime = "$tomorrowDate $timeSpecific";
    var resultTomorrow = completeFormat.parseStrict(tomorrowDateTime);

    return now.isAfter(resultToday) ? resultTomorrow : resultToday;
  }
}