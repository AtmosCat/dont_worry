import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/service/query_service.dart';

class DetailService {
  QueryService _queryService = QueryService();

  Loan analyzeLoan(
      {required Loan loan, required List<Repayment> repaymentDatabase}) {
    var repaymentsByLoanId = _queryService.getRepaymentsBy(
        repayments: repaymentDatabase, loanId: loan.loanId);
    var repaidAmount =
        getLoanRepaidAmount(repaymentsByLoanId: repaymentsByLoanId);
    var remainingAmount =
        getLoanRemainingAmount(loan: loan, repaidAmount: repaidAmount);
    var repaymentRate =
        getLoanRepaymentRate(loan: loan, repaidAmount: repaidAmount);
    var isPaidOff = getLoanIsPaidOff(loan: loan, repaidAmount: repaidAmount);
    var lastRepaidDate =
        getLastRepaidDate(repaymentsByLoanId: repaymentsByLoanId);

    return loan.clone(
        repaidAmount: repaidAmount,
        remainingAmount: remainingAmount,
        repaymentRate: repaymentRate,
        isPaidOff: isPaidOff,
        lastRepaidDate: lastRepaidDate);
  }

  int getLoanRepaidAmount({required List<Repayment> repaymentsByLoanId}) {
    return repaymentsByLoanId.fold<int>(
        0, (sum, repayment) => sum + repayment.amount);
  }

  int getLoanRemainingAmount({required Loan loan, required int repaidAmount}) {
    return loan.initialAmount - repaidAmount;
  }

  double getLoanRepaymentRate({required Loan loan, required int repaidAmount}) {
    return loan.initialAmount > 0 ? repaidAmount / loan.initialAmount : 0;
  }

  bool getLoanIsPaidOff({required Loan loan, required int repaidAmount}) {
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
