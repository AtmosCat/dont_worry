import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RepaymentButton extends StatefulWidget {
  final bool isRepaid;
  final Loan loan;
  const RepaymentButton({
    super.key,
    required this.isRepaid,
    required this.loan,
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
          /* TODO: 해당 Loan을 전액 상환하는 로직 개발 필요 */
          showDialog(
            context: context,
            builder: (context) {
              final TextEditingController repaymentAmountController =
                  TextEditingController(text: "${widget.loan.initialAmount}");
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
                        final newRepayment = Repayment(
                          personId: widget.loan.personId,
                          loanId: widget.loan.loanId,
                          isLending: widget.loan.isLending,
                          amount: int.parse(repaymentAmountController.text),
                        );
                        await ref
                            .read(appViewModelProvider.notifier)
                            .createRepayment(newRepayment);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "${int.parse(repaymentAmountController.text)}원이 상환 처리되었습니다."),
                          ),
                        );
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
        icon: const Icon(Icons.task_alt, size: 18),
        label: const Text(
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
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          alignment: Alignment.center,
          backgroundColor: AppColor.primaryBlue.of(context),
          foregroundColor: AppColor.onPrimaryWhite.of(context),
          iconColor: AppColor.onPrimaryWhite.of(context),
        ),
      ),
    );
  }
}
