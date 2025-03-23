import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class LoanDetailSummarySection extends StatelessWidget {
  const LoanDetailSummarySection({
    super.key,
    required this.isLending,
    required this.person,
    required this.title,
    required this.isRepaid,
    required this.memo,
    required this.amount,
  });

  final bool isLending;
  final Person person;
  final String title;
  final bool isRepaid;
  final String memo;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: TextStyle(fontSize: 20)),
            Spacer(),
            // RepaymentButton(isRepaid: isRepaid, loan: ,),
          ],
        ),
        Offstage(
          offstage: memo.isEmpty,
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(memo,
                  style: TextStyle(
                      fontSize: 14, color: AppColor.disabled.of(context))),
            ],
          ),
        ),
        SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: '남은 금액   ',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColor.disabled.of(context))),
                    TextSpan(
                        text: NumberUtils.formatWithCommas(amount),
                        style: TextStyle(
                            letterSpacing: -0.7,
                            color: AppColor.deepBlack.of(context),
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                    TextSpan(text: ' 원', style: TextStyle(fontSize: 20))
                  ]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
