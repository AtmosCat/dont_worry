import 'package:uuid/uuid.dart';

/* SQL 사용을 위해,
tableName과 Fields{} 클래스를 정의해줬습니다 */

/* 모든 파라미터를 'string' key로
- 반드시 Id를 가지고 있을 것
- 하위 클래스에 대한 List<Loan>은 생략 */

class PersonFields {
  static final String personId = 'person_id';
  static final String name = 'name';
  static final String memo = 'memo';
  static final String remainingAmount = 'remaining_amount';
  static final String repayedAmount = 'repayed_amount';
  static final String dDay = 'd_day';
  static final String lastRepayedDate = 'last_repayed_date';
}

class Person {
  static String tableName = 'person'; // 테이블 이름을 'string' key로
  static String viewName = 'person_view'; // 테이블 이름을 'string' key로
  String personId;
  String name;
  String? memo;
  // SQL 조인테이블로 계산할 내용
  int? remainingAmount;
  int? repayedAmount;
  int? dDay;
  DateTime? lastRepayedDate;

  Person({
    String? personId,
    required this.name,
    this.memo,
    this.remainingAmount,
    this.repayedAmount,
    this.dDay,
    this.lastRepayedDate,
  }) : personId = personId ?? Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      PersonFields.personId: personId,
      PersonFields.name: name,
      PersonFields.memo: memo
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      personId: json[PersonFields.personId] as String,
      name: json[PersonFields.name] as String,
      memo: json[PersonFields.memo] != null
          ? json[PersonFields.memo] as String
          : null,
      remainingAmount: json[PersonFields.remainingAmount] as int,
      repayedAmount: json[PersonFields.repayedAmount] as int,
      dDay: json[PersonFields.dDay] as int,
      lastRepayedDate:
          DateTime.parse(json[PersonFields.lastRepayedDate] as String),
    );
  }

  Person clone({
    String? personId,
    String? name,
    String? memo,
  }) {
    return Person(
      personId: personId ?? this.personId,
      name: name ?? this.name,
      memo: memo ?? this.memo,
    );
  }
}
