import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

// 플렉서블 헤더
class HomeFlexibleHeader extends StatelessWidget {
  final TabController tabController;
  const HomeFlexibleHeader(this.tabController, {super.key});

  @override
  Widget build(BuildContext context) {
    Color getColor(String colorName) {
      final theme = Theme.of(context).extension<MyColor>();
      return theme?.getColor(colorName) ??
          Colors.transparent; // null일 경우 fallback 값 지정
    }

    int totalLendAmount = 3000000;
    int totalBorrowedAmount = 3000;

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
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(NumberUtils.formatWithCommas(
                      currentIndex == 0
                                ? totalLendAmount
                                : totalBorrowedAmount
                      ),
                        style: TextStyle(
                            letterSpacing: -0.7,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: currentIndex == 0
                                ? getColor('primaryBlue')
                                : getColor('primaryRed'))),
                    Text(
                      '원',
                      style: TextStyle(
                          fontSize: 24,
                          color: currentIndex == 0
                              ? getColor('primaryBlue')
                              : getColor('primaryRed')),
                    )
                  ],
                ),
              ],
            );
          }),
    ));
  }
}
