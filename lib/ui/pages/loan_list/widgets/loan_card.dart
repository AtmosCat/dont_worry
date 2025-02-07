import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/loan_detail/loan_detail_page.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class LoanCard extends StatelessWidget {
  final MyAction myAction;
  final title = '저녁 식사 대신 내준 돈';
  const LoanCard({required this.myAction, super.key});

  final int amount = 145603000;
  final int totalRepayment = 100000;
  final double repaymentRate = 0.5;
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoanDetailPage(myAction),
        ),
      ),
      child: Container(
        color: AppColor.containerWhite.of(context),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        'D-30',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColor.primaryBlue.of(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: NumberUtils.formatWithCommas(amount),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.7,
                              ),
                            ),
                            const TextSpan(
                              text: ' 원',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.task_alt, size: 18),
                        label: const Text(
                          '상환',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        iconAlignment: IconAlignment.end,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          alignment: Alignment.center,
                          backgroundColor: AppColor.primaryBlue.of(context),
                          foregroundColor: AppColor.onPrimaryWhite.of(context),
                          iconColor: AppColor.onPrimaryWhite.of(context),
                        ),
                      ),
                    ],
                  ),
                  Offstage(
                      offstage: amount == 0 || repaymentRate == 1,
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          LinearProgressIndicator(
                            value: repaymentRate,
                            minHeight: 4,
                            borderRadius: BorderRadius.circular(20),
                            color: AppColor.primaryBlue.of(context),
                            backgroundColor: AppColor.lightGray20.of(context),
                          ),
                          SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.gray20.of(context),
                              ),
                              children: [
                                TextSpan(text: '원금 '),
                                TextSpan(
                                    text:
                                        '${NumberUtils.formatWithCommas(totalRepayment)}원',
                                    style: TextStyle(
                                        color: AppColor.gray30.of(context),
                                        fontWeight: FontWeight.bold)),
                                TextSpan(text: '의 '),
                                TextSpan(
                                    text: '${(repaymentRate * 100).round()}%',
                                    style: TextStyle(
                                        color: AppColor.primaryBlue.of(context),
                                        fontWeight: FontWeight.bold)),
                                TextSpan(text: '를 받았어요!'),
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            const Divider(height: 0, thickness: 0.6),
          ],
        ),
      ),
    );
  }
}
