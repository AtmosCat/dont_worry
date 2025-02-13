import 'package:dont_worry/data/ledger_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/ui/pages/person_detail/widgets/loan_card.dart';
import 'package:dont_worry/ui/pages/person_detail/widgets/person_detail_header.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/ui/widgets/detail_bottom_navigation_bar.dart';
import 'package:dont_worry/ui/widgets/list_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonDetailPage extends StatelessWidget {
  final MyAction myAction;
  final Person person;
  PersonDetailPage(this.myAction, {required this.person, super.key});

  // PersonDetailPage UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // #1. 상단 앱바
        appBar: DetailAppBar(
          myAction: myAction,
          category: Category.person,
          person: person,
        ),
        body: ListView(
          children: [
            // #2. 헤더
            PersonDetailHeader(person: person),
            SizedBox(height: 10),
            // #3-1. 미상환 대출 List
            ListHeader(myAction: myAction, category: Category.loan),
            loanList(),
            SizedBox(height: 10),
            // #3-2. 상환완료 대출 List
            ListHeader(category: Category.loan),
            loanList(),
            SizedBox(height: 60)
          ],
        ),
        // #4. 하단 네비게이션바
        bottomNavigationBar: DetailBottomNavigationBar(
            myAction: myAction, category: Category.person));
  }

  Consumer loanList() {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final loansState = ref.watch(ledgerViewModelProvider).loans;

      return loansState.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: List.generate(
                  loansState.length,
                  (index) =>
                      LoanCard(loan: loansState[index], myAction: myAction)),
            );
    });
  }

  // 더미데이터
  final Loan dummyLoan1 = Loan(
      personId: 'test001_person',
      loanId: 'test001_loan',
      isLending: true, // 빌려주는 돈
      initialAmount: 100000,
      repayments: [
        Repayment(
            personId: 'test001_person',
            loanId: 'test001_loan',
            repaymentId: 'test001_repayment',
            amount: 300,
            date: DateTime(2024, 2, 1))
      ],
      loanDate: DateTime(2024, 2, 1),
      dueDate: DateTime(2024, 4, 1),
      title: '김철수에게 빌려준 돈',
      memo: '빠른 상환을 부탁드립니다.');
}
