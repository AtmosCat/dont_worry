import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/loan_detail/widgets/repayment_card.dart';
import 'package:dont_worry/ui/widgets/repayment_progress_indicator.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoanDetailRepaymentSection extends StatelessWidget {
  LoanDetailRepaymentSection({
    super.key,
    required this.isLending,
    required this.loanId,
    required this.totalRepayment,
    required this.initialAmount,
    required this.repaymentRate,

  });

  final bool isLending;
  final String loanId;
  final int totalRepayment;
  final int initialAmount;
  final double repaymentRate;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: totalRepayment > 0,
      replacement: _noRepaymentMessage(context),
      child: Column(
        children: [
          Visibility(
            visible: repaymentRate < 1,
            replacement: _fullyRepaymentMessage(context),
            child: _repaymentInProgress(context),
          ),
          SizedBox(height: 50),
          Row(
            children: [
              Text('상환 내역',
                  style: TextStyle(
                      fontSize: 16, color: AppColor.gray10.of(context)))
            ],
          ),
          SizedBox(height: 30),
          repaymentList(),
          SizedBox(height: 60)
        ],
      ),
    );
  }

  Consumer repaymentList() {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      var repaymentsState = ref.watch(appViewModelProvider.select(
        (state) => state.repayments.where((repayment)=>repayment.loanId == loanId).toList()
      ));
      return repaymentsState.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: List.generate(repaymentsState.length,
                  (index) => RepaymentCard(repayment: repaymentsState[index])));
    });
  }

  // 갚는 중일 때 진행률 표기
  Column _repaymentInProgress(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Text(isLending ? '받은 금액' : '갚은 금액',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.gray20.of(context),
                  fontWeight: FontWeight.w600)),
          Spacer(),
          Text('${NumberUtils.formatWithCommas(totalRepayment)}원',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.gray20.of(context),
                  fontWeight: FontWeight.w800))
        ]),
        SizedBox(height: 50),
        RepaymentProgressIndicator(
          repaymentRate: repaymentRate,
          initialAmount: initialAmount,
        ),
      ],
    );
  }

  // 상환 100% 메시지
  Row _fullyRepaymentMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          color: AppColor.primaryBlue.of(context),
        ),
        SizedBox(width: 10),
        Text(isLending ? '빌려준 금액을 전부 받았어요' : '빌린 금액을 전부 갚았어요',
            style: TextStyle(
                fontSize: 16,
                color: AppColor.primaryBlue.of(context),
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  // 상환 0% 메시지
  Row _noRepaymentMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error),
        SizedBox(width: 10),
        Text('아직 상환한 금액이 없어요',
            style: TextStyle(
                fontSize: 16,
                color: AppColor.gray20.of(context),
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
