import 'package:uuid/uuid.dart';

/* SQL 사용을 위해,
tableName과 Fields{} 클래스를 정의해줬습니다 */

/* 모든 파라미터를 'string' key로
- 반드시 Id를 가지고 있을 것
- 상위 클래스 Person과 Loan Id를 가지고 있을 것 */

class RepaymentFields {
  static final String personId = 'PERSON_ID';
  static final String loanId = 'LOAN_ID';
  static final String repaymentId = 'REPAYMENT_ID';
  static final String amount = 'AMOUNT';
  static final String date = 'DATE';
}

class Repayment {
  static String tableName = 'REPAYMENT'; // 테이블 이름을 'string' key로
  String personId;
  String loanId;
  String repaymentId;
  int amount; // 상환액수 (원 단위)
  DateTime date; // 상환일자

  Repayment({
    required this.personId,
    required this.loanId,
    String? repaymentId,
    required this.amount,
    DateTime? date,
  })  : repaymentId = repaymentId ?? Uuid().v4(),
        date = date ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      RepaymentFields.personId: personId,
      RepaymentFields.loanId: loanId,
      RepaymentFields.repaymentId: repaymentId,
      RepaymentFields.amount: amount,
      RepaymentFields.date: date.toIso8601String(),
    };
  }

  factory Repayment.fromJson(Map<String, dynamic> json) {
    return Repayment(
      personId: json[RepaymentFields.personId] as String,
      loanId: json[RepaymentFields.loanId] as String,
      repaymentId: json[RepaymentFields.repaymentId] as String,
      amount: json[RepaymentFields.amount] as int,
      date: DateTime.parse(json[RepaymentFields.date] as String),
    );
  }

  Repayment clone({
    String? personId,
    String? loanId,
    String? repaymentId,
    int? amount,
    DateTime? date,
  }) {
    return Repayment(
      personId: personId ?? this.personId,
      loanId: loanId ?? this.loanId,
      repaymentId: repaymentId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
}
