import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';

enum MyAction { lend, borrow }
enum Category { person, loan }

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MyAction myAction;
  final Category category;

  const DetailAppBar(this.myAction, this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(category == Category.person
          ? (myAction == MyAction.lend ? '내가 빌려준 사람' : '내가 빌린 사람')
          : (myAction == MyAction.lend ? '내가 빌려준 돈' : '내가 빌린 돈')),
      centerTitle: true,
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios)),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return DetailAppBarBottomSheet(myAction, category);
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DetailAppBarBottomSheet extends StatelessWidget {
  final MyAction myAction;
  final Category category;

  const DetailAppBarBottomSheet(this.myAction, this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    Color getColor(String colorName) {
      final theme = Theme.of(context).extension<MyColor>();
      return theme?.getColor(colorName) ??
          Colors.transparent; // null일 경우 fallback 값 지정
    }

    return Padding(
        padding: const EdgeInsets.all(14.0),
        child: SizedBox(
          height: 200,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.task_alt,
                  color: getColor('primaryBlue'),
                ),
                title: Text(
                  '전액 상환 완료',
                  style: TextStyle(
                      color: getColor('primaryBlue'),
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  if (category == Category.person) {
                    // 이 사람의 모든 대출을 상환
                  } else {
                    // 이 대출을 상환
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('편집'),
                onTap: () {
                  if (category == Category.person) {
                    // 인물 정보수정
                  } else {
                    // 대출 정보수정
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('삭제'),
                onTap: () {
                  if (category == Category.person) {
                    // 인물 삭제
                  } else {
                    // 대출 삭제
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }
}
