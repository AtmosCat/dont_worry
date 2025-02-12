import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/loan_detail/widgets/section/loan_detail_info_section.dart';
import 'package:dont_worry/ui/pages/loan_detail/widgets/section/loan_detail_repayment_section.dart';
import 'package:dont_worry/ui/pages/loan_detail/widgets/section/loan_detail_summary_section.dart';
import 'package:dont_worry/ui/widgets/common_detail_app_bar.dart';
import 'package:dont_worry/ui/widgets/common_detail_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class LoanDetailPage extends StatelessWidget {
  final MyAction myAction;
  final Loan loan;
  const LoanDetailPage(this.myAction, {required this.loan, super.key});

  @override
  Widget build(BuildContext context) {
    final String title = loan.title;
    final String memo = loan.memo ?? '';

    final int amount = 100;
    final int initialAmount = loan.initialAmount;
    final int totalRepayment = 1;
    final double repaymentRate = 0.2;

    final int dDay = -1;
    final DateTime loanDate = loan.loanDate;
    final DateTime? dueDate = loan.dueDate;

    final String name = '김철수';
    final bool isRepaid = amount == 0;

    // LoanDetailPage UI
    return Scaffold(
      backgroundColor: AppColor.containerWhite.of(context),
      // #1. 상단 앱바
      appBar: CommonDetailAppBar(myAction, Category.loan),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            color: AppColor.containerWhite.of(context),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // #2-1. 핵심 요약 섹션
              LoanDetailSummarySection(
                title: title,
                isRepaid: isRepaid,
                memo: memo,
                amount: amount,
              ),
              Divider(height: 80, color: AppColor.divider.of(context)),
              // #2-2. 상세 정보 섹션
              LoanDetailInfoSection(
                myAction: myAction,
                initialAmount: initialAmount,
                name: name,
                loanDate: loanDate,
                dueDate: dueDate,
                dDay: dDay,
              ),
              Divider(height: 80, color: AppColor.divider.of(context)),
              // #2-3. 상환한 금액 섹션
              LoanDetailRepaymentSection(
                myAction: myAction,
                totalRepayment: totalRepayment,
                initialAmount: initialAmount,
                repaymentRate: repaymentRate,
              )
            ]),
          ),
        ],
      ),
      // #3. 하단 네비게이션바
      bottomNavigationBar: CommonDetailBottomNavigationBar(
          myAction: myAction, category: Category.loan),
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