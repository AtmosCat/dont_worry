import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// HomePage 내 TabBar 위젯
class HomeTabBar extends StatefulWidget {
  final TabController tabController;
  const HomeTabBar(this.tabController, {super.key});

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
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
                    Consumer(builder: (context, ref, child) {
                      return Text(
                        ref
                            .watch(appViewModelProvider.select((state) => state
                                .people
                                .where((person) =>
                                    person.hasLend && !person.isLendPaidOff)
                                .toList()))
                            .length
                            .toString(),
                        style: TextStyle(
                          color: currentIndex == 0
                              ? AppColor.primaryBlue.of(context)
                              : AppColor.disabled.of(context), // TabBar 위치 감지
                        ),
                      );
                    })
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
                    Consumer(builder: (context, ref, child) {
                      return Text(
                        ref
                            .watch(appViewModelProvider.select((state) => state
                                .people
                                .where((person) =>
                                    person.hasBorrow && !person.isBorrowPaidOff)
                                .toList()))
                            .length
                            .toString(), //몇 명인지
                        style: TextStyle(
                          color: currentIndex == 1
                              ? AppColor.primaryRed.of(context)
                              : AppColor.disabled.of(context), // TabBar 위치 감지
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal),
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: currentIndex == 0
                ? AppColor.primaryBlue.of(context)
                : AppColor.primaryRed.of(context), // TabBar 위치 감지
          ),
        );
      },
    );
  }
}
