import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/widgets/small_repayment_button.dart';
import 'package:dont_worry/ui/widgets/small_repayment_progress_indicator.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class SmallLoanCard extends StatelessWidget {
  final bool isLending;
  final Loan loan;
  final Person person;
  final TextEditingController repaymentAmountController;
  const SmallLoanCard(
      {required this.isLending,
      required this.loan,
      required this.person,
      required this.repaymentAmountController,
      super.key});

  @override
  Widget build(BuildContext context) {
    final String title = loan.title;
    final int remainingAmount = loan.remainingAmount;
    final int initialAmount = loan.initialAmount;
    final int totalRepaymentAmount = initialAmount - loan.remainingAmount;
    final double repaymentRate = totalRepaymentAmount / initialAmount;

    final int dDay = 0;
    final DateTime lastRepaymentDate = DateTime(2025, 2, 7);

    final bool isRepaid = remainingAmount == 0;

    // LoanCard UI
    return Container(
      color: loan.remainingAmount != 0 // 상환여부 따라 배경색 변경
          ? AppColor.containerWhite.of(context)
          : AppColor.containerLightGray20.of(context),
      child: Column(
        children: [
          Column(
            children: [
              Row(
                // 1열 : 제목, 디데이
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleText(title, remainingAmount, context),
                  const Spacer(),
                  dDayText(remainingAmount, lastRepaymentDate, context, dDay),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                // 2열 : 남은 금액, 버튼
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  amountText(loan.remainingAmount, context, totalRepaymentAmount),
                  const Spacer(),
                  SmallRepaymentButton(
                    context: context,
                    isRepaid: isRepaid,
                    loan: loan,
                    person: person,
                    repaymentAmountController: repaymentAmountController,
                  ),
                ],
              ),
              Offstage(
                  // 3열 : 상환 비율 그래프 (0%, 100% 일 땐 숨김처리)
                  offstage:
                      loan.remainingAmount == 0 || repaymentRate == 0 || repaymentRate >= 1,
                  child: SmallRepaymentProgressIndicator(
                      repaymentRate: repaymentRate,
                      initialAmount: initialAmount))
            ],
          ),
          Divider(height: 30, color: AppColor.divider.of(context)),
        ],
      ),
    );
  }

  // 제목
  Text titleText(String title, int amount, BuildContext context) {
    return Text(title,
        style: TextStyle(
            color: amount != 0 // 상환여부 따라 글씨색상 변경
                ? AppColor.defaultBlack.of(context)
                : AppColor.disabled.of(context),
            fontSize: 14));
  }

  // 디데이
  Visibility dDayText(
      int amount, DateTime lastRepaymentDate, BuildContext context, int dDay) {
    return Visibility(
      visible: amount != 0,
      // 상환 완료 시,
      replacement: Text(
          '${lastRepaymentDate.year}.${lastRepaymentDate.month}.${lastRepaymentDate.day} ',
          style: TextStyle(fontSize: 15, color: AppColor.disabled.of(context))),
      // 미상환 시,
      child: Text(
          dDay > 0
              ? 'D-$dDay'
              : dDay == 0
                  ? 'D-day'
                  : '연체 중',
          style: TextStyle(
              fontSize: 11,
              color: dDay > 0
                  ? AppColor.primaryBlue.of(context)
                  : AppColor.primaryRed.of(context),
              fontWeight: FontWeight.bold)),
    );
  }

  // 금액
  Text amountText(int remainingAmount, BuildContext context, int totalRepayment) {
    return Text.rich(
      style: TextStyle(
        color: remainingAmount != 0 // 상환여부 따라 글씨색상 변경
            ? AppColor.defaultBlack.of(context)
            : AppColor.disabled.of(context),
      ),
      TextSpan(
        children: [
          TextSpan(
            text: NumberUtils.formatWithCommas(remainingAmount != 0
                ? remainingAmount
                : totalRepayment), // 상환 여부에 따라 amount 또는 totalRepayment),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.7,
            ),
          ),
          const TextSpan(
            text: ' 원',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
