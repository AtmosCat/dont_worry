import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class RepaymentProgressIndicator extends StatelessWidget {
  const RepaymentProgressIndicator({
    super.key,
    required this.repaymentRate,
    required this.initialAmount,
    required this.isLending,
  });

  final double repaymentRate;
  final int initialAmount;
  final bool isLending;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        LinearProgressIndicator(
          value: repaymentRate,
          minHeight: 4,
          borderRadius: BorderRadius.circular(20),
          color: isLending ? AppColor.primaryYellow.of(context) : AppColor.primaryGreen.of(context),
          backgroundColor: AppColor.lightGray20.of(context),
        ),
        SizedBox(height: 10),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: AppColor.gray20.of(context),
            ),
            children: [
              TextSpan(text: '전체 금액 '),
              TextSpan(
                  text:
                      '${NumberUtils.formatWithCommas(initialAmount)}원',
                  style: TextStyle(
                      color: AppColor.gray30.of(context),
                      fontWeight: FontWeight.bold)),
              TextSpan(text: '의 '),
              TextSpan(
                  text: '${(repaymentRate * 100).round().clamp(1, 99)}%',
                  style: TextStyle(
                      color: isLending ? AppColor.primaryYellow.of(context) : AppColor.primaryGreen.of(context),
                      fontWeight: FontWeight.bold)),
              TextSpan(text: '을(를) 받았어요!'),
            ],
          ),
        ),
      ],
    );
  }
}
