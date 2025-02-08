import 'package:intl/intl.dart';

class DatetimeUtils {

  DateTime getFormattedDate(DateTime date) {
    // 현재 날짜를 "yyyy.MM.dd" 형식으로 포맷
    String formattedDate = DateFormat('yyyy.MM.dd').format(date);
    // 포맷된 날짜를 DateTime으로 변환
    DateTime parsedDate = DateFormat('yyyy.MM.dd').parse(formattedDate);

    return parsedDate;
  }
}