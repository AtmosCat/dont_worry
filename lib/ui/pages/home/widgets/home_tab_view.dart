import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/data/repository/sql_person_crud_repository.dart';
import 'package:dont_worry/ui/pages/home/widgets/person_card.dart';
import 'package:dont_worry/ui/widgets/common_detail_app_bar.dart';
import 'package:dont_worry/ui/widgets/list_header.dart';
import 'package:flutter/material.dart';

class HomeTabView extends StatelessWidget {
  final MyAction myAction;
  HomeTabView({
    required this.myAction,
    super.key,
  });

  Future<List<Person>> _loadPersonData() async {
    return await SqlPersonCrudRepository.getList();
  }

  @override
  Widget build(BuildContext context) {
    /* TODO: '빌려준 돈' Person List 구현 */
    return ListView(padding: EdgeInsets.all(4), children: [
      ListHeader(myAction: myAction, category: Category.person),
      FutureBuilder<List<Person>>(
        future: _loadPersonData(),
        builder: (context, AsyncSnapshot<List<Person>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Not Support Sqflite'));
          }
          if (snapshot.hasData) {
            var datas = snapshot.data;
            return Column(
                children: List.generate(datas!.length, (index) => PersonCard(person:datas[index], myAction: myAction)).toList());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      // PersonCard(myAction: myAction, person: dummyPerson1),
      ListHeader(category: Category.person),
      PersonCard(myAction: myAction, person: dummyPerson2),
      SizedBox(height: 60)
    ]);
  }

// 더미데이터
  final Person dummyPerson1 = Person(
    personId: 'test001_person',
    name: '홍길동',
    loans: [
      Loan(
        personId: 'test001_person',
        loanId: 'test001_loan',
        isLending: true, // 빌려준 돈
        initialAmount: 10000, // 1만원
        repayments: [
          Repayment(
              personId: 'test001_person',
              loanId: 'test001_loan',
              repaymentId: 'test001_repayment',
              amount: 5000,
              date: DateTime(2024, 10, 26)),
        ], // 5천원 상환
        loanDate: DateTime(2024, 10, 25), // 2024년 10월 25일
        dueDate: DateTime(2024, 11, 24), // 2024년 11월 24일
        title: '간식값',
        memo: '내일까지 갚아라',
      )
    ], // 빈 리스트
    memo: '특이사항 없음',
  );

  final Person dummyPerson2 = Person(
    personId: 'test002_person',
    name: '다가픔',
    loans: [], // 빈 리스트
    memo: '특이사항 없음',
  );
}
