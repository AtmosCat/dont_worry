import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';

class RepaymentButton extends StatelessWidget {
  final bool isRepaid;

  const RepaymentButton({
    super.key,
    required this.isRepaid,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isRepaid,
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