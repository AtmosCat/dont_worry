import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';

// 플렉서블 헤더
class HomeFlexibleHeader extends StatelessWidget {
  final TabController tabController;
  const HomeFlexibleHeader(this.tabController,{super.key});

  @override
  Widget build(BuildContext context) {
    Color getColor(String colorName) {
      final theme = Theme.of(context).extension<MyColor>();
      return theme?.getColor(colorName) ?? Colors.transparent;  // null일 경우 fallback 값 지정
    }

    return FlexibleSpaceBar(
        background: Padding(
        padding: EdgeInsets.only(top: 50),
      child: AnimatedBuilder(
          animation: tabController.animation!,
          builder: (context, child) {
            final double value = tabController.animation!.value;
            final int currentIndex = (value + 0.5).floor();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(currentIndex == 0 ? "내가 받아야 할 금액" : "내가 갚아야 할 금액",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                Text("30,000,000원",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: currentIndex == 0 ? getColor('primaryBlue') : getColor('primaryRed'))),
              ],
            );
          }),
    ));
  }
}