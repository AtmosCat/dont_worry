import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/person_detail/person_detail_page.dart';
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
    int amount = 100;
    int totalRepayment = 0;
    /*TODO: 금액 관련 데이터를 구하는 로직 개발 필요
    
    개발사항 1. amount :갚아야 할 남은 금액
      모든 loan의 잔여대출액 remainingLoanAmount 총합

    개발사항 2. totalRepayment : 이미 갚은 금액
      모든 loan의 상환액 totalRepaymentAmount 총합
    
    활용. PersonCard 좌하단에 금액 노출.
      미상환 시, 갚아야 할 amount 노출
      전액상환 시, 그동안 갚은 totalRepayment 노출

    주의. 재사용할 가능성이 있습니다.
    가급적 Person 클래스 내에서 메서드로 구현해주세요.
    */

    int dDay = 3;
    DateTime lastRepaymentDate = DateTime(2025, 2, 7);
    /*TODO: 날짜 관련 데이터 구하는 로직 개발 필요

    개발사항 1. dDay : 다가오는 상환일
      미상환 loan의 변제일 중 가장 이른 날짜와 현재 날짜 간의 D-day
      양수일 경우, D-3으로 표기
      0일 경우, D-day로 표기
      음수일 경우, '연체 중'으로 표기

    개발사항 2. lastRepaymentDate : 가장 최근에 상환한 날짜
      모든 loan의 repayment의 date 중 가장 늦은 날짜

    활용. PersonCard 우상단에 디데이, 날짜 노출
      미상환 시, 다가오는 대출의 dDay 노출
      전액상환 시, 마지막에 전액 상환한 lastRepaymentDate 노출

    주의. 재사용할 가능성이 있습니다.
    가급적 Person 클래스 내에서 메서드로 구현해주세요.
    */

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PersonDetailPage(myAction, person: person)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 0,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.none,
          elevation: 1,
          shadowColor: AppColor.shadowBlack.of(context), // 빨간 그림자
          color: amount != 0 // 상환여부 따라 배경색 변경
              ? AppColor.containerWhite.of(context)
              : AppColor.containerLightGray20.of(context),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    person.name,
                    style: TextStyle(
                        color: amount != 0 // 상환여부 따라 글씨색상 변경
                            ? AppColor.defaultBlack.of(context)
                            : AppColor.disabled.of(context),
                        fontSize: 16),
                  ),
                  Spacer(),
                  // 디데이 날짜 위젯 : 상환 여부에 따라 amount 또는 totalRepayment 표시
                  Visibility(
                    visible: amount != 0,
                    // 상환 완료 시,
                    replacement: Text(
                        '${lastRepaymentDate.year}.${lastRepaymentDate.month}.${lastRepaymentDate.day} ',
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColor.disabled.of(context))),
                    // 미상환 시,
                    child: Text(
                        dDay > 0
                            ? 'D-$dDay'
                            : dDay == 0
                                ? 'D-day'
                                : '연체 중',
                        style: TextStyle(
                            fontSize: 13,
                            color: dDay > 0
                                ? AppColor.primaryBlue.of(context)
                                : AppColor.primaryRed.of(context),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 금액 위젯
                  Text.rich(
                    style: TextStyle(
                      color: amount != 0
                          ? AppColor.defaultBlack.of(context)
                          : AppColor.disabled.of(context), // 상환 여부에 따라 색상변경
                    ),
                    TextSpan(
                      children: [
                        TextSpan(
                          text: NumberUtils.formatWithCommas(amount != 0
                              ? amount
                              : totalRepayment), // 상환 여부에 따라 amount 또는 totalRepayment
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.7,
                          ),
                        ),
                        const TextSpan(
                          text: ' 원',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.lightGray20.of(context),
                    size: 20,
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
