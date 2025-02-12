import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/loan_detail/widgets/repayment_card.dart';
import 'package:dont_worry/ui/widgets/common_detail_app_bar.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class LoanDetailRepaymentSection extends StatelessWidget {
  LoanDetailRepaymentSection({
    super.key,
    required this.myAction,
    required this.totalRepayment,
    required this.initialAmount,
    required this.repaymentRate,
  });

  final MyAction myAction;
  final int totalRepayment;
  final int initialAmount;
  final double repaymentRate;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: totalRepayment != 0,
      replacement: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error),
          SizedBox(width: 10),
          Text('아직 상환한 금액이 없어요',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.gray20.of(context),
                  fontWeight: FontWeight.w600)),
        ],
      ),
      child: Column(
        children: [
          Row(children: [
            Text(myAction == MyAction.lend ? '받은 금액' : '갚은 금액',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColor.gray20.of(context),
                    fontWeight: FontWeight.w600)),
            Spacer(),
            Text('${NumberUtils.formatWithCommas(totalRepayment)}원',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColor.gray20.of(context),
                    fontWeight: FontWeight.w800))
          ]),
          SizedBox(height: 50),
          LinearProgressIndicator(
            value: repaymentRate,
            minHeight: 4,
            borderRadius: BorderRadius.circular(20),
            color: AppColor.primaryBlue.of(context),
            backgroundColor: AppColor.lightGray20.of(context),
          ),
          SizedBox(height: 20),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: AppColor.gray20.of(context),
              ),
              children: [
                TextSpan(text: '원금 '),
                TextSpan(
                    text: '${NumberUtils.formatWithCommas(initialAmount)}원',
                    style: TextStyle(
                        color: AppColor.gray30.of(context),
                        fontWeight: FontWeight.bold)),
                TextSpan(text: repaymentRate != 1 ? '의 ' : '을 '),
                TextSpan(
                    text: repaymentRate != 1
                        ? '${(repaymentRate * 100).round()}%'
                        : '전부',
                    style: TextStyle(
                        color: AppColor.primaryBlue.of(context),
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: myAction == MyAction.lend
                        ? repaymentRate != 1
                            ? '를 받았어요!'
                            : ' 받았어요!'
                        : repaymentRate != 1
                            ? '를 갚았어요!'
                            : ' 갚았어요!'),
              ],
            ),
          ),
          SizedBox(height: 50),
          Row(
            children: [
              Text('상환 내역',
                  style: TextStyle(
                      fontSize: 16, color: AppColor.gray10.of(context))),
            ],
          ),
          SizedBox(height: 30),
          RepaymentCard(repayment: dummyRepayment1),
          RepaymentCard(repayment: dummyRepayment1),
          RepaymentCard(repayment: dummyRepayment1),
          RepaymentCard(repayment: dummyRepayment1),
          SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }

  // 더미 데이터
  final Repayment dummyRepayment1 = Repayment(
      personId: 'test001_person',
      loanId: 'test001_loan',
      repaymentId: 'test001_repayment',
      amount: 300000,
      date: DateTime(2024, 2, 1));
}