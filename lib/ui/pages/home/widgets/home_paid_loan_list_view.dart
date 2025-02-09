import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/ui/pages/home/home_view_model.dart';
import 'package:dont_worry/ui/pages/home/widgets/person_card.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePaidLoanListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeViewModel);
        final loans = homeState.loans;

        // 그룹화된 상환 완료된 대출 리스트
        final groupedLoansByPerson = groupBy(loans, (loan) => loan.person);
        final groupedPaidLoansByPerson = groupedLoansByPerson.map(
          (key, value) {
            final paidLoans = value
                .where((loan) =>
                    loan.repayments != null &&
                    loan.initialAmount <=
                        Loan.remainingLoanAmount(
                            loan.initialAmount, loan.repayments!))
                .toList();
            return MapEntry(key, paidLoans);
          },
        );

        return ListView.separated(
          shrinkWrap: true, // ListView의 크기를 제한
          physics: NeverScrollableScrollPhysics(), // 내부 스크롤 비활성화
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: groupedPaidLoansByPerson.length,
          itemBuilder: (context, index) {
            return PersonCard(
              person: groupedPaidLoansByPerson.keys.elementAt(index),
              myAction: MyAction.lend,
            );
          },
          separatorBuilder: (context, index) => Divider(height: 20),
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
