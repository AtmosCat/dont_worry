import 'package:dont_worry/data/model/loan.dart';
import 'package:uuid/uuid.dart';

class Person {
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