import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/loan_list/widgets/loan_card.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/ui/widgets/detail_bottom_navigation_bar.dart';
import 'package:dont_worry/ui/widgets/list_header.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class LoanListPage extends StatelessWidget {
  final MyAction myAction;
  final Person person;
  const LoanListPage(this.myAction, {required this.person, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar(myAction, Category.person),
      body: ListView(
        children: [
          LoanListHeader(person: person),
          SizedBox(height: 10),
          ListHeader(
            myAction: myAction,
            category: Category.loan,
          ),
          LoanCard(
              myAction: myAction,
              loan: Loan(
                isLending: true, // 빌려주는 돈
                initialAmount: 100000,
                repayments: [
                  Repayment(amount: 300, date: DateTime(2024, 2, 1))
                ],
                loanDate: DateTime(2024, 2, 1),
                dueDate: DateTime(2024, 4, 1),
                title: '김철수에게 빌려준 돈',
                memo: '빠른 상환을 부탁드립니다.',
              )),
          LoanCard(
              myAction: myAction,
              loan: Loan(
                isLending: true, // 빌려주는 돈
                initialAmount: 100000,
                repayments: [
                  Repayment(amount: 300, date: DateTime(2024, 2, 1))
                ],
                loanDate: DateTime(2024, 2, 1),
                dueDate: DateTime(2024, 4, 1),
                title: '김철수에게 빌려준 돈',
                memo: '빠른 상환을 부탁드립니다.',
              )),
          SizedBox(height: 10),
          ListHeader(category: Category.loan),
          LoanCard(
              myAction: myAction,
              loan: Loan(
                isLending: true, // 빌려주는 돈
                initialAmount: 100000,
                repayments: [
                  Repayment(amount: 300, date: DateTime(2024, 2, 1))
                ],
                loanDate: DateTime(2024, 2, 1),
                dueDate: DateTime(2024, 4, 1),
                title: '김철수에게 빌려준 돈',
                memo: '빠른 상환을 부탁드립니다.',
              )),
          SizedBox(height: 60)
        ],
      ),
      bottomNavigationBar: DetailBottomNavigationBar(
          myAction: myAction, category: Category.person),
    );
  }
}

class LoanListHeader extends StatelessWidget {
  final Person person;
  final int totalAmount = 100000;
  const LoanListHeader({
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
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              person.memo ?? '',
              style:
                  TextStyle(fontSize: 14, color: AppColor.disabled.of(context)),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '남은 금액',
                  style: TextStyle(
                      fontSize: 16, color: AppColor.disabled.of(context)),
                ),
                SizedBox(
                  width: 14,
                ),
                Text(
                  NumberUtils.formatWithCommas(totalAmount),
                  style: TextStyle(
                    letterSpacing: -0.7,
                    color: AppColor.deepBlack.of(context),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '원',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ]),
        ),
        Divider(height: 0, color: AppColor.divider.of(context)),
      ],
    );
  }
}
