import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/repository/user_repository.dart';
import 'package:dont_worry/ui/pages/home/home_view_model.dart';
import 'package:dont_worry/ui/pages/home/widgets/person_card.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePendingLoanListView extends StatelessWidget {
  final MyAction myAction;

  HomePendingLoanListView({
    required this.myAction,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeViewModel);
        final loans = myAction == MyAction.lend
            ? homeState.loans.where((loan) => loan.isLending).toList()
            : homeState.loans.where((loan) => !loan.isLending).toList();

        // Person 기준으로 그룹화된 상환 중인 대출 리스트
        final groupedLoansByPerson = groupBy(loans, (loan) => loan.person);
        final groupedPendingLoansByPerson = groupedLoansByPerson.map(
          (key, value) {
            final pendingLoans = value
                .where((loan) =>
                    loan.repayments != null &&
                    Loan.remainingLoanAmount(
                            loan.initialAmount, loan.repayments!) > 0)
                .toList();
            return MapEntry(key, pendingLoans);
          },
        );

        return ListView.separated(
          shrinkWrap: true, // ListView의 크기를 제한
          physics: NeverScrollableScrollPhysics(), // 내부 스크롤 비활성화
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: groupedPendingLoansByPerson.length,
          itemBuilder: (context, index) {
            return PersonCard(
              person: groupedPendingLoansByPerson.keys.elementAt(index),
              loans: groupedPendingLoansByPerson.values.elementAt(index),
              myAction: MyAction.lend,
            );
          },
          separatorBuilder: (context, index) =>
              Divider(height: 2, color: Colors.grey[100]),
        );
      },
    );
  }

  /// 리스트를 그룹화하는 메서드
  Map<K, List<T>> groupBy<T, K>(List<T> items, K Function(T) keySelector) {
    return items.fold<Map<K, List<T>>>({}, (map, item) {
      final key = keySelector(item);
      map.putIfAbsent(key, () => []).add(item);
      return map;
    });
  }

  Future<List<Person>?> getPersonList() async {
    final loans = await UserRepository().getLoans();
    final personList = <Person>[];
    for (var loan in loans!) {
      final person = loan.person;
      if (!personList.contains(person)) {
        personList.add(person);
      }
    }
  }
}
