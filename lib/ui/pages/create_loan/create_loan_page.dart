import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/repository/user_repository.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/home/home_page.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';

class CreateLoanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Loan Page"),
        backgroundColor: AppColor.containerWhite.of(context),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          icon: Padding(
            padding: const EdgeInsets.all(0),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColor.defaultBlack.of(context),
            ),
          ),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              UserRepository userRepository = UserRepository();
              Loan testData = createTestLendingLoan();
              if (await userRepository.createLoanData(
                  context: context, loan: testData)) {
                SnackbarUtil.showSnackBar(
                    context, "빌려준 돈 더미 데이터가 Firebase에 추가됨.");
              }
            },
            child: Text("빌려준 돈 더미 데이터 생성!"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              UserRepository userRepository = UserRepository();
              Loan testData = createTestBorrowingLoan();
              if (await userRepository.createLoanData(
                  context: context, loan: testData)) {
                SnackbarUtil.showSnackBar(
                    context, "빌린 돈 더미 데이터가 Firebase에 추가됨.");
              }
            },
            child: Text("빌린 돈 더미 데이터 생성!"),
          ),
        ],
      )),
    );
  }
}

// 빌려준 돈 더미 데이터 생성
Loan createTestLendingLoan() {
  Loan testLendingLoan = Loan(
    isLending: true,
    person: Person(name: "수진", loans: []),
    initialAmount: 2000000,
    repayments: [],
    dueDate: DateTime(2025, 10, 31),
    loanDate: DateTime.now(),
    title: "수진이 급전 빌려줌",
    memo: "수진이가 집 구하는데 보증금 200 부족하다고 빌려감",
  );
  return testLendingLoan;
}

// 빌려준 돈 더미 데이터 생성
Loan createTestBorrowingLoan() {
  Loan testBorrowingLoan = Loan(
    isLending: false,
    person: Person(name: "정아", loans: []),
    initialAmount: 3000000,
    repayments: [],
    dueDate: DateTime(2025, 10, 31),
    loanDate: DateTime.now(),
    title: "정아한테 급전 빌림",
    memo: "집 구하는데 보증금 300 부족해서 정아한테 급하게 빌림.",
  );
  return testBorrowingLoan;
}
