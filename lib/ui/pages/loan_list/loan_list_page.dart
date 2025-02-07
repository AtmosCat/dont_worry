import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/home/widgets/person_card.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/ui/widgets/list_header.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class LoanListPage extends StatelessWidget {
  final MyAction myAction;
  final Category category;
  const LoanListPage(this.myAction, this.category, {super.key});

  @override
  Widget build(BuildContext context) {

    int totalAmount = 30000000;
    String name = '김철수 선생님(Android 4기)';
    String memo =
        '소액만 빌려가는 친구, 언제까지 줄 지 말 안함, ㅇㅁㄴㅎㅁㄴㅇㅎㅁㄴㅇㅎㅇㄴㅁㅎㅇㄴㅁㅎㅁㄴㅎㅁㄴㅎㅁㄴㅎㅁㄴ\n 내용이 있는 경우만 노출합니다. 없으면 위젯 자체가 숨겨짐';

    return Scaffold(
        appBar: DetailAppBar(myAction, category),
        body: ListView(
          children: [
            Container(
              color: AppColor.containerWhite.of(context),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        memo,
                        style: TextStyle(
                            fontSize: 14, color: AppColor.disabled.of(context)),
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
                                fontSize: 16,
                                color: AppColor.disabled.of(context)),
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
                      SizedBox()
                    ]),
              ),
            ),
            ListHeader(myAction: myAction),
            PersonCard(person:Person(
            name: '홍길동',
            loans: [
              Loan(
                isLending: true, // 빌려준 돈
                person: Person(
                  name: '김철수',
                  loans: [],
                  memo: '친구',
                ),
                initialAmount: 10000, // 1만원
                repayments: [
                  Repayment(amount: 5000, date: DateTime(2024, 10, 26)),
                ], // 5천원 상환
                loanDate: DateTime(2024, 10, 25), // 2024년 10월 25일
                dueDate: DateTime(2024, 11, 24), // 2024년 11월 24일
                title: '간식값',
                memo: '내일까지 갚아라',
              )
            ], // 빈 리스트
            memo: '특이사항 없음',
          ), myAction: myAction),
            ListHeader(),
            PersonCard(
          myAction: myAction,
          person: Person(
            name: '다가픔',
            loans: [], // 빈 리스트
            memo: '특이사항 없음',
          )),
          ],
        ));
  }
}
