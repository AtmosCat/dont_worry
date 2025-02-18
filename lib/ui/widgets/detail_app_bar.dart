import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
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
                  if (unitType == UnitType.person) {
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
                  if (unitType == UnitType.person) {
                    // 인물 정보수정
                  } else {
                    // 대출 정보수정
                  }
                  Navigator.pop(context);
                },
              ),
              Consumer(
                builder: (context, ref, child) => ListTile(
                    leading: Icon(Icons.delete,
                        color: AppColor.primaryRed.of(context)),
                    title: Text(
                      '삭제',
                      style: TextStyle(
                          color: AppColor.primaryRed.of(context),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      final rootContext = context; // ✅ 모달 닫기 전, rootContext 저장
                      // ✅ 삭제 확인 콜백 설정
                      var onConfirm = (unitType == UnitType.person)
                          ? () async {
                              Navigator.pop(rootContext);
                              Navigator.pop(rootContext);
                              await ref
                                  .read(appViewModelProvider.notifier)
                                  .deletePerson(person!);
                              SnackbarUtil.showSnackBar(
                                  rootContext, "사람 정보가 삭제되었습니다.");
                            }
                          : () async {
                              Navigator.pop(rootContext); // ✅ 모달 닫기
                              await ref
                                  .read(appViewModelProvider.notifier)
                                  .deleteLoan(loan!);
                              SnackbarUtil.showSnackBar(
                                  rootContext, "대출 내역이 삭제되었습니다.");
                            };

                      // ✅ 삭제 확인 모달 표시
                      showDeleteBottomSheet(
                        context: rootContext,
                        onConfirm: onConfirm,
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
