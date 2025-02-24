import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/service/query_service.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/enum.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/ui/pages/create_loan/create_loan_page.dart';
import 'package:dont_worry/ui/widgets/small_loan_card.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailBottomNavigationBar extends StatefulWidget {
  final bool isLending;
  final UnitType unitType;
  final Person person;
  const DetailBottomNavigationBar({
    required this.isLending,
    required this.unitType,
    required this.person,
    super.key,
  });

  @override
  State<DetailBottomNavigationBar> createState() =>
      _DetailBottomNavigationBarState();
}

class _DetailBottomNavigationBarState extends State<DetailBottomNavigationBar> {
  bool isChecked = false;
  late List<Loan> _filteredLoans;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController repaymentAmountController =
        TextEditingController();
    return Container(
      decoration:
          BoxDecoration(color: AppColor.containerWhite.of(context), boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1), // 그림자 색상
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
                        widget.unitType != UnitType.loan
                            ? Icons.add
                            : Icons.edit_note,
                        color: AppColor.defaultBlack.of(context),
                      ),
                      Text(widget.unitType != UnitType.loan
                          ? widget.isLending
                              ? '빌려준 돈 기록'
                              : '빌린 돈 기록'
                          : widget.isLending
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
                      Text(widget.isLending ? '받은 돈 기록' : '갚은 돈 기록')
                    ],
                  ),
                  label: ''),
            ],
            onTap: (int index) {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateLoanPage(
                        isLending: widget.isLending, person: widget.person),
                  ),
                );
              } else if (index == 1) {
                // 원하는 동작 추가: '사람'에 대해 상환하기 로직 구현
                showDialog(
                  context: context,
                  builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: AlertDialog(
                        backgroundColor: AppColor.containerWhite.of(context),
                        title: Text("상환하기",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        content: SizedBox(
                          height: 500,
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "상환할 금액을 입력하세요.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: repaymentAmountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor.primaryBlue.of(context),
                                        width: 2.0),
                                  ),
                                  labelText: "상환액",
                                  labelStyle: TextStyle(
                                    color: AppColor.gray30.of(context),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                "원하는 내역을 상환 처리하세요.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              //             Consumer(
                              //   builder: (context, ref, child) => TextButton(
                              //     onPressed: () async {
                              //       final newRepayment = Repayment(
                              //         personId: widget.loan.personId,
                              //         loanId: widget.loan.loanId,
                              //         isLending: widget.loan.isLending,
                              //         amount: int.parse(repaymentAmountController.text.replaceAll(',', '')),
                              //       );
                              //       await ref
                              //           .read(appViewModelProvider.notifier)
                              //           .createRepayment(newRepayment);
                              //       Navigator.pop(context);
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //           content: Text(
                              //               "${repaymentAmountController.text}원이 상환 처리되었습니다."),
                              //         ),
                              //       );
                              //     },
                              //     child: Text(
                              //       "확인",
                              //       style: TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.bold,
                              //         color: AppColor.primaryBlue.of(context),
                              //       ),
                              //     ),
                              //   ),
                              // )
                              SizedBox(height: 10),
                              Consumer(builder: (context, ref, child) {
                                return ElevatedButton.icon(
                                  onPressed: () async {
                                    var repaymentAmount = int.parse(
                                        repaymentAmountController.text);
                                    for (var loan in _filteredLoans) {
                                      if (loan.remainingAmount <= repaymentAmount) {
                                        final newRepayment = Repayment(
                                          personId: loan.personId,
                                          loanId: loan.loanId,
                                          isLending: loan.isLending,
                                          amount: loan.remainingAmount,
                                        );
                                        await ref
                                            .watch(appViewModelProvider.notifier)
                                            .createRepayment(newRepayment);
                                        repaymentAmount -= loan.remainingAmount;
                                      } else {
                                        final newRepayment = Repayment(
                                          personId: loan.personId,
                                          loanId: loan.loanId,
                                          isLending: loan.isLending,
                                          amount: repaymentAmount,
                                        );
                                        await ref
                                            .watch(appViewModelProvider.notifier)
                                            .createRepayment(newRepayment);
                                        repaymentAmount = 0;
                                      }
                                    }
                                    SnackbarUtil.showToastMessage("오래된 내역부터 총 ${repaymentAmountController.text}원의 상환이 완료되었습니다.");
                                    repaymentAmountController.text = "0";
                                  },
                                  icon: Icon(Icons.task_alt,
                                      size: 16,
                                      color: AppColor.onPrimaryWhite
                                          .of(context)), // 아이콘 색상 지정
                                  label: Text(
                                    "오래된 내역부터 자동 상환",
                                    style: TextStyle(
                                      color: AppColor.onPrimaryWhite
                                          .of(context), // 텍스트 색상 지정
                                      fontSize: 12, // 텍스트 크기 지정
                                      fontWeight: FontWeight.bold, // 텍스트 두께
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColor.primaryBlue.of(context),
                                    shape: RoundedRectangleBorder(
                                      // 버튼 모서리 둥글게
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(height: 20),
                              Consumer(builder: (context, ref, child) {
                                var filteredLoans = QueryService().getLoansBy(
                                  personId: widget.person.personId,
                                  isLending: widget.isLending,
                                  isPaidOff: false,
                                  loans: ref.watch(appViewModelProvider).loans,
                                );
                                filteredLoans.sort(
                                    (a, b) => a.loanDate.compareTo(b.loanDate));
                                _filteredLoans = filteredLoans;
                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredLoans.length,
                                    itemBuilder: (context, index) =>
                                        SmallLoanCard(
                                      loan: filteredLoans[index],
                                      isLending: widget.isLending,
                                      person: widget.person,
                                      repaymentAmountController:
                                          repaymentAmountController,
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // 다이얼로그 닫기
                            },
                            child: Text(
                              "취소",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryBlue.of(context),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              // final newRepayment = Repayment(
                              //   personId: widget.loan.personId,
                              //   loanId: widget.loan.loanId,
                              //   amount: int.parse(repaymentAmountController.text),
                              // );
                              // widget.loan.repayments.add(newRepayment);
                              // widget.person.loans.add(widget.loan);
                              // var createRepaymentResult =
                              //     await SqlRepaymentCrudRepository.create(newRepayment);
                              // var updateLoanResult =
                              //     await SqlLoanCrudRepository.update(widget.loan);
                              // var updatePersonResult =
                              //     await SqlPersonCrudRepository.update(widget.person);
                              // if (createRepaymentResult &&
                              //     updateLoanResult &&
                              //     updatePersonResult) {
                              //   Navigator.pop(context);
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text(
                              //           "${int.parse(repaymentAmountController.text)}원이 상환 처리되었습니다."),
                              //     ),
                              //   );
                              // } else {
                              //   Navigator.pop(context);
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text("상환 처리에 실패했습니다."),
                              //     ),
                              //   );
                              // }
                            },
                            child: Text(
                              "확인",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryBlue.of(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
            backgroundColor: AppColor.containerWhite.of(context),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 5,
            type: BottomNavigationBarType.fixed,
          ),
        ],
      ),
    );
  }

  void createLoan(
      {required BuildContext context,
      required WidgetRef ref,
      required int initialAmount}) async {
    Loan newLoan = Loan(
        initialAmount: initialAmount,
        personId: 'personId',
        isLending: widget.isLending,
        loanDate: DateTime(2024, 2, 1),
        dueDate: DateTime(2024, 4, 1),
        title: '제목',
        memo: '빠른 상환을 부탁드립니다.');
    await ref.read(appViewModelProvider.notifier).createLoan(newLoan);
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
      isLending: widget.isLending,
    );
    await ref.read(appViewModelProvider.notifier).createRepayment(newRepayment);
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
                      builder: (context, ref, child) => ElevatedButton(
                          onPressed: () {
                            createLoan(
                                context: context,
                                ref: ref,
                                initialAmount:
                                    int.parse(amountController.text));
                            Navigator.pop(context);
                          },
                          child: Text('대출 생성')))
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
