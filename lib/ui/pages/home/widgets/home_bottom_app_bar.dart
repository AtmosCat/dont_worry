import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/data/repository/sql_loan_crud_repository.dart';
import 'package:dont_worry/data/repository/sql_person_crud_repository.dart';
import 'package:dont_worry/data/repository/sql_repayment_crud_repository.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';

class HomeBottomAppBar extends StatelessWidget {
  final MyAction myAction;
  const HomeBottomAppBar({
    required this.myAction,
    super.key,
  });

  void createLoan() async {
    Person newPerson = Person(
      name: '이름',
    );

    Loan newLoan = Loan(
      personId: newPerson.personId,
      isLending: true,
      initialAmount: 970318,
    );

    Repayment newRepayment = Repayment(
      personId: newPerson.personId,
      loanId: newLoan.loanId,
      amount: 3000,
    );

    await SqlRepaymentCrudRepository.create(newRepayment);
    await SqlLoanCrudRepository.create(newLoan);
    await SqlPersonCrudRepository.create(newPerson);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: AppColor.containerWhite.of(context), boxShadow: [
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
          onTap: () {
            createLoan();
          },
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
                color: myAction == MyAction.lend
                    ? AppColor.primaryBlue.of(context)
                    : AppColor.primaryRed.of(context),
              ),
              Text(myAction == MyAction.lend ? '빌려준 돈 기록' : '빌린 돈 기록'),
            ],
          ),
        ),
      ),
    );
  }
}

// myAction == MyAction.lend ?AppColor.containerBlue30.of(context):AppColor.containerRed30.of(context)
