import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/ui/widgets/detail_bottom_navigation_bar.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class LoanDetailPage extends StatelessWidget {
  final MyAction myAction;
  final Loan loan;
  const LoanDetailPage(this.myAction, {required this.loan, super.key});

  @override
  Widget build(BuildContext context) {
    final String title = loan.title;
    // final String memo = '';
    final String memo = loan.memo ?? '';

    final int amount = 100;
    final int initialAmount = loan.initialAmount;
    final int totalRepayment = 10000;
    final double repaymentRate = 0.1;
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

    final int dDay = -1;
    final DateTime loanDate = loan.loanDate;
    final DateTime? dueDate = loan.dueDate;
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

    return Scaffold(
      backgroundColor: AppColor.containerWhite.of(context),
      appBar: DetailAppBar(myAction, Category.loan),
      bottomNavigationBar: DetailBottomNavigationBar(
          myAction: myAction, category: Category.loan),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            color: AppColor.containerWhite.of(context),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(title, style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Visibility(
                    visible: amount != 0,
                    // 상환 완료 시,
                    replacement: TextButton(
                      onPressed: () {},
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
                        backgroundColor: AppColor.containerGray20.of(context),
                        foregroundColor: AppColor.onPrimaryWhite.of(context),
                      ),
                      child: Text('상환 완료',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ),

                    // 미상환 시,
                    child: TextButton.icon(
                      onPressed: () {
                        /* TODO: 해당 Loan을 전액 상환하는 로직 개발 필요 */
                      },
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
                  ),
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
                  Text('남은 금액',
                      style: TextStyle(
                          fontSize: 16, color: AppColor.disabled.of(context))),
                  SizedBox(width: 14),
                  Text(
                    NumberUtils.formatWithCommas(amount),
                    style: TextStyle(
                        letterSpacing: -0.7,
                        color: AppColor.deepBlack.of(context),
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '원',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Divider(height: 0, thickness: 0.6),
              SizedBox(height: 40),
              Row(children: [
                Text('전체 금액',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColor.gray20.of(context),
                        fontWeight: FontWeight.w600)),
                Spacer(),
                Text('${NumberUtils.formatWithCommas(initialAmount)}원',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColor.gray20.of(context),
                        fontWeight: FontWeight.w800))
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text(myAction == MyAction.lend ? '빌린 사람' : '빌려준 사람',
                    style: TextStyle(
                        fontSize: 16, color: AppColor.gray10.of(context))),
                Spacer(),
                Text('김철수선생님Andradgfasg()',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColor.gray20.of(context),
                        fontWeight: FontWeight.w600))
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text(myAction == MyAction.lend ? '빌린 날짜' : '빌려준 날짜',
                    style: TextStyle(
                        fontSize: 16, color: AppColor.gray10.of(context))),
                Spacer(),
                Text('${loanDate.year}년 ${loanDate.month}월 ${loanDate.day}일',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColor.gray20.of(context),
                        fontWeight: FontWeight.w600))
              ]),
              SizedBox(height: 10),
              Offstage(
                offstage: dueDate == null,
                child: Row(children: [
                  Text('갚기로 한 날',
                      style: TextStyle(
                          fontSize: 16, color: AppColor.gray10.of(context))),
                  Spacer(),
                  Text(
                      dueDate != null
                          ? '${dueDate.year}년 ${dueDate.month}월 ${dueDate.day}일'
                          : '미정',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColor.gray20.of(context),
                          fontWeight: FontWeight.w600))
                ]),
              ),
              SizedBox(height: 40),
              Offstage(
                offstage: dueDate == null || amount == 0,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Center(
                    child: Text.rich(TextSpan(
                        style: TextStyle(
                            fontSize: 16, color: AppColor.gray20.of(context)),
                        children: [
                          TextSpan(
                              text: dDay > 0
                                  ? '갚기로 한 날까지 '
                                  : dDay == 0
                                      ? '갚기로 한 날이 '
                                      : '갚기로 한 날로부터 '),
                          TextSpan(
                              text: dDay > 0
                                  ? '${dDay}일'
                                  : dDay == 0
                                      ? '오늘'
                                      : '${-dDay}일',
                              style: TextStyle(
                                  color: dDay > 0
                                      ? AppColor.primaryBlue.of(context)
                                      : AppColor.primaryRed.of(context),
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: dDay > 0
                                  ? ' 남았어요'
                                  : dDay == 0
                                      ? '이예요'
                                      : ' 지났어요'),
                        ])),
                  ),
                ),
              ),
              Offstage(
                offstage: repaymentRate == 0,
                child: Column(
                  children: [
                    Divider(),
                    SizedBox(height: 24),
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
                              text:
                                  '${NumberUtils.formatWithCommas(totalRepayment)}원',
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
                                fontSize: 16,
                                color: AppColor.gray10.of(context))),
                      ],
                    ),
                    SizedBox(height: 30),
                    RepaymentCard(
                      repayment:
                          Repayment(amount: 300000, date: DateTime(2024, 2, 1)),
                    ),
                    RepaymentCard(
                      repayment: Repayment(
                          amount: 2020000, date: DateTime(2024, 3, 2)),
                    ),
                    RepaymentCard(
                      repayment:
                          Repayment(amount: 4000, date: DateTime(2024, 4, 21)),
                    ),
                    RepaymentCard(
                      repayment:
                          Repayment(amount: 100, date: DateTime(2024, 4, 12)),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class RepaymentCard extends StatelessWidget {
  final Repayment repayment;
  const RepaymentCard({
    required this.repayment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 20, right: 6),
          color: AppColor.containerLightGray30.of(context),
          child: Row(children: [
            Text(
              '${repayment.date.year}.${repayment.date.month}.${repayment.date.day}',
              style: TextStyle(
                color: AppColor.gray20.of(context),
              ),
            ),
            Spacer(),
            Text('${NumberUtils.formatWithCommas(repayment.amount)}원',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColor.gray20.of(context),
                    fontWeight: FontWeight.bold)),
            IconButton(onPressed: () {}, icon: Icon(Icons.close))
          ]),
        ),
        SizedBox(
          height: 2,
        ),
      ],
    );
  }
}
