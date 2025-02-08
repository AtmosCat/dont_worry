import 'package:dont_worry/data/model/loan.dart';

class Person {
  String name;
  List<Loan>? loans;
  String? memo;

  Person({
    required this.name,
    this.loans,
    this.memo,
  });

  Person.fromJson(Map<String, dynamic> json) 
    : this(
      name: json['name'],
      loans: json['loans'].map<Loan>((e) => Loan.fromJson(e)).toList(),
      memo: json['memo'],
    );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'loans':[],
      'memo': memo,
    };
  }
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
