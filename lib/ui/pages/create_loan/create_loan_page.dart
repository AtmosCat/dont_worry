import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/create_loan/search_popup.dart';
import 'package:dont_worry/utils/datetime_utils.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateLoanPage extends StatefulWidget {
  final bool isLending;
  final Person? person;

  CreateLoanPage({
    super.key,
    required this.isLending,
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

  void _showSearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 높이 조절 가능
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Consumer(
            builder: (context, ref, child) => SearchPopup(
                  onSelect: (Person _selectedPerson) {
                    setState(() {
                      people = ref.read(appViewModelProvider).people;
                      selectedPerson = _selectedPerson;
                      selectedPersonName = _selectedPerson.name;
                    });
                    Navigator.pop(context); // 팝업 닫기
                  },
                ));
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
          title: widget.isLending ? Text('빌려준 돈 기록') : Text('빌린 돈 기록'),
          backgroundColor: AppColor.containerWhite.of(context),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
              SizedBox(height: 10),
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
              SizedBox(height: 10),
              TextFormField(
                controller: dueDateEdittingController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "상환일",
                  labelStyle: TextStyle(color: AppColor.gray30.of(context)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColor.primaryBlue.of(context), width: 2.0),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
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
                  child: Consumer(
                    builder: (context, ref, child) => ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColor.primaryBlue.of(context)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
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
                            isLending: widget.isLending ? true : false,
                            initialAmount:
                                int.parse(amountEdittingController.text),
                            loanDate: DateTime(
                                loanDate.year, loanDate.month, loanDate.day),
                            dueDate: DateTime(
                                dueDate.year, dueDate.month, dueDate.day),
                            title: titleEdittingController.text,
                            memo: memoEdittingController.text,
                          );
                          await ref.read(appViewModelProvider.notifier).createLoan(newLoan);
                          SnackbarUtil.showSnackBar(context, "기록이 추가되었습니다.");
                          Navigator.pop(context);
                          // if (loanUpdateResult) {
                          //   SnackbarUtil.showSnackBar(context, "기록이 추가되었습니다.");
                          //   Navigator.pop(context);
                          // } else {
                          //   SnackbarUtil.showSnackBar(
                          //       context, "기록 추가에 실패했습니다.");
                          // }
                        }
                      },
                      child: Text(
                        // "${widget.isLending ? "빌려준 돈" : "빌린 돈"} 기록 추가하기",
                        "추가하기",
                        style: TextStyle(
                          color: AppColor.containerWhite.of(context),
                        ),
                      ),
                    ),
                  )),
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
      keyboardType: _controller != amountEdittingController
          ? TextInputType.text
          : TextInputType.number,
      inputFormatters: _controller != amountEdittingController
          ? []
          : [FilteringTextInputFormatter.digitsOnly],
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
