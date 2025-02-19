import 'package:uuid/uuid.dart';

class Repayment {
  // # key
  static String tableName = 'repayment';
  String repaymentId;
  String personId;
  String loanId;
  static String repaymentId_ = 'repayment_id';
  static String personId_ = 'person_id';
  static String loanId_ = 'loan_id';

  // # input
  bool isLending; // true 빌려준 돈, false 빌린 돈
  int amount;
  DateTime date;
  static String isLending_ = 'is_lending';
  static String amount_ = 'amount';
  static String date_ = 'date';

  // # 생성자
  Repayment({
    String? repaymentId,
    required this.personId,
    required this.loanId,
    required this.isLending,
    required this.amount,
    DateTime? date,
  })
  // # 생성자 초기화
  : repaymentId = repaymentId ?? Uuid().v4(),
        date = date ?? DateTime.now();

  // # 직렬화 toJson
  Map<String, dynamic> toJson() {
    return {
      repaymentId_: repaymentId,
      personId_: personId,
      loanId_: loanId,
      isLending_: isLending ? 1 : 0,
      amount_: amount,
      date_: date.toIso8601String(),
    };
  }

  // # 역직렬화 fromJson
  factory Repayment.fromJson(Map<String, dynamic> json) {
    return Repayment(
      repaymentId: json[repaymentId_] as String,
      personId: json[personId_] as String,
      loanId: json[loanId_] as String,
      isLending: json[isLending_] as int == 1,
      amount: json[amount_] as int,
      date: DateTime.parse(json[date_] as String),
    );
  }

  // # clone
  Repayment clone({
    String? repaymentId,
    String? personId,
    String? loanId,
    bool? isLending,
    int? amount,
    DateTime? date,
  }) {
    return Repayment(
      repaymentId: repaymentId ?? this.repaymentId,
      personId: personId ?? this.personId,
      loanId: loanId ?? this.loanId,
      isLending: isLending ?? this.isLending,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
}
