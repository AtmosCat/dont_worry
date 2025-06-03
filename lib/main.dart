import 'package:dont_worry/data/repository/sql_database.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/theme/theme.dart';
import 'package:dont_worry/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  // 네비게이션 바를 투명하게 설정
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // 하단 네비게이션 바 배경 투명
    systemNavigationBarIconBrightness: Brightness.dark, // 아이콘 색상 조절
  ));

  // SQL 사용을 위한 세팅
  WidgetsFlutterBinding.ensureInitialized();
  SqlDatabase();
  debugPaintSizeEnabled = false;
  MobileAds.instance.initialize(); // 초기화 코드 필수
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode;
    return MaterialApp(
      locale: Locale('ko', 'KR'), // 한국어 설정
      supportedLocales: [
        Locale('ko', 'KR'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
