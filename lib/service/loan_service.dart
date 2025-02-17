import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/service/query_service.dart';

class LoanService {
  QueryService _queryService = QueryService();

  Loan analyzeLoan(
      {required Loan loan, required List<Repayment> stateRepayments}) {
    List<Repayment> repaymentsByLoanId = _queryService.getRepaymentsBy(
        repayments: stateRepayments, loanId: loan.loanId);
    var repaidAmount =
        getRepaidAmount(repaymentsByLoanId: repaymentsByLoanId);
    var remainingAmount =
        getRemainingAmount(loan: loan, repaidAmount: repaidAmount);
    var repaymentRate =
        getRepaymentRate(loan: loan, repaidAmount: repaidAmount);
    var isPaidOff = getIsPaidOff(loan: loan, repaidAmount: repaidAmount);
    var lastRepaidDate =
        getLastRepaidDate(repaymentsByLoanId: repaymentsByLoanId);

    return loan.clone(
        repaidAmount: repaidAmount,
        remainingAmount: remainingAmount,
        repaymentRate: repaymentRate,
        isPaidOff: isPaidOff,
        lastRepaidDate: lastRepaidDate);
  }

  int getRepaidAmount({required List<Repayment> repaymentsByLoanId}) {
    return repaymentsByLoanId.fold<int>(
        0, (sum, repayment) => sum + repayment.amount);
  }

  int getRemainingAmount({required Loan loan, required int repaidAmount}) {
    return loan.initialAmount - repaidAmount;
  }

  double getRepaymentRate({required Loan loan, required int repaidAmount}) {
    return loan.initialAmount > 0 ? repaidAmount / loan.initialAmount : 0;
  }

  bool getIsPaidOff({required Loan loan, required int repaidAmount}) {
    return loan.initialAmount <= repaidAmount;
  }

  DateTime? getLastRepaidDate({required List<Repayment> repaymentsByLoanId}) {
    DateTime? latestDate = repaymentsByLoanId.isNotEmpty
        ? repaymentsByLoanId
            .map((repayment) => repayment.date)
            .reduce((a, b) => a.isAfter(b) ? a : b)
        : null;
    return latestDate;
  }
}