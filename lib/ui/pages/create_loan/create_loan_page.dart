import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/create_loan/person_search_list.dart';
import 'package:dont_worry/ui/pages/home/home_page.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/utils/datetime_utils.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';

class CreateLoanPage extends StatefulWidget {
  final MyAction myAction;
  CreateLoanPage({super.key, required this.myAction});

  @override
  State<CreateLoanPage> createState() => _CreateLoanPageState();
}

class _CreateLoanPageState extends State<CreateLoanPage> {
  final nameEdittingController = TextEditingController();
  final amountEdittingController = TextEditingController();
  final titleEdittingController = TextEditingController();
  final memoEdittingController = TextEditingController();
  final loanDateEdittingController = TextEditingController();
  final dueDateEdittingController = TextEditingController();

  DateTime loanDate = DateTime.now();
  DateTime dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loanDateEdittingController.text =
        "${loanDate.year}-${loanDate.month}-${loanDate.day}"; // 초기 날짜 설정
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.containerWhite.of(context),
        appBar: AppBar(
          centerTitle: true,
          title: widget.myAction == MyAction.lend
              ? Text('빌려준 돈 기록')
              : Text('빌린 돈 기록'),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // PersonSearchList(myAction: myAction),
              // SizedBox(height: 20),
              CreateLoanPageTextFormField(
                context,
                titleEdittingController,
                "제목",
              ),
              SizedBox(height: 10),
              CreateLoanPageTextFormField(
                context,
                amountEdittingController,
                "금액",
              ),
              SizedBox(height: 10),
              CreateLoanPageTextFormField(
                context,
                memoEdittingController,
                "메모",
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: loanDateEdittingController, // 컨트롤러 사용
                readOnly: true, // 직접 입력 방지
                decoration: InputDecoration(
                  labelText: "대출일",
                  labelStyle: TextStyle(color: AppColor.gray30.of(context)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColor.primaryBlue.of(context),
                        width: 2.0), // 포커스 시 테두리 색상
                  ),
                  suffixIcon: Icon(Icons.calendar_today), // 캘린더 아이콘 추가
                  border: OutlineInputBorder(), // 테두리 추가 (선택 사항)
                ),
                onTap: () async {
                  final selectedDate = await DatetimeUtils.selectDate(context);
                  if (selectedDate != null) {
                    setState(() {
                      loanDate = selectedDate;
                      loanDateEdittingController.text =
                          "${loanDate.year}-${loanDate.month}-${loanDate.day}"; // 선택한 날짜 적용
                    });
                  }
                },
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: loanDateEdittingController, // 컨트롤러 사용
                readOnly: true, // 직접 입력 방지
                decoration: InputDecoration(
                  labelText: "상환일",
                  labelStyle: TextStyle(color: AppColor.gray30.of(context)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColor.primaryBlue.of(context),
                        width: 2.0), // 포커스 시 테두리 색상
                  ),
                  suffixIcon: Icon(Icons.calendar_today), // 캘린더 아이콘 추가
                  border: OutlineInputBorder(), // 테두리 추가 (선택 사항)
                ),
                onTap: () async {
                  final selectedDate = await DatetimeUtils.selectDate(context);
                  if (selectedDate != null) {
                    setState(() {
                      loanDate = selectedDate;
                      loanDateEdittingController.text =
                          "${loanDate.year}-${loanDate.month}-${loanDate.day}"; // 선택한 날짜 적용
                    });
                  }
                },
              ),
              Spacer(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (titleEdittingController.text.isEmpty ||
                      amountEdittingController.text.isEmpty) {
                    SnackbarUtil.showSnackBar(context, "제목과 대출금액을 입력해주세요.");
                    return;
                  } else {
                    // Loan testData = createTestLoanData(
                    //     myAction == MyAction.lend ? true : false,
                    //     nameEdittingController.text,
                    //     titleEdittingController.text,
                    //     memoEdittingController.text,
                    //     int.parse(amountEdittingController.text));
                    // // if (await userRepository.createLoanData(
                    // //     context: context, loan: testData)) {
                    // //   SnackbarUtil.showSnackBar(
                    // //       context, "테스트 데이터가 Firebase에 추가됨.");
                    // // }
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

  TextFormField CreateLoanPageTextFormField(
    BuildContext context,
    TextEditingController _controller,
    String _labelText,
  ) {
    return TextFormField(
      maxLines: 1,
      controller: _controller,
      decoration: InputDecoration(
        labelText: _labelText,
        labelStyle: TextStyle(color: AppColor.gray30.of(context)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColor.primaryBlue.of(context),
              width: 2.0), // 포커스 시 테두리 색상
        ),
        suffixIcon: _controller.text.isNotEmpty // 텍스트가 있을 때만 X 버튼 표시
            ? IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: AppColor.gray10.of(context),
                ),
                onPressed: () {
                  _controller.clear(); // 입력 내용 지우기
                },
              )
            : null, // 텍스트가 없을 땐 버튼 숨기기
      ),
    );
  }
}

// // 공통 더미 데이터 생성
// Loan createTestLoanData(
//     bool isLending, String name, String title, String memo, int amount) {
//   Loan testLendingLoan = Loan(
//     isLending: isLending,
//     person: Person(name: name, loans: []),
//     initialAmount: amount,
//     repayments: [],
//     dueDate: DateTime(2025, 10, 31),
//     loanDate: DateTime.now(),
//     title: title,
//     memo: memo,
//   );
//   return testLendingLoan;
// }

// // 빌려준 돈 더미 데이터 생성
// Loan createTestLendingLoan(String name, String title, String memo, int amount) {
//   Loan testLendingLoan = Loan(
//     isLending: true,
//     person: Person(name: name, loans: []),
//     initialAmount: amount,
//     repayments: [],
//     dueDate: DateTime(2025, 10, 31),
//     loanDate: DateTime.now(),
//     title: title,
//     memo: memo,
//   );
//   return testLendingLoan;
// }

// // 빌려준 돈 더미 데이터 생성
// Loan createTestBorrowingLoan(
//     String name, String title, String memo, int amount) {
//   Loan testBorrowingLoan = Loan(
//     isLending: false,
//     person: Person(name: name, loans: []),
//     initialAmount: amount,
//     repayments: [],
//     dueDate: DateTime(2025, 10, 31),
//     loanDate: DateTime.now(),
//     title: "정아한테 급전 빌림",
//     memo: "집 구하는데 보증금 300 부족해서 정아한테 급하게 빌림.",
//   );
//   return testBorrowingLoan;
// }
