import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF007AFF);

final ThemeData lightTheme = ThemeData(
  // 기본 색상 설정
  primaryColor: primaryBlue,
  scaffoldBackgroundColor: Color(0xFFF1F1F1),  // 부드러운 밝은 배경색

  // 앱 바 설정
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    scrolledUnderElevation: 0,
  ),

  // 바텀시트 설정
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(40),
      ),
    ),
  ),

  // 플로팅 액션 버튼 설정
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: CircleBorder(),
    sizeConstraints: BoxConstraints(
      minWidth: 70.0,
      minHeight: 70.0,
    ),
    iconSize: 30,
    backgroundColor: primaryBlue, // 파란색 배경
    foregroundColor: Colors.white, // 하얀색 아이콘 및 글씨
  ),

  // 텍스트 관련 설정
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF333333)),  // 어두운 회색 텍스트
    bodyLarge: TextStyle(color: Color(0xFF333333)),  // 어두운 회색 텍스트
    bodySmall: TextStyle(color: Color(0xFF555555)),  // 조금 더 연한 회색
  ),

  // 아이콘 색상 설정
  iconTheme: IconThemeData(
    color: Color(0xFF333333),  // 어두운 회색 아이콘
  ),

  // 아이콘 버튼 설정
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF333333)),  // 어두운 회색
    ),
  ),

  // 리스트타일 설정
  listTileTheme: ListTileThemeData(
    iconColor: Color(0xFF333333),
    textColor: Color(0xFF333333),
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: primaryBlue,
  scaffoldBackgroundColor: Color(0xFF121212),  // 다크 배경

  // 앱 바 설정
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    scrolledUnderElevation: 0,
  ),

  // 바텀시트 설정
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(40),
      ),
    ),
  ),

  // 플로팅 액션 버튼 설정
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: CircleBorder(),
    sizeConstraints: BoxConstraints(
      minWidth: 70.0,
      minHeight: 70.0,
    ),
    iconSize: 30,
    backgroundColor: primaryBlue, // 파란색 배경
    foregroundColor: Colors.white, // 하얀색 아이콘 및 글씨
  ),

  // 텍스트 관련 설정
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Color(0xFFDDDDDD)),  // 부드러운 흰색 텍스트
    bodyLarge: TextStyle(color: Color(0xFFDDDDDD)),  // 부드러운 흰색 텍스트
    bodySmall: TextStyle(color: Color(0xFFBBBBBB)),  // 밝은 회색 텍스트
  ),

  // 아이콘 색상 설정
  iconTheme: IconThemeData(
    color: Color(0xFFDDDDDD),  // 부드러운 흰색 아이콘
  ),

  // 아이콘 버튼 설정
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFDDDDDD)),  // 부드러운 흰색
    ),
  ),

  // 리스트타일 설정
  listTileTheme: ListTileThemeData(
    iconColor: Color(0xFFDDDDDD),
    textColor: Color(0xFFDDDDDD),
  ),
);
