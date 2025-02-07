import 'package:flutter/material.dart';

@immutable
class MyColor extends ThemeExtension<MyColor> {
  final Map<String, Color> colors;

  const MyColor({
    required this.colors,
  });

  // 색상 값을 직접 변경할 수 있도록 copyWith 메서드 작성
  @override
  MyColor copyWith({
    Map<String, Color>? colors,
  }) {
    return MyColor(
      colors: colors ?? this.colors,
    );
  }

  // 색상 값들에 대해 lerp 메서드를 작성
  @override
  MyColor lerp(ThemeExtension<MyColor>? other, double t) {
    if (other is! MyColor) {
      return this;
    }

    final Map<String, Color> lerpedColors = {};

    colors.forEach((key, value) {
      lerpedColors[key] = Color.lerp(value, other.colors[key], t)!;
    });

    return MyColor(
      colors: lerpedColors,
    );
  }

  // 색상값 가져오기
  Color getColor(String key) => colors[key] ?? Colors.transparent;
}

class AppColors {
  static final lightColorScheme = MyColor(
    colors: {
      'primaryBlue': Color(0xFF007AFF),
      'primaryRed': Color(0xFFF2616A),
      'onPrimaryWhite': Colors.white,
      'backgroundWhite': Colors.white,
      'black': Colors.black,
      'deactivatedGrey': Colors.grey,
      'myNewColor': Colors.orange,
    },
  );

  static final darkColorScheme = MyColor(
    colors: {
      'primaryBlue': Color(0xFF7CA7D5),
      'primaryRed': Color(0xFFDD7980),
      'onPrimaryWhite': Colors.white,
      'backgroundWhite': Color(0xFF1E1E1E),
      'black': Colors.white,
      'deactivatedGrey': Colors.grey,
      'myNewColor': Colors.deepOrange,
    },
  );
}
