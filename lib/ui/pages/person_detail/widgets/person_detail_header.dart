import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class PersonDetailHeader extends StatelessWidget {
  final Person person;
  final int totalAmount = 100000;
  const PersonDetailHeader({
    required this.person,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
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
                  NumberUtils.formatWithCommas(totalAmount),
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
          ]),
        ),
        Divider(height: 0, color: AppColor.divider.of(context)),
      ],
    );
  }
}