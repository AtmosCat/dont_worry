import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';

class DetailBottomNavigationBar extends StatelessWidget {
  final MyAction myAction;
  final Category category;
  const DetailBottomNavigationBar({
    required this.myAction,
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Icon(
                      category != Category.loan ? Icons.add : Icons.edit_note,
                      color: AppColor.defaultBlack.of(context),
                    ),
                    Text(category != Category.loan
                        ? myAction == MyAction.lend
                            ? '빌려준 돈 기록'
                            : '빌린 돈 기록'
                        : myAction == MyAction.lend
                            ? '빌려준 돈 편집'
                            : '빌린 돈 편집')
                  ],
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Icon(Icons.task_alt,
                        color: AppColor.primaryBlue.of(context)),
                    Text(myAction == MyAction.lend ? '받은 돈 기록' : '갚은 돈 기록')
                  ],
                ),
                label: ''),
          ],
          onTap: (int index) {
            if (index == 0) {
              // 원하는 동작 추가
            } else if (index == 1) {
              // 원하는 동작 추가
            }
          },
          backgroundColor: AppColor.containerWhite.of(context),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 5,
          type: BottomNavigationBarType.fixed);
  }
}