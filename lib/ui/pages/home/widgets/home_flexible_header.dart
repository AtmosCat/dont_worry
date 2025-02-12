import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

// 플렉서블 헤더
class HomeFlexibleHeader extends StatelessWidget {
  final TabController _tabController;
  const HomeFlexibleHeader(this._tabController, {super.key});

  @override
  Widget build(BuildContext context) {
    int totalLendAmount = 30000;
    int totalBorrowedAmount = 3000000;

    return FlexibleSpaceBar(
        background: AnimatedBuilder(
            animation: _tabController.animation!,
            builder: (context, child) {
              final double value = _tabController.animation!.value;
              final int currentIndex = (value + 0.5).floor();
              return Container(
                padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentIndex == 0
                        ? "내가 받아야 할 금액이"
                        : "내가 갚아야 할 금액이",
                            style: TextStyle(fontSize: 18)),
                        Text.rich(TextSpan(
                            style: TextStyle(
                                color: currentIndex == 0
                                    ? AppColor.primaryBlue.of(context)
                                    : AppColor.primaryRed.of(context)),
                            children: [
                              TextSpan(
                                  text: NumberUtils.formatWithCommas(
                                      currentIndex == 0
                                          ? totalLendAmount
                                          : totalBorrowedAmount),
                                  style: TextStyle(
                                      letterSpacing: -0.7,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800)),
                              TextSpan(
                                text: '원',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: currentIndex == 0
                                        ? AppColor.primaryBlue.of(context)
                                        : AppColor.primaryRed.of(context)),
                              ),
                              TextSpan(
                                  text: ' 남았어요',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColor.defaultBlack.of(context)))
                            ])),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.payments, size: 70,color: Colors.green,) //이미지 추가 예정
                  ],
                ),
              );
            }));
  }
}
