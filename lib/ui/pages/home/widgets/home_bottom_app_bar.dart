import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/create_loan/create_loan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBottomAppBar extends StatelessWidget {
  final TabController _tabController;
  const HomeBottomAppBar(this._tabController, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _tabController.animation!,
        builder: (context, child) {
          final double value = _tabController.animation!.value;
          final int currentIndex = (value + 0.5).floor();
          final bool isLending =
              currentIndex == 0 ? true : false;
          return Container(
            decoration: BoxDecoration(
                color: AppColor.containerWhite.of(context),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1), // 그림자 색상
                    blurRadius: 30, // 흐림 정도
                    spreadRadius: 6, // 그림자 크기
                    offset: Offset(0, -4), // ⬆ 위쪽 그림자 (기본은 아래로 가므로 -값)
                  )
                ]),
            child: BottomAppBar(
              padding: EdgeInsets.all(0),
              color: Colors.transparent,
              elevation: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateLoanPage(isLending: isLending),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(height: 0, color: AppColor.divider.of(context)),
                    SizedBox(
                      height: 14,
                    ),
                    Icon(
                      Icons.add,
                      size: 30,
                      color: isLending
                          ? AppColor.primaryBlue.of(context)
                          : AppColor.primaryRed.of(context),
                    ),
                    Text(isLending ? '빌려준 돈 기록' : '빌린 돈 기록'),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void createPerson(
      {required BuildContext context,
      required WidgetRef ref,
      required String name}) async {
    Person newPerson = Person(name: name,
        hasLend: false,
        hasBorrow: false,
        isLendPaidOff: false,
        isBorrowPaidOff: false,
        memo: null,
        personId: null,
        remainingLendAmount: 0,
        remainingBorrowAmount: 0 ,
        repaidLendAmount: 0,
        repaidBorrowAmount: 0,
        upcomingLendDueDate: null,
        upcomingBorrowDueDate: null,
        lastLendRepaidDate: null,
        lastBorrowRepaidDate: null,
        updatedAt: DateTime.now());
    await ref.read(appViewModelProvider.notifier).createPerson(newPerson);
  }
}
