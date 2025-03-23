import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SmallRepaymentButton extends StatefulWidget {
  final BuildContext context;
  final bool isRepaid;
  final bool isLending;
  final Loan loan;
  final Person person;
  final TextEditingController repaymentAmountController;

  const SmallRepaymentButton(
      {super.key,
      required this.context,
      required this.isRepaid,
      required this.isLending,
      required this.loan,
      required this.person,
      required this.repaymentAmountController});

  @override
  State<SmallRepaymentButton> createState() => _RepaymentButtonState();
}

class _RepaymentButtonState extends State<SmallRepaymentButton> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !widget.isRepaid,
      // 상환 완료 시,
      replacement: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          alignment: Alignment.center,
          backgroundColor: AppColor.containerGray20.of(context),
          foregroundColor: AppColor.onPrimaryWhite.of(context),
        ),
        child: Text('상환 완료',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),

      // 미상환 시,
      child: TextButton.icon(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                final initialText = int.parse(widget.repaymentAmountController.text) < widget.loan.remainingAmount
                    ? widget.repaymentAmountController.text
                    : widget.loan.remainingAmount.toString();
                final TextEditingController amountController =
                    TextEditingController(
                        text: initialText);
                return AlertDialog(
                    backgroundColor: AppColor.containerWhite.of(context),
                    title: Text("상환할 금액을 입력하세요.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    content: SizedBox(
                      height: 70,
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text("얼마를 상환 처리할까요?",
                          // style: TextStyle(
                          //   fontSize: 16,
                          //   fontWeight: FontWeight.normal,
                          // ),),
                          TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: widget.isLending ?  AppColor.primaryYellow.of(context) : AppColor.primaryGreen.of(context),
                                    width: 2.0),
                              ),
                              labelText: "상환액",
                              labelStyle: TextStyle(
                                color: AppColor.gray30.of(context),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              suffixIcon: amountController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        amountController.clear();
                                      })
                                  : null,
                            ),
                          ),
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
                            color: widget.isLending ?  AppColor.primaryYellow.of(context) : AppColor.primaryGreen.of(context),
                          ),
                        ),
                      ),
                      Consumer(
                          builder: (context, ref, child) => TextButton(
                              onPressed: () async {
                                final amount = int.parse(
                                    amountController.text.replaceAll(',', ''));
                                if (amount >
                                    int.parse(widget
                                        .repaymentAmountController.text)) {
                                  SnackbarUtil.showToastMessage(
                                      "잔액인 ${widget.repaymentAmountController.text}원보다 적은 금액을 입력해주세요.");
                                } else {
                                  final newRepayment = Repayment(
                                    personId: widget.loan.personId,
                                    loanId: widget.loan.loanId,
                                    isLending: widget.loan.isLending,
                                    amount: amount,
                                  );
                                  await ref
                                      .read(appViewModelProvider.notifier)
                                      .createRepayment(newRepayment);
                                  widget.repaymentAmountController.text =
                                      (int.parse(widget
                                                  .repaymentAmountController
                                                  .text) -
                                              amount)
                                          .toString();
                                  Navigator.pop(context);
                                  SnackbarUtil.showToastMessage(
                                      "${amountController.text}원이 상환 처리되었습니다.");
                                }
                              },
                              child: Text("확인",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          widget.isLending ?  AppColor.primaryYellow.of(context) : AppColor.primaryGreen.of(context)))))
                    ]);
              });
        },
        icon: const Icon(Icons.task_alt, size: 16),
        label: const Text(
          '상환',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconAlignment: IconAlignment.end,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          alignment: Alignment.center,
          backgroundColor: widget.isLending ?  AppColor.primaryYellow.of(context) : AppColor.primaryGreen.of(context),
          foregroundColor: AppColor.onPrimaryWhite.of(context),
          iconColor: AppColor.onPrimaryWhite.of(context),
        ),
      ),
    );
  }
}
