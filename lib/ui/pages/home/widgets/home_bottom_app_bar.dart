import 'package:dont_worry/data/ledger_view_model.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBottomAppBar extends StatelessWidget {
  final TabController _tabController;
  const HomeBottomAppBar(this._tabController, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _tabController.animation!,
        builder: (context, child) {
          final double value = _tabController.animation!.value;
          final int currentIndex = (value + 0.5).floor();
          final bool isLending =
              currentIndex == 0 ? true : false;
          return Container(
            decoration: BoxDecoration(
                color: AppColor.containerWhite.of(context),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // 그림자 색상
                    blurRadius: 30, // 흐림 정도
                    spreadRadius: 6, // 그림자 크기
                    offset: Offset(0, -4), // ⬆ 위쪽 그림자 (기본은 아래로 가므로 -값)
                  )
                ]),
            child: BottomAppBar(
              padding: EdgeInsets.all(0),
              color: Colors.transparent,
              elevation: 0,
              child: GestureDetector(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(height: 0, color: AppColor.divider.of(context)),
                    SizedBox(
                      height: 14,
                    ),
                    Icon(
                      Icons.add,
                      size: 30,
                      color: isLending
                          ? AppColor.primaryBlue.of(context)
                          : AppColor.primaryRed.of(context),
                    ),
                    Text(isLending ? '빌려준 돈 기록' : '빌린 돈 기록'),
                  ],
                ),
                onTap: () {
                  final nameController = TextEditingController();
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                          padding: EdgeInsets.all(50),
                          child: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    labelText: '이름',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: AppColor.containerLightGray30
                                        .of(context),
                                    contentPadding: EdgeInsets.all(14)),
                              ),
                              Consumer(
                                builder: (BuildContext context, WidgetRef ref,
                                    Widget? child) {
                                  return ElevatedButton(
                                      onPressed: () {
                                        createPerson(
                                            context: context,
                                            ref: ref,
                                            name: nameController.text);
                                        Navigator.pop(context);
                                      },
                                      child: Text('0원짜리 인물 생성'));
                                },
                              )
                            ],
                          )));
                },
              ),
            ),
          );
        });
  }

  void createPerson(
      {required BuildContext context,
      required WidgetRef ref,
      required String name}) async {
    Person newPerson = Person(name: name);
    await ref.read(ledgerViewModelProvider.notifier).createPerson(newPerson);
  }
}
