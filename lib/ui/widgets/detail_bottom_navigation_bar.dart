import 'package:dont_worry/data/ledger_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailBottomNavigationBar extends StatelessWidget {
  final bool isLending;
  final UnitType unitType;
  const DetailBottomNavigationBar({
    required this.isLending,
    required this.unitType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppColor.containerWhite.of(context),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // 그림자 색상
                blurRadius: 30, // 흐림 정도
                spreadRadius: 6, // 그림자 크기
                offset: Offset(0, -4), // ⬆ 위쪽 그림자 (기본은 아래로 가므로 -값)
              )
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(height: 0, color: AppColor.divider.of(context)),
            BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Column(
                        children: [
                          Icon(
                            unitType != UnitType.loan
                                ? Icons.add
                                : Icons.edit_note,
                            color: AppColor.defaultBlack.of(context),
                          ),
                          Text(unitType != UnitType.loan
                              ? isLending
                                  ? '빌려준 돈 기록'
                                  : '빌린 돈 기록'
                              : isLending
                                  ? '빌려준 돈 편집'
                                  : '빌린 돈 편집')
                        ],
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Column(
                        children: [
                          Icon(Icons.task_alt,
                              color: AppColor.primaryBlue.of(context)),
                          Text(isLending
                              ? '받은 돈 기록'
                              : '갚은 돈 기록')
                        ],
                      ),
                      label: ''),
                ],
                onTap: (int index) {
                  if (index == 0) {
                    handleCreateLoan(context);
                  } else if (index == 1) {
                    handleCreateRepayment(context);
                  }
                },
                backgroundColor: AppColor.containerWhite.of(context),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 5,
                type: BottomNavigationBarType.fixed),
          ],
        ));
  }

  void createLoan(
      {required BuildContext context,
      required WidgetRef ref,
      required int initialAmount}) async {
    Loan newLoan = Loan(
        initialAmount: initialAmount,
        personId: 'personId',
        isLending: isLending,
        loanDate: DateTime(2024, 2, 1),
        dueDate: DateTime(2024, 4, 1),
        title: '제목',
        memo: '빠른 상환을 부탁드립니다.');
    await ref.read(ledgerViewModelProvider.notifier).createLoan(newLoan);
  }

  void createRepayment(
      {required BuildContext context,
      required WidgetRef ref,
      required int amount}) async {
    Repayment newRepayment = Repayment(
      personId: 'personId',
      loanId: 'loanId',
      amount: amount,
      date: DateTime.now(),
      isLending: isLending,
    );
    await ref
        .read(ledgerViewModelProvider.notifier)
        .createRepayment(newRepayment);
  }

  void handleCreateLoan(BuildContext context) {
    var amountController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  TextField(
                      controller: amountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                          labelText: '빌릴 금액',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: AppColor.containerLightGray30.of(context),
                          filled: true,
                          contentPadding: EdgeInsets.all(20))),
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      return ElevatedButton(
                          onPressed: () {
                            createLoan(
                                context: context,
                                ref: ref,
                                initialAmount:
                                    int.parse(amountController.text));
                            Navigator.pop(context);
                          },
                          child: Text('대출 생성'));
                    },
                  )
                ],
              ),
            ));
  }

  void handleCreateRepayment(BuildContext context) {
    var amountController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  TextField(
                      controller: amountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                          labelText: '갚을 금액',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: AppColor.containerLightGray30.of(context),
                          filled: true,
                          contentPadding: EdgeInsets.all(20))),
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      return ElevatedButton(
                          onPressed: () {
                            createRepayment(
                                context: context,
                                ref: ref,
                                amount: int.parse(amountController.text));
                            Navigator.pop(context);
                          },
                          child: Text('상환 생성'));
                    },
                  )
                ],
              ),
            ));
  }
}
