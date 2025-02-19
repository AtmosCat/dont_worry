import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';

class CheckAllPossibleLoansCheckbox extends StatefulWidget {
  const CheckAllPossibleLoansCheckbox({super.key});

  @override
  State<CheckAllPossibleLoansCheckbox> createState() =>
      _CheckAllPossibleLoansCheckboxState();
}

class _CheckAllPossibleLoansCheckboxState
    extends State<CheckAllPossibleLoansCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            checkColor: AppColor.containerWhite.of(context),
            activeColor: AppColor.primaryBlue.of(context),
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value ?? false;
              });
            },
          ),
          Text(
            "오래된 내역부터 자동 상환",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
