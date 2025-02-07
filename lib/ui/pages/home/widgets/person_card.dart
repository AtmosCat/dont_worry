import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/loan_list/loan_list_page.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final MyAction myAction;

  const PersonCard({
    required this.person,
    required this.myAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    int amount = 145603000;
    int dDay = daysUntilUpcomingDueDatedaysUntilDueDate(person.loans);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoanListPage(MyAction.lend, Category.person)),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  person.name,
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.05),
                  ),
                  padding: EdgeInsets.only(
                    top: 6,
                    bottom: 6,
                    left: 14,
                    right: 12,
                  ),
                  child: Row(
                    children: [
                      Text(
                          person.loans.length == 0
                              ? '완료'
                              : '${person.loans.length}건',
                          style: TextStyle(
                              color: AppColor.disabled.of(context),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor.disabled.of(context),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Offstage(
                  offstage: person.loans.length == 0,
                  child: Text(NumberUtils.formatWithCommas(amount),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.7)),
                ),
                Text(person.loans.length == 0 ? '2024.10.24' : ' 원',
                    style: TextStyle(
                      fontSize: 12,
                    )),
                Spacer(),
                Text(
                    person.loans.length == 0
                        ? '총 ${person.loans.length}건을 다 갚았어요!'
                        : 'D-$dDay',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColor.primaryBlue.of(context),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}