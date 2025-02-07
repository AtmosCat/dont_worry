import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';

// HomePage 내 TabBar 위젯
class HomeTabBar extends StatefulWidget {
  final TabController tabController;
  const HomeTabBar(this.tabController, {super.key});

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {
  final int lendCount = 3;
  final int borrowCount = 51;
  /* TODO: loanCount 기능 개발 필요
    - lend/borrow Person이 몇 명인지 Count하여 뷰에 표시해야 함
  */

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      /* AnimatedBuilder 세팅
         TabBar의 위치를 currentIndex로 감지하여
         위치를 50% 이상 넘어갈 경우 View 업데이트
         */
      animation: widget.tabController.animation!,
      builder: (context, child) {
        final double value = widget.tabController.animation!.value;
        final int currentIndex = (value + 0.5).floor();

        return Container(
          color: AppColor.containerWhite.of(context),
          child: TabBar(
            controller: widget.tabController,
            tabs: [
              Tab(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('빌려준 돈',
                        style: TextStyle(
                          color: currentIndex == 0
                              ? AppColor.deepBlack.of(context)
                              : AppColor.disabled.of(context), // TabBar 위치 감지
                        )),
                    SizedBox(width: 5),
                    Text(
                      '$lendCount', //몇 명인지
                      style: TextStyle(
                        color: currentIndex == 0
                            ? AppColor.primaryBlue.of(context)
                            : AppColor.disabled.of(context), // TabBar 위치 감지
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('빌린 돈',
                        style: TextStyle(
                          color: currentIndex == 1
                              ? AppColor.deepBlack.of(context)
                              : AppColor.disabled.of(context), // TabBar 위치 감지
                        )),
                    SizedBox(width: 5),
                    Text(
                      '$borrowCount', //몇 명인지
                      style: TextStyle(
                        color: currentIndex == 1
                            ? AppColor.primaryRed.of(context)
                            : AppColor.disabled.of(context), // TabBar 위치 감지
                      ),
                    ),
                  ],
                ),
              ),
            ],
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal),
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: currentIndex == 0 ? AppColor.primaryBlue.of(context) : AppColor.primaryRed.of(context), // TabBar 위치 감지
          ),
        );
      },
    );
  }
}