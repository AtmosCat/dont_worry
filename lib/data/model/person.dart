import 'package:dont_worry/data/model/loan.dart';
import 'package:uuid/uuid.dart';

/* SQL 사용을 위해,
tableName과 Fields{} 클래스를 정의해줬습니다 */

/* 모든 파라미터를 'string' key로
- 반드시 Id를 가지고 있을 것
- 하위 클래스에 대한 List<Loan>은 생략 */

class PersonFields{
  static final personId = 'personId';
  static final name = 'name';
  static final memo = 'memo';
}

class Person {
  static String tableName = 'repayment'; // 테이블 이름을 'string' key로
  String personId;
  String name;
  List<Loan> loans;
  String? memo;

  Person({
    String? personId,
    required this.name,
    required this.loans,
    this.memo,
  }) : personId = personId ?? Uuid().v4();
}

// 해당 사람에게 빌려준 대출 리스트 반환
List<Loan> lendingLoans(List<Loan> loans) {
  return loans.where((loan) => loan.isLending).toList();
}

// 해당 사람에게 빌린 대출 리스트 반환
List<Loan> borrowingLoans(List<Loan> loans) {
  return loans.where((loan) => !loan.isLending).toList();
}

// 변제일까지의 D-day
int daysUntilUpcomingDueDatedaysUntilDueDate(List<Loan> loans) {
  return 30;
}