import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/theme/theme.dart';
import 'package:dont_worry/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: lightTheme.copyWith(
        extensions: [AppColors.lightColorScheme],
      ), // 기본 라이트 테마
      darkTheme: darkTheme.copyWith(
        extensions: [AppColors.darkColorScheme],
      ), // 다크 테마
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}