import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
          padding: EdgeInsets.symmetric(
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
        icon: Icon(Icons.task_alt, size: 18),
        label: Text(
          '상환',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconAlignment: IconAlignment.end,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
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
              final TextEditingController repaymentAmountController =
                  TextEditingController(
                      text:
                          "${NumberFormat("#,###").format(widget.loan.remainingAmount)}");
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
                          suffixIcon: repaymentAmountController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    repaymentAmountController.clear();
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
                        color: AppColor.primaryBlue.of(context),
                      ),
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) => TextButton(
                      onPressed: () async {
                        if (int.parse(repaymentAmountController.text) >
                            widget.loan.remainingAmount) {
                                  SnackbarUtil.showToastMessage(
                                      "잔액인 ${widget.loan.remainingAmount}원보다 적은 금액을 입력해주세요.");
                        } else {
                          final newRepayment = Repayment(
                            personId: widget.loan.personId,
                            loanId: widget.loan.loanId,
                            isLending: widget.loan.isLending,
                            amount: int.parse(repaymentAmountController.text
                                .replaceAll(',', '')),
                          );
                          await ref
                              .read(appViewModelProvider.notifier)
                              .createRepayment(newRepayment);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "${repaymentAmountController.text}원이 상환 처리되었습니다."),
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
      ),
    );
  }
}
