import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/ui/pages/person_detail/widgets/loan_card.dart';
import 'package:dont_worry/ui/pages/person_detail/widgets/person_detail_header.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/ui/widgets/detail_bottom_navigation_bar.dart';
import 'package:dont_worry/ui/widgets/list_header.dart';
import 'package:dont_worry/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonDetailPage extends StatelessWidget {
  final bool isLending;
  final Person person;
  const PersonDetailPage(
      {required this.isLending, required this.person, super.key});

  // PersonDetailPage UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // #1. 상단 앱바
        appBar: DetailAppBar(
          isLending: isLending,
          unitType: UnitType.person,
          person: person,
        ),
        body: ListView(
          children: [
            // #2. 헤더
            PersonDetailHeader(personId: person.personId, isLending: isLending),
            Consumer(builder: (context, ref, child) {
              var stateLoans = ref.watch(appViewModelProvider.select((state) =>
                  state.loans.where((loan) =>
                      loan.personId == person.personId &&
                      loan.isLending == isLending)));
              var inPaidList = stateLoans.where((loan) => !loan.isPaidOff);
              var paidOffList = stateLoans.where((loan) => loan.isPaidOff);

              return Visibility(
                  visible: stateLoans.isNotEmpty,
                  child: Column(
                    children: [
                      Offstage(
                          offstage: inPaidList.isEmpty,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              // #3-1. 미상환 대출 List
                              ListHeader(
                                  isLending: isLending,
                                  unitType: UnitType.loan),
                              loanList(
                                isLending: isLending,
                                loansState: inPaidList.toList(),
                              ),
                            ],
                          )),
                      Offstage(
                          offstage: paidOffList.isEmpty,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              // #3-2. 상환완료 대출 List
                              ListHeader(unitType: UnitType.loan),
                              loanList(
                                isLending: isLending,
                                loansState: paidOffList.toList(),
                              ),
                            ],
                          )),
                      SizedBox(height: 60)
                    ],
                  ));
            })
          ],
        ),
        // #4. 하단 네비게이션바
        bottomNavigationBar: DetailBottomNavigationBar(
            isLending: isLending, unitType: UnitType.person, person: person));
  }

  Widget loanList({required bool isLending, required loansState}) {
    return loansState.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: List.generate(
                  loansState.length,
                  (index) =>
                      LoanCard(loan: loansState[index], isLending: isLending)),
            );
  }
}
