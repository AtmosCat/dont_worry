import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';

class QueryService {
  // List에서 Id로 객체 얻기
  Person getPersonById(
      {required String personId, required List<Person> people}) {
    return people.firstWhere((person) => person.personId == personId);
  }

  Loan getLoanById({required String loanId, required List<Loan> loans}) {
    return loans.firstWhere((loan) => loan.loanId == loanId);
  }

  Repayment getRepaymentById(
      {required String repaymentId, required List<Repayment> repayments}) {
    return repayments
        .firstWhere((repayment) => repayment.repaymentId == repaymentId);
  }

// List에서 상위 ID, 상환완료 여부로 필터링한 List 얻기
  List<Person> getPeopleBy(
      {required bool isLending,
      bool? isPaidOff,
      required List<Person> people}) {
    List<Person> result = people
        .where((person) => isLending ? person.hasLend : person.hasBorrow)
        .toList();
    return isPaidOff == null
        ? result
        : result
            .where((perosn) => isLending
                ? perosn.isLendPaidOff == isPaidOff
                : perosn.isBorrowPaidOff == isPaidOff)
            .toList();
  }

  List<Loan> getLoansBy({
    required String personId,
    required bool isLending,
    bool? isPaidOff,
    required List<Loan> loans,
  }) {
    List<Loan> result = loans
        .where(
            (loan) => loan.personId == personId && loan.isLending == isLending)
        .toList();
    return isPaidOff == null
        ? result
        : result.where((loan) => loan.isPaidOff == isPaidOff).toList();
  }

  List<Repayment> getRepaymentsBy({
    String? personId,
    String? loanId,
    bool? isLending,
    required List<Repayment> repayments,
  }) {
    return repayments
        .where((repayment) => personId != null
            ? repayment.personId == personId && repayment.isLending == isLending
            : repayment.loanId == loanId)
        .toList();
  }
}
