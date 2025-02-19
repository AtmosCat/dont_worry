import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/widgets/delete_bottom_sheet.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RepaymentCard extends StatelessWidget {
  final Repayment repayment;
  const RepaymentCard({
    required this.repayment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.only(top: 2, bottom: 2, left: 20, right: 6),
            color: AppColor.containerLightGray30.of(context),
            child: Row(children: [
              Text(
                '${repayment.date.year}.${repayment.date.month}.${repayment.date.day}',
                style: TextStyle(
                  color: AppColor.gray20.of(context),
                ),
              ),
              Spacer(),
              Text('${NumberUtils.formatWithCommas(repayment.amount)}원',
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColor.gray20.of(context),
                      fontWeight: FontWeight.bold)),
              Consumer(
                  builder: (context, ref, child) => IconButton(
                      onPressed: () {
                        showDeleteBottomSheet(
                            context: context,
                            onConfirm: () async {
                              await ref
                                  .read(appViewModelProvider.notifier)
                                  .deleteRepayment(repayment);
                            });
                      },
                      icon: Icon(Icons.close)))
            ])),
        SizedBox(height: 2),
      ],
    );
  }
}
