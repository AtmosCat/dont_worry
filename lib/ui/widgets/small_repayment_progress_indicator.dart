import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class SmallRepaymentProgressIndicator extends StatelessWidget {
  const SmallRepaymentProgressIndicator({
    super.key,
    required this.repaymentRate,
    required this.initialAmount,
  });

  final double repaymentRate;
  final int initialAmount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: repaymentRate,
          minHeight: 3,
          borderRadius: BorderRadius.circular(20),
          color: AppColor.primaryBlue.of(context),
          backgroundColor: AppColor.lightGray20.of(context),
        ),
        SizedBox(height: 10),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 12,
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
                      color: AppColor.primaryBlue.of(context),
                      fontWeight: FontWeight.bold)),
              TextSpan(text: '을(를) 받았어요!'),
            ],
          ),
        ),
      ],
    );
  }
}
