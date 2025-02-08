import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/theme/theme.dart';
import 'package:dont_worry/ui/pages/create_loan/create_loan_page.dart';
import 'package:dont_worry/ui/pages/home/home_page.dart';
import 'package:dont_worry/ui/pages/signin/signin_page.dart';
import 'package:dont_worry/ui/pages/signup/signup_page.dart';
import 'package:dont_worry/ui/test_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Binding 초기화
  // WidgetsFlutterBinding.ensureInitialized();
  // 네비게이션 바를 투명하게 설정
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // 하단 네비게이션 바 배경 투명
    systemNavigationBarIconBrightness: Brightness.dark, // 아이콘 색상 조절`
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
  await TestRepository().getAll(); // Firestore 데이터 가져오기

  runApp(
    ProviderScope(
      child: (MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode;
    return MaterialApp(
      home: SigninPage(),
      // home: HomePage(),
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
