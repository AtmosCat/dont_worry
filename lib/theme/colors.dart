import 'package:flutter/material.dart';

enum AppColor {
  //primary
  primaryBlue, 
  primaryRed,
  onPrimaryWhite,
  shadowBlack,
  divider,
  //background
  containerWhite,
  scaffoldGray,
  containerGray30,
  containerGray20,
  containerGray10,
  containerLightGray30,
  containerLightGray20,
  containerLightGray10,
  containerRed30,
  containerRed20,
  containerRed10,
  containerBlue30,
  containerBlue20,
  containerBlue10,
  //contents
  defaultBlack,
  deepBlack,
  disabled,
  gray30,
  gray20,
  gray10,
  lightGray30,
  lightGray20,
  lightGray10,
}

class AppColors {
  static final lightColorScheme = MyColor(
    colors: {
      
      // primary 주요색상 (강조, 버튼 등에 활용)
      AppColor.primaryBlue: Color(0xFF007AFF), // 중요한 블루
      AppColor.primaryRed: Color(0xFFF2616A), // 중요한 레드
      AppColor.onPrimaryWhite: Colors.white, // 컬러배경 위에서 쓰이는 흰색 : 다크모드에서도 화이트 유지됨
      AppColor.shadowBlack: Color(0xFF000000), // 그림자로 쓰이는 검정 : 다크모드에서도 유지됨
      AppColor.divider: Colors.grey.withOpacity(0.2),// 디바이더

      // background 컬러 (배경, 흰색 컨테이너 배경, 회색박스 등에 사용)
      AppColor.scaffoldGray: Color(0xFFF1F1F1), // 맨 뒷배경용 회색 
      AppColor.containerWhite: Colors.white, // 컨테이너 배경용 흰색
      AppColor.containerGray30: Color(0xFFAAAAAA), // 회색 10-30 
      AppColor.containerGray20: Color(0xFFCCCCCC), 
      AppColor.containerGray10: Color(0xFFEEEEEE), 
      AppColor.containerLightGray30: Color(0xFFF7F7F7), // 연회색 10-30
      AppColor.containerLightGray20: Color(0xFFF9F9F9), 
      AppColor.containerLightGray10: Color(0xFFFBFBFB), 
      AppColor.containerRed30: Color(0xFFE8878E), // 레드 10-30 (강조, 경고, 손해 등)
      AppColor.containerRed20: Color(0xFFF1B1B9),  
      AppColor.containerRed10: Color(0xFFF9E0E5), 
      AppColor.containerBlue30: Color(0xFF89AEE6), // 블루 10-30 (강조, 활성화 버튼, 이익 등)
      AppColor.containerBlue20: Color(0xFFB1D4F2), 
      AppColor.containerBlue10: Color(0xFFE0F0FF), 

      // contents 컬러 (text, icon 등에서 사용)
      AppColor.defaultBlack: Color(0xFF333333), // 검정색 기본값
      AppColor.deepBlack: Color(0xFF111111), // 진한 검정색 : 글씨를 진하게 쓰고 싶을 때
      AppColor.disabled: Color(0xFF999999), // 비활성화, 취소를 표현
      AppColor.gray30: Color(0xFF555555), // 회색 10-30
      AppColor.gray20: Color(0xFF777777),
      AppColor.gray10: Color(0xFF999999),
      AppColor.lightGray30: Color(0xFFAAAAAA), // 연회색 10-30 (배경용으로 사용금지)
      AppColor.lightGray20: Color(0xFFCCCCCC),
      AppColor.lightGray10: Color(0xFFEEEEEE), 
    },
  );

  static final darkColorScheme = MyColor(
    colors: {
      AppColor.primaryBlue: Color(0xFF7CA7D5),
      AppColor.primaryRed: Color(0xFFDD7980),
      AppColor.onPrimaryWhite: Colors.white,
      AppColor.shadowBlack: Color(0xFF000000),
      AppColor.divider: Colors.white.withOpacity(0.2),// 디바이더

      AppColor.scaffoldGray: Color(0xFF121212),
      AppColor.containerWhite: Color(0xFF1E1E1E),
      AppColor.containerGray30: Color(0xFF555555),
      AppColor.containerGray20: Color(0xFF777777),
      AppColor.containerGray10: Color(0xFF999999),
      AppColor.containerLightGray30: Color(0xFF1E1E1E),
      AppColor.containerLightGray20: Color(0xFF333333),
      AppColor.containerLightGray10: Color(0xFF555555),
      AppColor.containerRed30: Color(0xFF7A5053),
      AppColor.containerRed20: Color(0xFFB77073),
      AppColor.containerRed10: Color(0xFFDC8A91),
      AppColor.containerBlue30: Color(0xFF406D92),
      AppColor.containerBlue20: Color(0xFF6B98C5),
      AppColor.containerBlue10: Color(0xFF9AB8E2),

      AppColor.defaultBlack: Color(0xFFDDDDDD),
      AppColor.deepBlack: Colors.white,
      AppColor.disabled: Color(0xFF555555),
      AppColor.gray30: Color(0xFF888888),
      AppColor.gray20: Color(0xFFAAAAAA),
      AppColor.gray10: Color(0xFFCCCCCC),
      AppColor.lightGray30: Color(0xFF555555),
      AppColor.lightGray20: Color(0xFF777777),
      AppColor.lightGray10: Color(0xFF999999),
    },
  );
}


@immutable
class MyColor extends ThemeExtension<MyColor> {
  final Map<AppColor, Color> colors;

  const MyColor({required this.colors});

  @override
  MyColor copyWith({Map<AppColor, Color>? colors}) {
    return MyColor(colors: colors ?? this.colors);
  }

  @override
  MyColor lerp(ThemeExtension<MyColor>? other, double t) {
    if (other is! MyColor) return this;

    final Map<AppColor, Color> lerpedColors = {};
    for (var key in colors.keys) {
      lerpedColors[key] = Color.lerp(colors[key], other.colors[key], t)!;
    }
    return MyColor(colors: lerpedColors);
  }

  Color getColor(AppColor key) => colors[key] ?? Colors.transparent;
}

// ✅ AppColor 확장(extension) 추가 -> context 없이 바로 사용 가능!
extension AppColorExtension on AppColor {
  Color of(BuildContext context) {
    final theme = Theme.of(context).extension<MyColor>();
    return theme?.getColor(this) ?? Colors.transparent;
  }
}