import 'dart:convert';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:uuid/uuid.dart';

/* SQL 사용을 위해,
tableName과 Fields{} 클래스를 정의해줬습니다 */

/* 모든 파라미터를 'string' key로
- 반드시 Id를 가지고 있을 것
- 상위 클래스 Person의 Id를 가지고 있을 것
- 하위 클래스에 대한 List<Repayment>는 생략 */

class LoanFields {
  static final String personId = 'parent_id';
  static final String loanId = 'loan_id';
  static final String isLending = 'is_lending';
  static final String initialAmount = 'initial_amount';
  static final String repayments = 'repayments';
  static final String loanDate = 'loan_date';
  static final String dueDate = 'due_date';
  static final String title = 'title';
  static final String memo = 'memo';
}

class Loan {
  static String tableName = 'loan'; // 테이블 이름을 'string' key로
  String personId;
  String loanId;
  bool isLending; // 빌리는지, 빌려주는지 여부
  int initialAmount; // 최초 대출금액
  List<Repayment> repayments; //상환 내역
  DateTime loanDate; // 차용일
  DateTime? dueDate; // 변제일
  String title; //제목 (= 기본값 loanDate)
  String? memo; // 세부메모

  Loan({
    required this.personId,
    String? loanId,
    required this.isLending,
    required this.initialAmount,
    List<Repayment>? repayments,
    DateTime? loanDate,
    this.dueDate,
    String? title,
    this.memo,
  })  : loanId = loanId ?? Uuid().v4(),
        loanDate = loanDate ?? DateTime.now(),
        repayments = repayments ?? [],
        title = title ??
            "${loanDate ?? DateTime.now().year}년 ${loanDate ?? DateTime.now().month}월 ${loanDate ?? DateTime.now().day}일";

  Map<String, dynamic> toJson() {
    return {
      LoanFields.personId: personId,
      LoanFields.loanId: loanId,
      LoanFields.isLending: isLending ? 1 : 0,
      LoanFields.initialAmount: initialAmount,
      LoanFields.repayments: repayments.map((r) => r.toJson()).toList(),
      LoanFields.loanDate: loanDate.toIso8601String(),
      LoanFields.dueDate: dueDate?.toIso8601String(),
      LoanFields.title: title,
      LoanFields.memo: memo,
    };
  }

  factory Loan.fromJson(Map<String, dynamic> json) {
    List<dynamic> repaymentList =
        jsonDecode(json[LoanFields.repayments] as String);
    List<Repayment> repayments =
        repaymentList.map((r) => Repayment.fromJson(r)).toList();

    return Loan(
      personId: json[LoanFields.personId] as String,
      loanId: json[LoanFields.loanId] as String,
      isLending: json[LoanFields.isLending] as int == 1,
      initialAmount: json[LoanFields.initialAmount] as int,
      repayments: repayments,
      loanDate: DateTime.parse((json[LoanFields.loanDate] as String)),
      dueDate: json[LoanFields.dueDate] == null
          ? null
          : DateTime.parse((json[LoanFields.dueDate] as String)),
      title: json[LoanFields.title] as String,
      memo: json[LoanFields.memo] == null
          ? null
          : json[LoanFields.memo] as String,
    );
  }

  Loan clone({
    String? personId,
    String? loanId,
    bool? isLending,
    int? initialAmount,
    List<Repayment>? repayments,
    DateTime? loanDate,
    DateTime? dueDate,
    String? title,
    String? memo,
  }) {
    return Loan(
      personId: personId ?? this.personId,
      loanId: loanId ?? this.loanId,
      isLending: isLending ?? this.isLending,
      initialAmount: initialAmount ?? this.initialAmount,
      repayments: repayments ?? this.repayments.map((r) => r.clone()).toList(),
      loanDate: loanDate ?? this.loanDate,
      dueDate: dueDate ?? this.dueDate,
      title: title ?? this.title,
      memo: memo ?? this.memo,
    );
  }
}

// 상환액 (상환내역의 총합)
int totalRepaymentAmount(List<Repayment> repayments) {
  int total = 0;
  for (var repayment in repayments) {
    total += repayment.amount;
  }
  return total;
}

// 잔여대출액 {최초대출금액 - 상환액}
int remainingLoanAmount(int initialAmount, List<Repayment> repayments) {
  return initialAmount - totalRepaymentAmount(repayments);
}

// 상환비율
double repaymentRate(int initialAmount, List<Repayment> repayments) {
  return totalRepaymentAmount(repayments) / initialAmount;
}

// 변제일까지의 D-day
int daysUntilDueDate(DateTime dueDate) {
  final now = DateTime.now();
  return dueDate.difference(now).inDays;
}
