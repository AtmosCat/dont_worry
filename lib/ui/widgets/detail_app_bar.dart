import 'package:dont_worry/data/ledger_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/widgets/delete_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MyAction { lend, borrow }

enum Category { person, loan, repayment, home }

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MyAction myAction;
  final Category category;
  final Person? person;
  final Loan? loan;

  const DetailAppBar({
    required this.myAction,
    required this.category,
    this.person,
    this.loan,
    super.key,
  });

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
                return _BottomSheet(
                    myAction: myAction,
                    category: category,
                    person: person,
                    loan: loan);
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

class _BottomSheet extends StatelessWidget {
  final MyAction myAction;
  final Category category;
  final Person? person;
  final Loan? loan;

  const _BottomSheet({
    required this.myAction,
    required this.category,
    required this.person,
    required this.loan,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(14.0),
        child: SizedBox(
          height: 200,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.task_alt,
                  color: AppColor.primaryBlue.of(context),
                ),
                title: Text(
                  '전액 상환 완료 (미구현)',
                  style: TextStyle(
                      color: AppColor.primaryBlue.of(context),
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
                  title: Text('편집 (미구현)'),
                  onTap: () {
                    if (category == Category.person) {
                      // 인물 정보수정
                    } else {
                      // 대출 정보수정
                    }
                    Navigator.pop(context);
                  }),
              Consumer(builder:
                  (BuildContext context, WidgetRef ref, Widget? child) {
                return ListTile(
                  leading: Icon(Icons.delete,
                      color: AppColor.primaryRed.of(context)),
                  title: Text('삭제',
                      style: TextStyle(
                          color: AppColor.primaryRed.of(context),
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    showDeleteBottomSheet(
                        context: context,
                        onConfirm: (category == Category.person)
                            ? () async {
                                await ref
                                    .read(ledgerViewModelProvider.notifier)
                                    .deletePerson(person!);
                              }
                            : () async {
                                await ref
                                    .read(ledgerViewModelProvider.notifier)
                                    .deleteLoan(loan!);
                              });
                  },
                );
              })
            ],
          ),
        ));
  }
}
