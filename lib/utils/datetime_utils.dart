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
      initialDate: DateTime.now(), // 초기 날짜
      firstDate: DateTime(2000), // 가장 이른 날짜
      lastDate: DateTime(2100), // 가장 늦은 날짜
      helpText: '날짜를 선택하세요', // 팝업 상단의 안내 문구
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked; // 선택된 날짜 업데이트
    }
    return getFormattedDate(selectedDate);
  }
}
