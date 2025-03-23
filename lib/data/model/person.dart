import 'package:uuid/uuid.dart';

class Person {
  // # key
  static String tableName = 'person';
  String personId;
  DateTime updatedAt; // 수정일
  static String personId_ = 'person_id';
  static String updatedAt_ = 'updated_at';

  // # input
  String name;
  String? memo;
  static String name_ = 'name';
  static String memo_ = 'memo';

  // # analyze
  bool hasLend;
  bool hasBorrow; // 대출내역 유무
  int repaidLendAmount;
  int repaidBorrowAmount; // 갚은 금액
  int remainingLendAmount;
  int remainingBorrowAmount; // 남은 대출금액
  bool isLendPaidOff;
  bool isBorrowPaidOff; // 전액상환 여부
  DateTime? upcomingLendDueDate;
  DateTime? upcomingBorrowDueDate; // 다가오는 상환일자
  DateTime? lastLendRepaidDate;
  DateTime? lastBorrowRepaidDate; // 최근 상환한 날짜
  static String hasLend_ = 'has_lend';
  static String hasBorrow_ = 'has_borrow';
  static String repaidLendAmount_ = 'repaid_lend_amount';
  static String repaidBorrowAmount_ = 'repaid_borrow_amount';
  static String remainingLendAmount_ = 'remaining_lend_amount';
  static String remainingBorrowAmount_ = 'remaining_borrow_amount';
  static String isLendPaidOff_ = 'is_lend_paid_off';
  static String isBorrowPaidOff_ = 'is_borrow_paid_off';
  static String upcomingLendDueDate_ = 'upcoming_lend_due_date';
  static String upcomingBorrowDueDate_ = 'upcoming_borrow_due_date';
  static String lastLendRepaidDate_ = 'last_lend_repaid_date';
  static String lastBorrowRepaidDate_ = 'last_borrow_repaid_date';

  // # 생성자
  Person({
    String? personId,
    DateTime? updatedAt,
    required this.name,
    this.memo,
    bool? hasLend,
    bool? hasBorrow,
    int? repaidLendAmount,
    int? repaidBorrowAmount,
    int? remainingLendAmount,
    int? remainingBorrowAmount,
    bool? isLendPaidOff,
    bool? isBorrowPaidOff,
    this.upcomingLendDueDate,
    this.upcomingBorrowDueDate,
    this.lastLendRepaidDate,
    this.lastBorrowRepaidDate,
  })  
  // # 생성자 초기화
  : personId = personId ?? Uuid().v4(),
        updatedAt = updatedAt ?? DateTime.now(),
        hasLend = hasLend ?? false,
        hasBorrow = hasBorrow ?? false,
        isLendPaidOff = isLendPaidOff ?? false,
        isBorrowPaidOff = isBorrowPaidOff ?? false,
        repaidLendAmount = repaidLendAmount ?? 0,
        repaidBorrowAmount = repaidBorrowAmount ?? 0,
        remainingLendAmount = remainingLendAmount ?? 0,
        remainingBorrowAmount = remainingBorrowAmount ?? 0;

  // # 직렬화 toJson
  Map<String, dynamic> toJson() {
    return {
      Person.personId_: personId,
      Person.updatedAt_: updatedAt.toIso8601String(),
      Person.name_: name,
      Person.memo_: memo,
      Person.hasLend_: hasLend ? 1 : 0,
      Person.hasBorrow_: hasBorrow ? 1 : 0,
      Person.repaidLendAmount_: repaidLendAmount,
      Person.repaidBorrowAmount_: repaidBorrowAmount,
      Person.remainingLendAmount_: remainingLendAmount,
      Person.remainingBorrowAmount_: remainingBorrowAmount,
      Person.isLendPaidOff_: isLendPaidOff ? 1 : 0,
      Person.isBorrowPaidOff_: isBorrowPaidOff ? 1 : 0,
      Person.upcomingLendDueDate_: upcomingLendDueDate?.toIso8601String(),
      Person.upcomingBorrowDueDate_: upcomingBorrowDueDate?.toIso8601String(),
      Person.lastLendRepaidDate_: lastLendRepaidDate?.toIso8601String(),
      Person.lastBorrowRepaidDate_: lastBorrowRepaidDate?.toIso8601String(),
    };
  }

  // # 역직렬화 fromJson
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      personId: json[Person.personId_] as String,
      updatedAt: DateTime.parse(json[Person.updatedAt_] as String),
      name: json[Person.name_] as String,
      memo: json[Person.memo_] == null ? null : json[Person.memo_] as String,
      hasLend: json[Person.hasLend_] as int == 1,
      hasBorrow: json[Person.hasBorrow_] as int == 1,
      repaidLendAmount: (json[Person.repaidLendAmount_] as int?) ?? 0,
      repaidBorrowAmount: (json[Person.repaidBorrowAmount_] as int?) ?? 0,
      remainingLendAmount: (json[Person.remainingLendAmount_] as int?) ?? 0,
      remainingBorrowAmount: (json[Person.remainingBorrowAmount_] as int?) ?? 0,
      isLendPaidOff: json[Person.isLendPaidOff_] as int == 1,
      isBorrowPaidOff: json[Person.isBorrowPaidOff_] as int == 1,
      upcomingLendDueDate: json[Person.upcomingLendDueDate_] == null
          ? null
          : DateTime.parse(json[Person.upcomingLendDueDate_] as String),
      upcomingBorrowDueDate: json[Person.upcomingBorrowDueDate_] == null
          ? null
          : DateTime.parse(json[Person.upcomingBorrowDueDate_] as String),
      lastLendRepaidDate: json[Person.lastLendRepaidDate_] == null
          ? null
          : DateTime.parse(json[Person.lastLendRepaidDate_] as String),
      lastBorrowRepaidDate: json[Person.lastBorrowRepaidDate_] == null
          ? null
          : DateTime.parse(json[Person.lastBorrowRepaidDate_] as String),
    );
  }

  // # clone
  Person clone({
    String? personId,
    DateTime? updatedAt,
    String? name,
    String? memo,
    bool? hasLend,
    bool? hasBorrow,
    int? repaidLendAmount,
    int? repaidBorrowAmount,
    int? remainingLendAmount,
    int? remainingBorrowAmount,
    bool? isLendPaidOff,
    bool? isBorrowPaidOff,
    DateTime? upcomingLendDueDate,
    DateTime? upcomingBorrowDueDate,
    DateTime? lastLendRepaidDate,
    DateTime? lastBorrowRepaidDate,
  }) {
    return Person(
      personId: personId ?? this.personId,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      memo: memo ?? this.memo,
      hasLend: hasLend ?? this.hasLend,
      hasBorrow: hasBorrow ?? this.hasBorrow,
      repaidLendAmount: repaidLendAmount ?? this.repaidLendAmount,
      repaidBorrowAmount: repaidBorrowAmount ?? this.repaidBorrowAmount,
      remainingLendAmount: remainingLendAmount ?? this.remainingLendAmount,
      remainingBorrowAmount:
          remainingBorrowAmount ?? this.remainingBorrowAmount,
      isLendPaidOff: isLendPaidOff ?? this.isLendPaidOff,
      isBorrowPaidOff: isBorrowPaidOff ?? this.isBorrowPaidOff,
      upcomingLendDueDate: upcomingLendDueDate ?? this.upcomingLendDueDate,
      upcomingBorrowDueDate:
          upcomingBorrowDueDate ?? this.upcomingBorrowDueDate,
      lastLendRepaidDate: lastLendRepaidDate ?? this.lastLendRepaidDate,
      lastBorrowRepaidDate: lastBorrowRepaidDate ?? this.lastBorrowRepaidDate,
    );
  }
}
