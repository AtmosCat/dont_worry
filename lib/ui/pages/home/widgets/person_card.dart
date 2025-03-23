import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/person_detail/person_detail_page.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final bool isLending;

  const PersonCard({
    required this.person,
    required this.isLending,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int remainingAmount =
        isLending ? person.remainingLendAmount : person.remainingBorrowAmount;
    int repaidAmount =
        isLending ? person.repaidLendAmount : person.repaidBorrowAmount;
    DateTime? upcomingDueDate =
        isLending ? person.upcomingLendDueDate : person.upcomingBorrowDueDate;
    int? dDay = upcomingDueDate == null
        ? null
        : DateTime.now().difference(upcomingDueDate).inDays;
    DateTime? lastRepaidDate =
        isLending ? person.lastLendRepaidDate : person.lastBorrowRepaidDate;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PersonDetailPage(isLending: isLending, person: person)),
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
          color: remainingAmount != 0 // 상환여부 따라 배경색 변경
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
                        color: remainingAmount != 0 // 상환여부 따라 글씨색상 변경
                            ? AppColor.defaultBlack.of(context)
                            : AppColor.disabled.of(context),
                        fontSize: 16),
                  ),
                  Spacer(),
                  // 디데이 날짜 위젯 : 상환 여부에 따라 amount 또는 totalRepayment 표시
                  Visibility(
                    visible: remainingAmount != 0,
                    // 상환 완료 시,
                    replacement: Text(
                        lastRepaidDate == null
                            ? ''
                            : '${lastRepaidDate.year}.${lastRepaidDate.month}.${lastRepaidDate.day} ',
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColor.disabled.of(context))),
                    // 미상환 시,
                    child: Text(
                        dDay == null
                            ? ''
                            : dDay < 0
                                ? 'D$dDay'
                                : dDay == 0
                                    ? 'D-day'
                                    : '연체 중',
                        style: TextStyle(
                            fontSize: 13,
                            color: dDay == null || dDay < 0
                                ? isLending
                                    ? AppColor.primaryYellow.of(context)
                                    : AppColor.primaryGreen.of(context)
                                : AppColor.negative.of(context),
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
                      color: remainingAmount != 0
                          ? AppColor.defaultBlack.of(context)
                          : AppColor.disabled.of(context), // 상환 여부에 따라 색상변경
                    ),
                    TextSpan(
                      children: [
                        TextSpan(
                          text: NumberUtils.formatWithCommas(remainingAmount !=
                                  0
                              ? remainingAmount
                              : repaidAmount), // 상환 여부에 따라 amount 또는 totalRepayment
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
