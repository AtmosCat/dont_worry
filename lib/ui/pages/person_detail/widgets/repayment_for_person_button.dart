import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/service/query_service.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/widgets/small_loan_card.dart';
import 'package:dont_worry/utils/enum.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RepaymentForPersonButton extends StatefulWidget {
  final bool isRepaid;
  final bool isLending;
  final UnitType unitType;
  final Person person;
  const RepaymentForPersonButton({
    super.key,
    required this.isRepaid,
    required this.isLending,
    required this.unitType,
    required this.person,
  });

  @override
  State<RepaymentForPersonButton> createState() =>
      _RepaymentForPersonButtonState();
}

class _RepaymentForPersonButtonState extends State<RepaymentForPersonButton> {
  late List<Loan> _filteredLoans;

  @override
  void initState() {
    super.initState();
    _filteredLoans = [];
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController repaymentAmountController = widget.isLending
        ? TextEditingController(
            text: widget.person.remainingLendAmount.toString())
        : TextEditingController(
            text: widget.person.remainingBorrowAmount.toString());
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            icon: Icon(
                widget.isLending ? Icons.arrow_downward : Icons.arrow_upward,
                size: 20),
            label: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text:
                        '${widget.person.name.characters.take(6).toString()}${widget.person.name.length > 6 ? "..." : ""}'),
                TextSpan(text: '에게 '),
                TextSpan(text: widget.isLending ? '받은 돈 기록' : '갚은 돈 기록')
              ]),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconAlignment: IconAlignment.start,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 14,
              ),
              alignment: Alignment.center,
              backgroundColor: widget.isLending
                  ? AppColor.primaryBlue.of(context)
                  : AppColor.primaryRed.of(context),
              foregroundColor: AppColor.onPrimaryWhite.of(context),
              iconColor: AppColor.onPrimaryWhite.of(context),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: AlertDialog(
                      backgroundColor: AppColor.containerWhite.of(context),
                      titlePadding: EdgeInsets.zero,
                      title: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                                child: widget.isLending
                                    ? Text(
                                        "${widget.person.name}에게 받은 돈 기록",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        "${widget.person.name}에게 갚은 돈 기록",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                          ),
                          Positioned(
                            right: 5,
                            top: 3,
                            child: IconButton(
                              icon: const Icon(CupertinoIcons.clear_circled_solid),
                              color: Colors.black54,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      content: SizedBox(
                        height: 400,
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
                                labelStyle: TextStyle(
                                  color: AppColor.gray30.of(context),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                suffixIcon:
                                    repaymentAmountController.text.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(Icons.clear),
                                            onPressed: () {
                                              repaymentAmountController.clear();
                                            })
                                        : null,
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
                            SizedBox(height: 10),
                            Consumer(builder: (context, ref, child) {
                              return ElevatedButton.icon(
                                onPressed: () async {
                                  var repaymentAmount =
                                      int.parse(repaymentAmountController.text);
                                  for (var loan in _filteredLoans) {
                                    if (loan.remainingAmount <=
                                        repaymentAmount) {
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
                                  SnackbarUtil.showToastMessage(
                                      "오래된 내역부터 총 ${repaymentAmountController.text}원의 상환이 완료되었습니다.");
                                  repaymentAmountController.text = "0";
                                  if (repaymentAmount == 0) {
                                    Navigator.pop(context);
                                  }
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
                              int initialText = 0;
                              for (var loan in _filteredLoans) {
                                initialText += loan.remainingAmount;
                              }
                              if (repaymentAmountController.text.isEmpty) {
                                repaymentAmountController.text =
                                    initialText.toString();
                              }

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
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
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
