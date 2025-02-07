import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/theme/theme.dart';
import 'package:dont_worry/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Binding 초기화
  // WidgetsFlutterBinding.ensureInitialized();
  // 네비게이션 바를 투명하게 설정
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // 하단 네비게이션 바 배경 투명
    systemNavigationBarIconBrightness: Brightness.dark, // 아이콘 색상 조절
  ));


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode;
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
