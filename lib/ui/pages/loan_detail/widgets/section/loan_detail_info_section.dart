import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/number_utils.dart';
import 'package:flutter/material.dart';

class LoanDetailInfoSection extends StatelessWidget {
  const LoanDetailInfoSection({
    super.key,
    required this.isLending,
    required this.initialAmount,
    required this.name,
    required this.loanDate,
    this.dueDate,
    required this.dDay,
  });

  final bool isLending;
  final int initialAmount;
  final String name;
  final DateTime loanDate;
  final DateTime? dueDate;
  final int dDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Text('전체 금액',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.gray20.of(context),
                  fontWeight: FontWeight.w600)),
          Spacer(),
          Text('${NumberUtils.formatWithCommas(initialAmount)}원',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.gray20.of(context),
                  fontWeight: FontWeight.w800))
        ]),
        SizedBox(height: 10),
        Row(children: [
          Text(isLending ? '빌린 사람' : '빌려준 사람',
              style:
                  TextStyle(fontSize: 16, color: AppColor.gray10.of(context))),
          Spacer(),
          Text(name,
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.gray20.of(context),
                  fontWeight: FontWeight.w600))
        ]),
        SizedBox(height: 10),
        Row(children: [
          Text(isLending ? '빌린 날짜' : '빌려준 날짜',
              style:
                  TextStyle(fontSize: 16, color: AppColor.gray10.of(context))),
          Spacer(),
          Text('${loanDate.year}년 ${loanDate.month}월 ${loanDate.day}일',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.gray20.of(context),
                  fontWeight: FontWeight.w600))
        ]),
        SizedBox(height: 10),
        Offstage(
          offstage: dueDate == null,
          child: Column(
            children: [
              Row(children: [
                Text('갚기로 한 날',
                    style: TextStyle(
                        fontSize: 16, color: AppColor.gray10.of(context))),
                Spacer(),
                Text('${dueDate?.year}년 ${dueDate?.month}월 ${dueDate?.day}일',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColor.gray20.of(context),
                        fontWeight: FontWeight.w600))
              ]),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Center(
                  child: Text.rich(TextSpan(
                      style: TextStyle(
                          fontSize: 16, color: AppColor.gray20.of(context)),
                      children: [
                        TextSpan(
                            text: dDay > 0
                                ? '갚기로 한 날까지 '
                                : dDay == 0
                                    ? '갚기로 한 날이 '
                                    : '갚기로 한 날로부터 '),
                        TextSpan(
                            text: dDay > 0
                                ? '$dDay일'
                                : dDay == 0
                                    ? '오늘'
                                    : '${-dDay}일',
                            style: TextStyle(
                                color: dDay > 0
                                    ? AppColor.primaryYellow.of(context)
                                    : AppColor.primaryGreen.of(context),
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: dDay > 0
                                ? ' 남았어요'
                                : dDay == 0
                                    ? '이예요'
                                    : ' 지났어요'),
                      ])),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}