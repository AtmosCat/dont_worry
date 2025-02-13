import 'package:dont_worry/data/ledger_view_model.dart';
import 'package:dont_worry/ui/pages/home/widgets/person_card.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/ui/widgets/list_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTabView extends StatelessWidget {
  final MyAction myAction;
  HomeTabView({
    required this.myAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(4), children: [
      ListHeader(myAction: myAction, category: Category.person),
      personList(),
      ListHeader(category: Category.person),
      personList(),
      SizedBox(height: 60)
    ]);
  }

  Consumer personList() {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final peopleState = ref.watch(ledgerViewModelProvider).people;

      return peopleState.isEmpty
          ? const Center(child: CircularProgressIndicator()) // 로딩 중
          : Column(
              children: List.generate(
                peopleState.length,
                (index) =>
                    PersonCard(person: peopleState[index], myAction: myAction),
              ),
            );
    });
  }
}


// 더미데이터
// PersonCard(myAction: myAction, person: dummyPerson2),
  // final Person dummyPerson1 = Person(
  //   personId: 'test001_person',
  //   name: '홍길동',
  //   loans: [
  //     Loan(
  //       personId: 'test001_person',
  //       loanId: 'test001_loan',
  //       isLending: true, // 빌려준 돈
  //       initialAmount: 10000, // 1만원
  //       repayments: [
  //         Repayment(
  //             personId: 'test001_person',
  //             loanId: 'test001_loan',
  //             repaymentId: 'test001_repayment',
  //             amount: 5000,
  //             date: DateTime(2024, 10, 26)),
  //       ], // 5천원 상환
  //       loanDate: DateTime(2024, 10, 25), // 2024년 10월 25일
  //       dueDate: DateTime(2024, 11, 24), // 2024년 11월 24일
  //       title: '간식값',
  //       memo: '내일까지 갚아라',
  //     )
  //   ], // 빈 리스트
  //   memo: '특이사항 없음',
  // );

  // final Person dummyPerson2 = Person(
  //   personId: 'test002_person',
  //   name: '다가픔',
  //   loans: [], // 빈 리스트
  //   memo: '특이사항 없음',
  // );