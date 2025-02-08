import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/ui/pages/home/home_view_model.dart';
import 'package:dont_worry/ui/pages/home/widgets/person_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeLoanPaidListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Consumer(builder: (context, ref, child) {
      final homeState = ref.watch(homeViewModel);
      final loans = homeState.loans;
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: loans.length,
        itemBuilder: (context, index) {
          final lendedLoans = Loan.lendingLoans(loans).where(
            (it) {
              Loan.remainingLoanAmount(it.initialAmount, it.repayments!);
              return true;
            },
          );
          for (var loan in loans) {
            if (loan.isLending) {}
          }

          // return PersonCard(loans[index]);
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 20,
          );
        },
      );
    }));
  }
}
