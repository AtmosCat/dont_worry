import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/repository/sql_loan_crud_repository.dart';
import 'package:dont_worry/data/repository/sql_person_crud_repository.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/create_loan/search_popup.dart';
import 'package:dont_worry/ui/pages/home/home_page.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/utils/datetime_utils.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';

class CreateLoanPage extends StatefulWidget {
  final MyAction myAction;
  final Person? person;

  CreateLoanPage({
    super.key,
    required this.myAction,
    this.person,
  });

  @override
  State<CreateLoanPage> createState() => _CreateLoanPageState();
}

class _CreateLoanPageState extends State<CreateLoanPage> {
  final nameEdittingController = TextEditingController();
  late Person selectedPerson;
  String selectedPersonName = "이름";

  final amountEdittingController = TextEditingController();
  final titleEdittingController = TextEditingController();
  final memoEdittingController = TextEditingController();
  final loanDateEdittingController = TextEditingController();
  final dueDateEdittingController = TextEditingController();

  late final people;

  DateTime loanDate = DateTime.now();
  DateTime dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      selectedPerson = widget.person!;
      selectedPersonName = widget.person!.name;
    }
    loanDateEdittingController.text =
        "${loanDate.year}-${loanDate.month}-${loanDate.day}";
    dueDateEdittingController.text =
        "${dueDate.year}-${dueDate.month}-${dueDate.day}";
  }

  void getPeople() async {
    people = await SqlPersonCrudRepository.getList();
  }

  void _showSearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 높이 조절 가능
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SearchPopup(
          onSelect: (Person _selectedPerson) {
            setState(() {
              selectedPerson = _selectedPerson;
              selectedPersonName = _selectedPerson.name;
            });
            Navigator.pop(context); // 팝업 닫기
          },
        );
      },
    );
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
              GestureDetector(
                onTap: _showSearchModal,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: nameEdittingController,
                    decoration: InputDecoration(
                      labelText: selectedPersonName,
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
                controller: dueDateEdittingController, // 컨트롤러 사용
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
                      dueDate = selectedDate;
                      dueDateEdittingController.text =
                          "${dueDate.year}-${dueDate.month}-${dueDate.day}"; // 선택한 날짜 적용
                    });
                  }
                },
              ),
              Spacer(),
              Container(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColor.primaryBlue.of(context)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                  ),
                  onPressed: () async {
                    if (titleEdittingController.text.isEmpty) {
                      SnackbarUtil.showSnackBar(context, "제목을 입력해주세요.");
                      return;
                    } else if (amountEdittingController.text.isEmpty) {
                      SnackbarUtil.showSnackBar(context, "금액을 입력해주세요.");
                      return;
                    } else if (selectedPersonName.isEmpty) {
                      SnackbarUtil.showSnackBar(context, "이름을 입력해주세요.");
                      return;
                    } else if (loanDateEdittingController.text.isEmpty) {
                      SnackbarUtil.showSnackBar(context, "대출일을 선택해주세요.");
                    } else if (dueDateEdittingController.text.isEmpty) {
                      SnackbarUtil.showSnackBar(context, "상환일을 선택해주세요.");
                    } else {
                      Loan newLoan = Loan(
                        personId: selectedPerson.personId,
                        isLending:
                            widget.myAction == MyAction.lend ? true : false,
                        initialAmount: int.parse(amountEdittingController.text),
                        repayments: [],
                        loanDate: DateTime(
                            loanDate.year, loanDate.month, loanDate.day),
                        dueDate:
                            DateTime(dueDate.year, dueDate.month, dueDate.day),
                        title: titleEdittingController.text,
                        memo: memoEdittingController.text,
                      );
                      var result = await SqlLoanCrudRepository.create(newLoan);
                      if (result) {
                        SnackbarUtil.showSnackBar(context, "기록이 추가되었습니다.");
                        Navigator.pop(context);
                      } else {
                        SnackbarUtil.showSnackBar(context, "기록 추가에 실패했습니다.");
                      }
                    }
                  },
                  child: Text(
                    // "${widget.myAction == MyAction.lend ? "빌려준 돈" : "빌린 돈"} 기록 추가하기",
                    "추가하기",
                    style: TextStyle(
                      color: AppColor.containerWhite.of(context),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
