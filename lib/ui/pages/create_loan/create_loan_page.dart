import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/repository/user_repository.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/create_loan/person_search_list.dart';
import 'package:dont_worry/ui/pages/home/home_page.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/utils/datetime_utils.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';

class CreateLoanPage extends StatelessWidget {
  final nameEdittingController = TextEditingController();
  final amountEdittingController = TextEditingController();
  final titleEdittingController = TextEditingController();
  final memoEdittingController = TextEditingController();

  DateTime loanDate = DateTime.now();
  DateTime dueDate = DateTime.now();

  final MyAction myAction;

  CreateLoanPage({super.key, required this.myAction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'myAction: $myAction',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              PersonSearchList(myAction: myAction),
              SizedBox(height: 20),
              TextFormField(
                controller: titleEdittingController,
                decoration: InputDecoration(
                  labelText: "제목 입력",
                ),
              ),
              TextFormField(
                controller: memoEdittingController,
                decoration: InputDecoration(
                  labelText: "메모 입력",
                ),
              ),
              TextFormField(
                controller: amountEdittingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "대출금액 입력",
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: Text("대출일 선택"),
              ),
              GestureDetector(
                onTap: () async {
                  final selectedDate = await DatetimeUtils.selectDate(context);
                  if (selectedDate != null) {
                    loanDate = selectedDate;
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                      DateTime(loanDate.year, loanDate.month, loanDate.day)
                          .toString()),
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: Text("상환일 선택"),
              ),
              GestureDetector(
                onTap: () async {
                  final selectedDate = await DatetimeUtils.selectDate(context);
                  if (selectedDate != null) {
                    dueDate = selectedDate;
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                      DateTime(dueDate.year, dueDate.month, dueDate.day)
                          .toString()),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  UserRepository userRepository = UserRepository();
                  if (titleEdittingController.text.isEmpty ||
                      amountEdittingController.text.isEmpty) {
                    SnackbarUtil.showSnackBar(context, "제목과 대출금액을 입력해주세요.");
                    return;
                  } else {
                    Loan testData = createTestLoanData(
                        myAction == MyAction.lend ? true : false,
                        nameEdittingController.text,
                        titleEdittingController.text,
                        memoEdittingController.text,
                        int.parse(amountEdittingController.text));
                    if (await userRepository.createLoanData(
                        context: context, loan: testData)) {
                      SnackbarUtil.showSnackBar(
                          context, "테스트 데이터가 Firebase에 추가됨.");
                    }
                  }
                },
                child: Text("테스트 데이터 생성하기"),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

// 공통 더미 데이터 생성
Loan createTestLoanData(
    bool isLending, String name, String title, String memo, int amount) {
  Loan testLendingLoan = Loan(
    isLending: isLending,
    person: Person(name: name, loans: []),
    initialAmount: amount,
    repayments: [],
    dueDate: DateTime(2025, 10, 31),
    loanDate: DateTime.now(),
    title: title,
    memo: memo,
  );
  return testLendingLoan;
}

// 빌려준 돈 더미 데이터 생성
Loan createTestLendingLoan(String name, String title, String memo, int amount) {
  Loan testLendingLoan = Loan(
    isLending: true,
    person: Person(name: name, loans: []),
    initialAmount: amount,
    repayments: [],
    dueDate: DateTime(2025, 10, 31),
    loanDate: DateTime.now(),
    title: title,
    memo: memo,
  );
  return testLendingLoan;
}

// 빌려준 돈 더미 데이터 생성
Loan createTestBorrowingLoan(
    String name, String title, String memo, int amount) {
  Loan testBorrowingLoan = Loan(
    isLending: false,
    person: Person(name: name, loans: []),
    initialAmount: amount,
    repayments: [],
    dueDate: DateTime(2025, 10, 31),
    loanDate: DateTime.now(),
    title: "정아한테 급전 빌림",
    memo: "집 구하는데 보증금 300 부족해서 정아한테 급하게 빌림.",
  );
  return testBorrowingLoan;
}
