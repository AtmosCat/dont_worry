import 'dart:developer';

import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/ui/widgets/create_loan_floating_action_button.dart';
import 'package:dont_worry/ui/pages/person_detail/widgets/loan_card.dart';
import 'package:dont_worry/ui/pages/person_detail/widgets/person_detail_header.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/ui/widgets/list_header.dart';
import 'package:dont_worry/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonDetailPage extends StatefulWidget {
  final bool isLending;
  final Person person;
  const PersonDetailPage(
      {required this.isLending, required this.person, super.key});

  @override
  State<PersonDetailPage> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  bool? isSortedByUpdate;

  @override
  void initState() {
    super.initState();
    isSortedByUpdate = true;
  }

  void onSortOptionSelected(String value) {
    setState(() {
      isSortedByUpdate = value == '업데이트 순';
    });
  }

  @override
  Widget build(BuildContext context) {
    log('${person.updatedAt}');

    return Scaffold(
      floatingActionButton: CreateLoanFloatingActionButton(
          isLending: widget.isLending, person: widget.person),
      // #1. 상단 앱바
      appBar: DetailAppBar(
        isLending: widget.isLending,
        unitType: UnitType.person,
        person: widget.person,
      ),
      body: ListView(
        children: [
          // #2. 헤더
          PersonDetailHeader(
              personId: widget.person.personId, isLending: widget.isLending),
          Consumer(builder: (context, ref, child) {
            var stateLoans = ref.watch(appViewModelProvider.select((state) =>
                state.loans.where((loan) =>
                    loan.personId == widget.person.personId &&
                    loan.isLending == widget.isLending)));
            var inPaidList = stateLoans.where((loan) => !loan.isPaidOff).toList();
            var paidOffList = stateLoans.where((loan) => loan.isPaidOff).toList();

            // 업데이트 순 정렬
            if (isSortedByUpdate ?? true) {
              inPaidList.sort((b, a) => a.updatedAt.compareTo(b.updatedAt));
              paidOffList.sort((b, a) => a.updatedAt.compareTo(b.updatedAt));
            }

            // 높은 가격 순 정렬 (대출 금액 기준)
            else if (widget.isLending) {
              inPaidList.sort((b, a) =>
                  a.remainingAmount.compareTo(b.remainingAmount));
              paidOffList.sort(
                  (b, a) => a.remainingAmount.compareTo(b.remainingAmount));
            } else {
              inPaidList.sort((b, a) =>
                  a.remainingAmount.compareTo(b.remainingAmount));
              paidOffList.sort((b, a) =>
                  a.remainingAmount.compareTo(b.remainingAmount));
            }

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
                              isLending: widget.isLending,
                              unitType: UnitType.loan,
                              onSortOptionSelected: onSortOptionSelected,
                            ),
                            loanList(
                              isLending: widget.isLending,
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
                            ListHeader(
                              unitType: UnitType.loan,
                              onSortOptionSelected: onSortOptionSelected,
                            ),
                            loanList(
                              isLending: widget.isLending,
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
    );
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
