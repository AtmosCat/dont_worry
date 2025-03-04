import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/person_detail/widgets/repayment_for_person_button.dart';
import 'package:dont_worry/utils/enum.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonDetailHeader extends StatelessWidget {
  final String personId;
  final bool isLending;
  const PersonDetailHeader({
    required this.personId,
    required this.isLending,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      Person person = ref.watch(appViewModelProvider.select((state) =>
          state.people.firstWhere((element) => element.personId == personId)));
      bool isRepaid = isLending ? person.isLendPaidOff : person.isBorrowPaidOff;

      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            color: AppColor.containerWhite.of(context),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                person.name,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(person.memo ?? '',
                  style: TextStyle(
                      fontSize: 14, color: AppColor.disabled.of(context))),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('남은 금액',
                      style: TextStyle(
                          fontSize: 16, color: AppColor.disabled.of(context))),
                  SizedBox(
                    width: 14,
                  ),
                  Text(
                    NumberUtils.formatWithCommas(isLending
                        ? person.remainingLendAmount
                        : person.remainingBorrowAmount),
                    style: TextStyle(
                        letterSpacing: -0.7,
                        color: AppColor.deepBlack.of(context),
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text('원', style: TextStyle(fontSize: 20)),
                ],
              ),
              Offstage(
                offstage: isRepaid,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    RepaymentForPersonButton(
                        isRepaid: isRepaid,
                        isLending: isLending,
                        unitType: UnitType.person,
                        person: person),
                  ],
                ),
              )
            ]),
          ),
          Divider(height: 0, color: AppColor.divider.of(context)),
        ],
      );
    });
  }
}
