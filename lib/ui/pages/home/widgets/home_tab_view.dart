import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/create_loan/create_loan_page.dart';
import 'package:dont_worry/ui/pages/home/widgets/person_card.dart';
import 'package:dont_worry/ui/widgets/list_header.dart';
import 'package:dont_worry/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTabView extends StatefulWidget {
  final bool isLending;
  const HomeTabView({
    required this.isLending,
    super.key,
  });

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  bool? isSortedByUpdate;

  @override
  void initState() {
    super.initState();
    isSortedByUpdate = true;
  }

  void onSortOptionSelected(String value) {
    setState(() {
      isSortedByUpdate = value == '업데이트 순';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var statePeople = ref.watch(appViewModelProvider.select((state) =>
          state.people.where((person) =>
              widget.isLending ? person.hasLend : person.hasBorrow)));
      var inPaidList = statePeople
          .where((person) => widget.isLending
              ? !person.isLendPaidOff
              : !person.isBorrowPaidOff)
          .toList();
      var paidOffList = statePeople
          .where((person) =>
              widget.isLending ? person.isLendPaidOff : person.isBorrowPaidOff)
          .toList();

      // 업데이트 순 정렬
      if (isSortedByUpdate ?? true) {
        inPaidList.sort((b, a) => a.updatedAt.compareTo(b.updatedAt));
        paidOffList.sort((b, a) => a.updatedAt.compareTo(b.updatedAt));
      }

      // 높은 가격 순 정렬 (대출 금액 기준)
      else if (widget.isLending) {
        inPaidList.sort(
            (b, a) => a.remainingLendAmount.compareTo(b.remainingLendAmount));
        paidOffList
            .sort((b, a) => a.repaidLendAmount.compareTo(b.repaidLendAmount));
      } else {
        inPaidList.sort((b, a) =>
            a.remainingBorrowAmount.compareTo(b.remainingBorrowAmount));
        paidOffList.sort(
            (b, a) => a.repaidBorrowAmount.compareTo(b.repaidBorrowAmount));
      }

      return Visibility(
        visible: statePeople.isNotEmpty,
        replacement: replacement(context),
        child: ListView(padding: EdgeInsets.all(4), children: [
          Offstage(
              offstage: inPaidList.isEmpty,
              child: Column(
                children: [
                  ListHeader(
                    isLending: widget.isLending,
                    unitType: UnitType.person,
                    onSortOptionSelected: onSortOptionSelected, 
                  ),
                  personList(
                      isLending: widget.isLending, peopleState: inPaidList),
                ],
              )),
          Offstage(
              offstage: paidOffList.isEmpty,
              child: Column(children: [
                ListHeader(
                  unitType: UnitType.person,
                  onSortOptionSelected: onSortOptionSelected,
                ),
                personList(
                    isLending: widget.isLending, peopleState: paidOffList),
              ])),
          SizedBox(height: 60)
        ]),
      );
    });
  }

  Widget personList({required bool isLending, required peopleState}) {
    return peopleState.isEmpty
        ? const Center(child: CircularProgressIndicator()) // 로딩 중
        : Column(
            children: List.generate(
              peopleState.length,
              (index) =>
                  PersonCard(person: peopleState[index], isLending: isLending),
            ),
          );
  }

  Container replacement(BuildContext context) {
    return Container(
        height: 500,
        padding: EdgeInsets.all(4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            IgnorePointer(
              child: Opacity(
                opacity: 0.3,
                child: Column(
                  children: [
                    ListHeader(
                        isLending: widget.isLending,
                        unitType: UnitType.person,
                        onSortOptionSelected: onSortOptionSelected),
                    PersonCard(
                        person: Person(
                            name: '후배 김민수 (밥값)',
                            repaidLendAmount: 18000,
                            lastLendRepaidDate: DateTime.now()),
                        isLending: true),
                    PersonCard(
                        person: Person(
                            name: '동생 이사비용',
                            repaidLendAmount: 250000,
                            lastLendRepaidDate: DateTime.now()),
                        isLending: true)
                  ],
                ),
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon(Icons.block,
                  //     size: 100,
                  //     color: AppColor.deepBlack.of(context),
                  //     shadows: [
                  //       Shadow(
                  //           offset: Offset(1.0, 1.0),
                  //           color: AppColor.onPrimaryWhite.of(context),
                  //           blurRadius: 2),
                  //       Shadow(
                  //           offset: Offset(-1.0, -1.0),
                  //           color: AppColor.onPrimaryWhite.of(context),
                  //           blurRadius: 2),
                  //       Shadow(
                  //           offset: Offset(1.0, -1.0),
                  //           color: AppColor.onPrimaryWhite.of(context),
                  //           blurRadius: 2),
                  //       Shadow(
                  //           offset: Offset(-1.0, 1.0),
                  //           color: AppColor.onPrimaryWhite.of(context),
                  //           blurRadius: 2),
                  //     ]),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Text(
                    widget.isLending ? '아직 빌려준 기록이 없습니다' : '아직 빌린 기록이 없습니다',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: widget.isLending
                            ? AppColor.primaryYellow.of(context)
                            : AppColor.primaryGreen.of(context),
                        shadows: [
                          Shadow(
                              offset: Offset(2.0, 2.0),
                              color: AppColor.onPrimaryWhite.of(context),
                              blurRadius: 2),
                          Shadow(
                              offset: Offset(-2.0, -2.0),
                              color: AppColor.onPrimaryWhite.of(context),
                              blurRadius: 2),
                          Shadow(
                              offset: Offset(2.0, -2.0),
                              color: AppColor.onPrimaryWhite.of(context),
                              blurRadius: 2),
                          Shadow(
                              offset: Offset(-2.0, 2.0),
                              color: AppColor.onPrimaryWhite.of(context),
                              blurRadius: 2),
                        ]),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.isLending
                        ? '받아야 할 금액을 기록하고 관리해보세요'
                        : '갚아야 할 금액을 기록하고 관리해보세요',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColor.gray30.of(context),
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ]),
          ],
        ));
  }
}
