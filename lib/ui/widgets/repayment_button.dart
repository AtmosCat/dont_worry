import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class RepaymentButton extends StatefulWidget {
  final bool isRepaid;
  final Loan loan;
  final bool isLending;

  const RepaymentButton({
    super.key,
    required this.isRepaid,
    required this.loan,
    required this.isLending,
  });

  @override
  State<RepaymentButton> createState() => _RepaymentButtonState();
}

class _RepaymentButtonState extends State<RepaymentButton> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !widget.isRepaid,
      replacement: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          alignment: Alignment.center,
          backgroundColor: AppColor.containerGray20.of(context),
          foregroundColor: AppColor.onPrimaryWhite.of(context),
        ),
        child: const Text(
          '상환 완료',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      child: TextButton.icon(
        icon: const Icon(Icons.task_alt, size: 18),
        label: const Text(
          '상환',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
              final TextEditingController repaymentAmountController =
                  TextEditingController(
                text: NumberFormat("#,###").format(widget.loan.remainingAmount),
              );

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    backgroundColor: AppColor.containerWhite.of(context),
                    title: const Text(
                      "상환할 금액을 입력하세요.",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    content: SizedBox(
                      height: 70,
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: repaymentAmountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.primaryBlue.of(context),
                                  width: 2.0,
                                ),
                              ),
                              labelText: "상환액",
                              labelStyle: TextStyle(
                                color: AppColor.gray30.of(context),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              suffixIcon: repaymentAmountController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          repaymentAmountController.clear();
                                        });
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
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
                      Consumer(
                        builder: (context, ref, child) => TextButton(
                          onPressed: () async {
                            String inputText = repaymentAmountController.text.replaceAll(',', '');
                            if (inputText.isEmpty) {
                              SnackbarUtil.showToastMessage("금액을 입력해주세요.");
                              return;
                            }

                            int repaymentAmount = int.parse(inputText);
                            if (repaymentAmount > widget.loan.remainingAmount) {
                              SnackbarUtil.showToastMessage(
                                "잔액인 ${widget.loan.remainingAmount}원보다 적은 금액을 입력해주세요.",
                              );
                            } else {
                              final newRepayment = Repayment(
                                personId: widget.loan.personId,
                                loanId: widget.loan.loanId,
                                isLending: widget.loan.isLending,
                                amount: repaymentAmount,
                              );

                              await ref.read(appViewModelProvider.notifier).createRepayment(newRepayment);
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("$repaymentAmount 원이 상환 처리되었습니다."),
                                ),
                              );
                            }
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
                      )
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}