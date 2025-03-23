import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/home/home_page.dart';
import 'package:dont_worry/ui/widgets/delete_bottom_sheet.dart';
import 'package:dont_worry/utils/enum.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLending;
  final UnitType unitType;
  final Person? person;
  final Loan? loan;

  const DetailAppBar({
    required this.isLending,
    required this.unitType,
    this.person,
    this.loan,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(unitType == UnitType.person
          ? (isLending ? '내가 빌려준 사람' : '내가 빌린 사람')
          : (isLending ? '내가 빌려준 돈' : '내가 빌린 돈')),
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
                    isLending: isLending,
                    unitType: unitType,
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
  final bool isLending;
  final UnitType unitType;
  final Person? person;
  final Loan? loan;

  const _BottomSheet({
    required this.isLending,
    required this.unitType,
    required this.person,
    required this.loan,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          top: 14.0,
          left: 14.0,
          right: 14.0,
          bottom: 40.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Consumer(
              builder: (context, ref, child) => ListTile(
                  leading: Icon(Icons.delete,
                      color: AppColor.primaryRed.of(context)),
                  title: Text(
                    (unitType == UnitType.person) ? '사람 정보 삭제' : '대출 내역 삭제',
                    style: TextStyle(
                        color: AppColor.primaryRed.of(context),
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    final rootContext = context;

                    showDeleteBottomSheet(
                      context: rootContext,
                      onConfirm: () async {
                        Future.delayed(Duration(milliseconds: 100), () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false,
                          );
                        }); // 모든 pop스택 제거 후, 홈으로

                        if (unitType == UnitType.person) {
                          await ref
                              .read(appViewModelProvider.notifier)
                              .deletePerson(person!);
                          SnackbarUtil.showSnackBar(
                              rootContext, "사람 정보가 삭제되었습니다.");
                        } else {
                          await ref
                              .read(appViewModelProvider.notifier)
                              .deleteLoan(loan!);
                          SnackbarUtil.showSnackBar(
                              rootContext, "대출 내역이 삭제되었습니다.");
                        } // 사람/대출 삭제
                      },
                    );
                  }),
            )
          ],
        ));
  }
}
