import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/create_loan/create_loan_page.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';

class HomeBottomAppBar extends StatelessWidget {
  final MyAction myAction;
  const HomeBottomAppBar({
    required this.myAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateLoanPage(),
          ),
        );
      },
      child: BottomAppBar(
        color: AppColor.containerWhite.of(context),
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: myAction == MyAction.lend
                      ? AppColor.primaryBlue.of(context)
                      : AppColor.primaryRed.of(context),
                ),
            ),
            Expanded(
              child: Text(
                myAction == MyAction.lend ? '빌려준 돈 기록' : '빌린 돈 기록',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// myAction == MyAction.lend ?AppColor.containerBlue30.of(context):AppColor.containerRed30.of(context)
