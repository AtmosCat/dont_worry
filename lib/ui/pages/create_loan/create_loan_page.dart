import 'dart:developer';
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

  const CreateLoanPage({
    super.key,
    required this.isLending,
    this.person,
  });

  @override
  State<CreateLoanPage> createState() => _CreateLoanPageState();
}

class _CreateLoanPageState extends State<CreateLoanPage> {
  final amountEdittingController = TextEditingController();
  final titleEdittingController = TextEditingController();
  final memoEdittingController = TextEditingController();
  final loanDateEdittingController = TextEditingController();
  final dueDateEdittingController = TextEditingController();

  Person? selectedPerson;
  bool? isCreatedPerson;
  DateTime loanDate = DateTime.now();
  DateTime? dueDate;

  @override
  void initState() {
    selectedPerson = widget.person;
    loanDateEdittingController.text =
        "${loanDate.year}년 ${loanDate.month}월 ${loanDate.day}일";
    dueDateEdittingController.text = "미정";
    super.initState();
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
                  onSelect: ({required person, required isCreated}) {
                    setState(() {
                      selectedPerson = person;
                      isCreatedPerson = isCreated;
                    });
                    Navigator.pop(context); // 팝업 닫기
                  }, isLending: widget.isLending,
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
              TextFormField(
                onTap: _showSearchModal,
                controller:
                    TextEditingController(text: selectedPerson?.name ?? ''),
                readOnly: true, // 직접 입력 방지
                decoration: InputDecoration(
                  labelText: "이름",
                  labelStyle: TextStyle(color: AppColor.gray30.of(context)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.isLending ?  AppColor.primaryYellow.of(context) : AppColor.primaryGreen.of(context),
                        width: 2.0), // 포커스 시 테두리 색상
                  ),
                  suffixIcon: Icon(Icons.search), // 캘린더 아이콘 추가
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
                controller: TextEditingController(
                    text:
                        "${loanDate.year}년 ${loanDate.month}월 ${loanDate.day}일"),
                readOnly: true, // 직접 입력 방지
                decoration: InputDecoration(
                  labelText: "대출일",
                  labelStyle: TextStyle(color: AppColor.gray30.of(context)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.isLending ?  AppColor.primaryYellow.of(context) : AppColor.primaryGreen.of(context),
                        width: 2.0), // 포커스 시 테두리 색상
                  ),
                  suffixIcon: Icon(Icons.calendar_today), // 캘린더 아이콘 추가
                ),
                onTap: () async {
                  final selectedDate = await DatetimeUtils.selectDate(
                      context: context, initialDate: loanDate, isLending: widget.isLending);
                  if (selectedDate != null) {
                    setState(() {
                      loanDate = selectedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: TextEditingController(
                    text: dueDate != null
                        ? "${dueDate?.year}년 ${dueDate?.month}월 ${dueDate?.day}일"
                        : "미정"),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "상환일",
                  labelStyle: TextStyle(color: AppColor.gray30.of(context)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.isLending ?  AppColor.primaryYellow.of(context) : AppColor.primaryGreen.of(context), width: 2.0),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final selectedDate = await DatetimeUtils.selectDate(
                      context: context, initialDate: dueDate, isLending: widget.isLending);
                  if (selectedDate != null) {
                    if (selectedDate.isBefore(loanDate)) {
                      SnackbarUtil.showToastMessage("상환일은 대출일보다 이전일 수 없습니다");
                    } else {
                      setState(() {
                        dueDate = selectedDate;
                      });
                    }
                  }
                },
              ),
              Spacer(),
              Container(
                  alignment: Alignment.bottomRight,
                  child: Consumer(
                    builder: (context, ref, child) => ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            widget.isLending ?  AppColor.primaryYellow.of(context) : AppColor.primaryGreen.of(context)),
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (amountEdittingController.text.isEmpty) {
                          SnackbarUtil.showSnackBar(context, "금액을 입력해주세요.");
                          return;
                        } else if (selectedPerson == null) {
                          SnackbarUtil.showSnackBar(context, "이름을 입력해주세요.");
                          return;
                        } else {
                          Loan newLoan = Loan(
                            personId: selectedPerson!.personId,
                            isLending: widget.isLending,
                            initialAmount:
                                int.parse(amountEdittingController.text),
                            loanDate: loanDate,
                            dueDate: dueDate,
                            title: titleEdittingController.text.isEmpty
                                ? null
                                : titleEdittingController.text,
                            memo: memoEdittingController.text.isEmpty
                                ? null
                                : memoEdittingController.text,
                          );
                          if (isCreatedPerson ?? false) {
                            await ref
                                .read(appViewModelProvider.notifier)
                                .createPerson(selectedPerson!);
                          }
                          await ref
                              .read(appViewModelProvider.notifier)
                              .createLoan(newLoan);
                          log('추가한 Loan의 isLending: ${newLoan.isLending}');
                          log('추가한 Loan의 personId: ${newLoan.personId}');
                          SnackbarUtil.showSnackBar(context, "기록이 추가되었습니다.");
                          Navigator.pop(context);
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
    TextEditingController controller,
    String labelText,
  ) {
    return TextFormField(
      maxLines: 1,
      controller: controller,
      keyboardType: controller != amountEdittingController
          ? TextInputType.text
          : TextInputType.number,
      inputFormatters: controller != amountEdittingController
          ? []
          : [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: AppColor.gray30.of(context)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: widget.isLending ?  AppColor.primaryYellow.of(context) : AppColor.primaryGreen.of(context),
              width: 2.0), // 포커스 시 테두리 색상
        ),
        suffixIcon: controller.text.isNotEmpty // 텍스트가 있을 때만 X 버튼 표시
            ? IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: AppColor.gray10.of(context),
                ),
                onPressed: () {
                  controller.clear(); // 입력 내용 지우기
                },
              )
            : null, // 텍스트가 없을 땐 버튼 숨기기
      ),
    );
  }
}
