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
  static final String loanDate = 'loan_date';
  static final String dueDate = 'due_date';
  static final String title = 'title';
  static final String memo = 'memo';
  static final String remainingAmount = 'remaining_amount';
  static final String repayedAmount = 'repayed_amount';
  static final String dDay = 'd_day';
  static final String lastRepayedDate = 'last_repayed_date';
  static final String repaymentRate = 'repayment_rate';
}

class Loan {
  static String tableName = 'loan'; // 테이블 이름을 'string' key로
  static String viewName = 'loan_view';
  String personId;
  String loanId;
  bool isLending; // 빌리는지, 빌려주는지 여부
  int initialAmount; // 최초 대출금액
  DateTime loanDate; // 차용일
  DateTime? dueDate; // 변제일
  String title; //제목 (= 기본값 loanDate)
  String? memo; // 세부메모
  // SQL 조인테이블로 계산할 내용
  int? remainingAmount;
  int? repayedAmount;
  int? dDay;
  DateTime? lastRepayedDate;
  double? repaymentRate;

  Loan(
      {required this.personId,
      String? loanId,
      required this.isLending,
      required this.initialAmount,
      List<Repayment>? repayments,
      DateTime? loanDate,
      this.dueDate,
      String? title,
      this.memo,
      this.remainingAmount,
      this.repayedAmount,
      this.dDay,
      this.lastRepayedDate,
      this.repaymentRate})
      : loanId = loanId ?? Uuid().v4(),
        loanDate = loanDate ?? DateTime.now(),
        title = title ??
            "${loanDate ?? DateTime.now().year}년 ${loanDate ?? DateTime.now().month}월 ${loanDate ?? DateTime.now().day}일";

  Map<String, dynamic> toJson() {
    return {
      LoanFields.personId: personId,
      LoanFields.loanId: loanId,
      LoanFields.isLending: isLending ? 1 : 0,
      LoanFields.initialAmount: initialAmount,
      LoanFields.loanDate: loanDate.toIso8601String(),
      LoanFields.dueDate: dueDate?.toIso8601String(),
      LoanFields.title: title,
      LoanFields.memo: memo,
    };
  }

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      personId: json[LoanFields.personId] as String,
      loanId: json[LoanFields.loanId] as String,
      isLending: json[LoanFields.isLending] as int == 1,
      initialAmount: json[LoanFields.initialAmount] as int,
      loanDate: DateTime.parse((json[LoanFields.loanDate] as String)),
      dueDate: json[LoanFields.dueDate] == null
          ? null
          : DateTime.parse((json[LoanFields.dueDate] as String)),
      title: json[LoanFields.title] as String,
      memo: json[LoanFields.memo] == null
          ? null
          : json[LoanFields.memo] as String,
      remainingAmount: json[LoanFields.remainingAmount] as int,
      repayedAmount: json[LoanFields.repayedAmount] as int,
      dDay: json[LoanFields.dDay] as int,
      lastRepayedDate:
          DateTime.parse(json[LoanFields.lastRepayedDate] as String),
      repaymentRate: json[LoanFields.repaymentRate] as double,
    );
  }

  Loan clone({
    String? personId,
    String? loanId,
    bool? isLending,
    int? initialAmount,
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
      loanDate: loanDate ?? this.loanDate,
      dueDate: dueDate ?? this.dueDate,
      title: title ?? this.title,
      memo: memo ?? this.memo,
    );
  }
}
