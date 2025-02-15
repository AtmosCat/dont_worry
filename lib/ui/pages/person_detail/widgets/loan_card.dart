import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/loan_detail/loan_detail_page.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/ui/widgets/repayment_button.dart';
import 'package:dont_worry/ui/widgets/repayment_progress_indicator.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class LoanCard extends StatelessWidget {
  final MyAction myAction;
  final Loan loan;
  final Person person;
  const LoanCard({required this.myAction, required this.loan, required this.person, super.key});

  @override
  Widget build(BuildContext context) {
    final String title = loan.title;
    final int amount = 100;
    final int initialAmount = loan.initialAmount;
    final int totalRepayment = initialAmount - amount;
    final double repaymentRate = totalRepayment/initialAmount;

    final int dDay = 0;
    final DateTime lastRepaymentDate = DateTime(2025, 2, 7);

    final bool isRepaid = amount == 0;

    // LoanCard UI
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoanDetailPage(myAction, loan: loan, person: person,),
        ),
      ),
      child: Container(
        color: amount != 0 // 상환여부 따라 배경색 변경
            ? AppColor.containerWhite.of(context)
            : AppColor.containerLightGray20.of(context),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                children: [
                  Row(
                    // 1열 : 제목, 디데이
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      titleText(title, amount, context),
                      const Spacer(),
                      dDayText(amount, lastRepaymentDate, context, dDay),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    // 2열 : 남은 금액, 버튼
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      amountText(amount, context, totalRepayment),
                      const Spacer(),
                      RepaymentButton(isRepaid: isRepaid, loan: loan, person: person,),
                    ],
                  ),
                  Offstage(
                      // 3열 : 상환 비율 그래프 (0%, 100% 일 땐 숨김처리)
                      offstage: amount == 0 ||
                          repaymentRate == 0 ||
                          repaymentRate >= 1,
                      child: RepaymentProgressIndicator(
                          repaymentRate: repaymentRate,
                          initialAmount: initialAmount))
                ],
              ),
            ),
            Divider(height: 0, color: AppColor.divider.of(context)),
          ],
        ),
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
            fontSize: 16));
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
              fontSize: 13,
              color: dDay > 0
                  ? AppColor.primaryBlue.of(context)
                  : AppColor.primaryRed.of(context),
              fontWeight: FontWeight.bold)),
    );
  }

  // 금액
  Text amountText(int amount, BuildContext context, int totalRepayment) {
    return Text.rich(
      style: TextStyle(
        color: amount != 0 // 상환여부 따라 글씨색상 변경
            ? AppColor.defaultBlack.of(context)
            : AppColor.disabled.of(context),
      ),
      TextSpan(
        children: [
          TextSpan(
            text: NumberUtils.formatWithCommas(amount != 0
                ? amount
                : totalRepayment), // 상환 여부에 따라 amount 또는 totalRepayment),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.7,
            ),
          ),
          const TextSpan(
            text: ' 원',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}



        /*TODO: 금액 관련 데이터를 구하는 로직 개발 필요
    
    개발사항 1. amount :갚아야 할 남은 금액
      loan의 잔여대출액 remainingLoanAmount()

    개발사항 2. totalRepayment : 이미 갚은 금액
      loan의 상환액 총합
    
    개발사항 3. repaymentRate : 상환한 금액의 비율

    활용1. LoanCard 좌하단에 금액 노출.
      미상환 시, 갚아야 할 amount 노출
      전액상환 시, 그동안 갚은 totalRepayment 노출
    활용2. 일부금액 상환 시, LinearProgressIndicator에 비율 노출
      repaymentRate를 활용하여 그래프와 상환비율 %표현
      그동안 갚은 totalRepayment 노출

    주의. 재사용할 가능성이 있습니다.
    가급적 Loan 클래스 내에서 메서드로 구현해주세요.
    */


    /*TODO: 날짜 관련 데이터 구하는 로직 개발 필요

    개발사항 1. dDay : 변제일
      loan의 변제일
    개발사항 2. lastRepaymentDate : 가장 최근에 상환한 날짜
      loan의 repayment의 date 중 가장 늦은 날짜

    활용. LoanCard 우상단에 디데이, 날짜 노출
      미상환 시, dDay 노출
      전액상환 시, 마지막 상환일 lastRepaymentDate 노출

    주의. 재사용할 가능성이 있습니다.
    가급적 Loan 클래스 내에서 메서드로 구현해주세요.
    */