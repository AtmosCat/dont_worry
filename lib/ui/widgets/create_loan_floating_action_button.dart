import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/create_loan/create_loan_page.dart';
import 'package:flutter/material.dart';

class CreateLoanFloatingActionButton extends StatelessWidget {
  const CreateLoanFloatingActionButton(
      {super.key, this.tabController, this.person, this.isLending});

  final TabController? tabController;
  final Person? person;
  final bool? isLending;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: tabController?.animation ?? AlwaysStoppedAnimation(0.0),
        builder: (context, child) {
          bool isLending = this.isLending ?? true;
          if (tabController != null) {
            final double value = tabController!.animation!.value;
            final int currentIndex = (value + 0.5).floor();
            isLending = currentIndex == 0 ? true : false;
          }
          return Row(
            children: [
              Spacer(),
              FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: isLending
                          ? AppColor.primaryBlue.of(context)
                          : AppColor.primaryRed.of(context),
                      width: 1), // 외곽선 추가
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: isLending
                    ? AppColor.primaryBlue.of(context)
                    : AppColor.primaryRed.of(context),
                backgroundColor: AppColor.containerWhite.of(context),
                elevation: 1,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => tabController != null
                          ? CreateLoanPage(isLending: isLending)
                          : CreateLoanPage(
                              isLending: isLending, person: person),
                    ),
                  );
                },
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 6),
                    Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: tabController != null
                                  ? ''
                                  : '${person!.name.characters.take(6).toString()}${person!.name.length > 6 ? "..." : ""}'),
                          TextSpan(text: tabController != null ? '' : '에게 '),
                          TextSpan(text: isLending ? '빌려준 돈 기록' : '빌린 돈 기록')
                        ]),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(width: 2)
            ],
          );
        });
  }
}