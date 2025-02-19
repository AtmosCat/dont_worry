import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/service/query_service.dart';

class PersonService {
  QueryService _queryService = QueryService();

  Person analyzePerson(
      {required Person person,
      required bool isLending,
      required List<Loan> stateLoans}) {
    List<Loan> loansByPersonId = _queryService.getLoansBy(
        loans: stateLoans, isLending: isLending, personId: person.personId);

    var hasLoan = getHasLoan(loansByPersonId: loansByPersonId);
    var repaidAmount = getRepaidAmount(loansByPersonId: loansByPersonId);
    var remainingAmount = getRemainingAmount(loansByPersonId: loansByPersonId);
    var isPaidOff = getIsPaidOff(loansByPersonId: loansByPersonId);
    var upcomingDueDate = getUpcomingDueDate(loansByPersonId: loansByPersonId);
    var lastRepaidDate = getLastRepaidDate(loansByPersonId: loansByPersonId);

    return isLending
        ? person.clone(
            updatedAt: DateTime.now(),
            hasLend: hasLoan,
            repaidLendAmount: repaidAmount,
            remainingLendAmount: remainingAmount,
            isLendPaidOff: isPaidOff,
            upcomingLendDueDate: upcomingDueDate,
            lastLendRepaidDate: lastRepaidDate,
          )
        : person.clone(
            updatedAt: DateTime.now(),
            hasBorrow: hasLoan,
            repaidBorrowAmount: repaidAmount,
            remainingBorrowAmount: remainingAmount,
            isBorrowPaidOff: isPaidOff,
            upcomingBorrowDueDate: upcomingDueDate,
            lastBorrowRepaidDate: lastRepaidDate,
          );
  }

  bool getHasLoan({required List<Loan> loansByPersonId}) {
    return loansByPersonId.isNotEmpty;
  }

  int getRepaidAmount({required List<Loan> loansByPersonId}) {
    return loansByPersonId.fold<int>(0, (sum, loan) => sum + loan.repaidAmount);
  }

  int getRemainingAmount({required List<Loan> loansByPersonId}) {
    return loansByPersonId.fold<int>(
        0, (sum, loan) => sum + loan.remainingAmount);
  }

  bool getIsPaidOff({required List<Loan> loansByPersonId}) {
    return loansByPersonId.every((loan) => loan.isPaidOff == true);
  }

  DateTime? getUpcomingDueDate({required List<Loan> loansByPersonId}) {
    List<DateTime>? dueDates = loansByPersonId
        .where((loan) => loan.dueDate != null && !loan.isPaidOff)
        .map((loan) => loan.dueDate!)
        .toList();
    return dueDates.isEmpty
        ? null
        : dueDates.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  DateTime? getLastRepaidDate({required List<Loan> loansByPersonId}) {
    List<DateTime>? dates = loansByPersonId
        .where((loan) => loan.lastRepaidDate != null)
        .map((loan) => loan.lastRepaidDate!)
        .toList();
    return dates.isEmpty ? null : dates.reduce((a, b) => a.isAfter(b) ? a : b);
  }
}
