import 'package:uuid/uuid.dart';

class Loan {
  // # key
  static String tableName = 'loan'; // 테이블 이름을 'string' key로
  String loanId;
  String personId;
  DateTime updatedAt;
  static String loanId_ = 'loan_id';
  static String personId_ = 'parent_id';
  static String updatedAt_ = 'updated_at';

  // # input
  bool isLending; // true 빌려준 돈, false 빌린 돈
  int initialAmount; // 대출 원금
  DateTime loanDate; // 빌린 날짜
  DateTime? dueDate; // 갚기로 한 날짜
  String title; // 제목
  String? memo; // 세부메모
  static String isLending_ = 'is_lending';
  static String initialAmount_ = 'initial_amount';
  static String loanDate_ = 'loan_date';
  static String dueDate_ = 'due_date';
  static String title_ = 'title';
  static String memo_ = 'memo';

  // # analyze
  int repaidAmount; // 갚은 금액 합계
  int remainingAmount; // 남은 대출 금액
  double repaymentRate; // 상환 비율
  bool isPaidOff; // 상환완료 여부
  DateTime? lastRepaidDate; // 최근 상환한 날짜
  static String repaidAmount_ = 'repaid_amount';
  static String remainingAmount_ = 'remaining_amount';
  static String repaymentRate_ = 'repayment_rate';
  static String isPaidOff_ = 'is_paid_off';
  static String lastRepaidDate_ = 'last_repaid_date';

  // # 생성자
  Loan({
    String? loanId,
    required this.personId,
    DateTime? updatedAt,
    required this.isLending,
    required this.initialAmount,
    DateTime? loanDate,
    this.dueDate,
    String? title,
    this.memo,
    int? repaidAmount,
    int? remainingAmount,
    double? repaymentRate,
    bool? isPaidOff,
    this.lastRepaidDate,
  })  
  // # 생성자 초기화
  : loanId = loanId ?? Uuid().v4(),
        updatedAt = DateTime.now(),
        loanDate = loanDate ?? DateTime.now(),
        title = title ??
            "${loanDate ?? DateTime.now().year}년 ${loanDate ?? DateTime.now().month}월 ${loanDate ?? DateTime.now().day}일",
        repaidAmount = repaidAmount ?? 0,
        remainingAmount = remainingAmount ?? initialAmount,
        repaymentRate = repaymentRate ?? 0,
        isPaidOff = isPaidOff ?? false;

  // # 직렬화 toJson
  Map<String, dynamic> toJson() {
    return {
      Loan.loanId_: loanId,
      Loan.personId_: personId,
      Loan.updatedAt_: updatedAt.toIso8601String(),
      Loan.isLending_: isLending ? 1 : 0,
      Loan.initialAmount_: initialAmount,
      Loan.loanDate_: loanDate.toIso8601String(),
      Loan.dueDate_: dueDate?.toIso8601String(),
      Loan.title_: title,
      Loan.memo_: memo,
      Loan.repaidAmount_: repaidAmount,
      Loan.remainingAmount_: remainingAmount,
      Loan.repaymentRate_: repaymentRate,
      Loan.isPaidOff_: isPaidOff ? 1 : 0,
      Loan.lastRepaidDate_: lastRepaidDate?.toIso8601String(),
    };
  }

  // # 역직렬화 fromJson
  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      loanId: json[Loan.loanId_] as String,
      personId: json[Loan.personId_] as String,
      updatedAt: DateTime.parse(json[Loan.updatedAt_] as String),
      isLending: json[Loan.isLending_] as int == 1,
      initialAmount: json[Loan.initialAmount_] as int,
      loanDate: DateTime.parse((json[Loan.loanDate_] as String)),
      dueDate: json[Loan.dueDate_] == null
          ? null
          : DateTime.parse((json[Loan.dueDate_] as String)),
      title: json[Loan.title_] as String,
      memo: json[Loan.memo_] == null ? null : json[Loan.memo_] as String,
      repaidAmount: (json[Loan.repaidAmount_] as int?) ?? 0,
      remainingAmount: (json[Loan.remainingAmount_] as int?) ??
          json[Loan.initialAmount_] as int,
      repaymentRate: json[Loan.repaymentRate_] as double,
      isPaidOff: json[Loan.isPaidOff_] as int == 1,
      lastRepaidDate: json[Loan.lastRepaidDate_] == null
          ? null
          : DateTime.parse(json[Loan.lastRepaidDate_] as String),
    );
  }

  // # clone
  Loan clone({
    String? loanId,
    String? personId,
    DateTime? updatedAt,
    bool? isLending,
    int? initialAmount,
    DateTime? loanDate,
    DateTime? dueDate,
    String? title,
    String? memo,
    int? repaidAmount,
    int? remainingAmount,
    double? repaymentRate,
    bool? isPaidOff,
    DateTime? lastRepaidDate,
  }) {
    return Loan(
      loanId: loanId ?? this.loanId,
      personId: personId ?? this.personId,
      updatedAt: updatedAt ?? this.updatedAt,
      isLending: isLending ?? this.isLending,
      initialAmount: initialAmount ?? this.initialAmount,
      loanDate: loanDate ?? this.loanDate,
      dueDate: dueDate ?? this.dueDate,
      title: title ?? this.title,
      memo: memo ?? this.memo,
      repaidAmount: repaidAmount ?? this.repaidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      repaymentRate: repaymentRate ?? this.repaymentRate,
      isPaidOff: isPaidOff ?? this.isPaidOff,
      lastRepaidDate: lastRepaidDate ?? this.lastRepaidDate,
    );
  }
}
