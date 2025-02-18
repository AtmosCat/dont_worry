import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatetimeUtils {
  static DateTime getFormattedDate(DateTime date) {
    // 현재 날짜를 "yyyy.MM.dd" 형식으로 포맷
    String formattedDate = DateFormat('yyyy.MM.dd').format(date);
    // 포맷된 날짜를 DateTime으로 변환
    DateTime parsedDate = DateFormat('yyyy.MM.dd').parse(formattedDate);

    return parsedDate;
  }

  // DatePicker 호출 함수
  static Future<DateTime?> selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: '날짜를 선택하세요',
      // locale: const Locale('ko', 'KR'), 
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColor.primaryBlue.of(context), // 주요 색상 (선택 사항)
            colorScheme: ColorScheme.light(primary: AppColor.primaryBlue.of(context)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
    return selectedDate; 
  }
}
