import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/ui/pages/home/home_view_model.dart';
import 'package:dont_worry/ui/pages/home/widgets/person_card.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePaidLoanListView extends StatelessWidget {
  final MyAction myAction;

  HomePaidLoanListView({
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

        // 그룹화된 상환 완료된 대출 리스트
        final groupedLoansByPerson = groupBy(loans, (loan) => loan.person);
        final groupedPaidLoansByPerson = groupedLoansByPerson.map(
          (key, value) {
            final paidLoans = value
                .where((loan) =>
                    loan.repayments != null &&
                    Loan.remainingLoanAmount(
                            loan.initialAmount, loan.repayments!) <=
                        0)
                .toList();
            return MapEntry(key, paidLoans);
          },
        );

        return ListView.separated(
          shrinkWrap: true, // ListView의 크기를 제한
          physics: NeverScrollableScrollPhysics(), // 내부 스크롤 비활성화
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: groupedPaidLoansByPerson.entries
              .where((entry) => entry.value.isNotEmpty) // 값이 비어있지 않은 항목만 필터링
              .length,
          itemBuilder: (context, index) {
            final validEntries = groupedPaidLoansByPerson.entries
                .where((entry) => entry.value.isNotEmpty) // 다시 필터링
                .toList();

            return PersonCard(
              person: validEntries[index].key,
              loans: validEntries[index].value,
              myAction: myAction,
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
}
