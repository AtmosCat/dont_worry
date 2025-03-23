import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';


// 플렉서블 헤더
class HomeFlexibleHeader extends StatelessWidget {
  final TabController _tabController;
  const HomeFlexibleHeader(this._tabController, {super.key});

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
        background: AnimatedBuilder(
            animation: _tabController.animation!,
            builder: (context, child) {
              final double value = _tabController.animation!.value;
              final int currentIndex = (value + 0.5).floor();
              return Container(
                padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                child: Row(
                  children: [
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                currentIndex == 0 ? "내가 받아야 할 금액이" : "내가 갚아야 할 금액이",
                                style: TextStyle(fontSize: 16)),
                            buildRemainingAmountText(currentIndex)
                          ],
                        ),
                      ),
                    ),
                    Center(child: Align( alignment: Alignment(0, -0.2),
                      child: Image.asset(currentIndex == 0 ? 'lib/assets/lottie/lend.gif' : 'lib/assets/lottie/borrow.gif', width:120)))
                    // Lottie.asset('lib/assets/lottie/lend.json', width: 160, height: 160)
                  ],
                ),
              );
            }));
  }

  Consumer buildRemainingAmountText(int currentIndex) {
    return Consumer(builder: (context, ref, child) {
      var peopleState = ref.watch(appViewModelProvider).people;
      var remainingAmounts = (currentIndex == 0)
          ? peopleState.map((person) => person.remainingLendAmount)
          : peopleState.map((person) => person.remainingBorrowAmount);
      return Text.rich(TextSpan(
          style: TextStyle(
              color: currentIndex == 0
                  ? AppColor.primaryYellow.of(context)
                  : AppColor.primaryGreen.of(context)),
          children: [
            TextSpan(
                text: NumberUtils.formatWithCommas(remainingAmounts.fold(
                    0, (previousValue, element) => previousValue + element)),
                style: TextStyle(
                    letterSpacing: -0.7,
                    fontSize: 30,
                    fontWeight: FontWeight.w800)),
            TextSpan(
              text: '원 ',
              style: TextStyle(
                  fontSize: 20,
                  color: currentIndex == 0
                      ? AppColor.primaryYellow.of(context)
                      : AppColor.primaryGreen.of(context)),
            ),
            TextSpan(
                text: '남았어요',
                style: TextStyle(
                    fontSize: 16, color: AppColor.defaultBlack.of(context)))
          ]));
    });
  }
}
