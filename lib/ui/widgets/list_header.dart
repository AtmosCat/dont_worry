
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';

class ListHeader extends StatefulWidget {
  final MyAction? myAction;
  const ListHeader({this.myAction, super.key});

  @override
  State<ListHeader> createState() => _ListHeaderState();
}

class _ListHeaderState extends State<ListHeader> {
  String selectedSortOption = '업데이트 순';

  @override
  Widget build(BuildContext context) {

    String title = '';
    if (widget.myAction == MyAction.lend) {
      title = '내가 빌려준 돈';
    } else if (widget.myAction == MyAction.borrow) {
      title = '내가 빌린 돈';
    } else {
      title = '이미 다 갚았어요';
    }

    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: SizedBox(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 14),
            Text(title,
                style: TextStyle(fontSize: 16, color: AppColor.defaultBlack.of(context))),
            Spacer(),
            Offstage(
              offstage: widget.myAction == null,
              child: PopupMenuButton(
                  icon: Row(
                    children: [
                      Text(
                        selectedSortOption,
                        style: TextStyle(color: AppColor.gray20.of(context)),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: AppColor.gray20.of(context),
                      )
                    ],
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text('업데이트 순'),
                        value: '업데이트 순',
                      ),
                      PopupMenuItem(
                        child: Text('높은 가격 순'),
                        value: '높은 가격 순',
                      ),
                    ];
                  },
                  onSelected: (value) {
                    setState(() {
                      selectedSortOption = value; // 선택된 값으로 업데이트
                    });
                    switch (value) {
                      case '업데이트 순':
                        //정렬 로직
                        break;
                      case '높은 가격 순':
                        //정렬 로직
                        break;
                    }
                  }),
            ),
            SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}
