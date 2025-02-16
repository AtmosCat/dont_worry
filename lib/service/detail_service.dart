// import 'package:dont_worry/data/model/loan.dart';
// import 'package:dont_worry/data/model/repayment.dart';
// import 'package:dont_worry/service/query_service.dart';

// class DetailService {
//   QueryService _queryService = QueryService();

//   // 장부 전체 잔여대출금
//   Future<int> getTotalRemaining() async {
//     return 0;
//   }

//   // Person의 잔여대출금
//   Future<int> getRemainingForPerson() async {
//     return 0;
//   }

//   // Loan의 잔여대출금
//   Future<int> getRemainingForLoan() async {
//     Loan loan = await _queryService.get... (작성중))
//     int remainingForLoan = 0;


//     return remainingForLoan;
//   }

//   // Person의 누적상환금
//   Future<int> getRepayedForPerson(
//       {required String personId, required bool isLending}) async {
//     List<Loan> loans = await _queryService.getLoansForPerson(
//         personId: personId, isLending: isLending);
//     int repayedForPerson = 0;
//     for (var loan in loans) {
//       int repayedForLoan = await getRepayedForLoan(loanId: loan.loanId);
//       repayedForPerson + repayedForLoan;
//     }
//     return repayedForPerson;
//   }

//   // Loan의 누적상환금
//   Future<int> getRepayedForLoan({required String loanId}) async {
//     List<Repayment> repayments =
//         await _queryService.getRepaymentsForLoan(loanId: loanId);
//     int repayedForLoan =
//         repayments.fold<int>(0, (sum, repayment) => sum + repayment.amount);
//     return repayedForLoan;
//   }

//   // Person의 디데이
//   Future<int> getDDayForPerson() async {
//     return 0;
//   }

//   // Loan의 디데이
//   Future<int> getDDay() async {
//     return 0;
//   }

//   // Person의 마지막 상환날짜
//   Future<DateTime> getLastRepayedDateForPerson() async {
//     return 0;
//   }

//   // Loan의 마지막 상환날짜
//   Future<DateTime> getLastRepayedDate() async {
//     return DateTime();
//   }

//   // Loan의 대출상환비율
//   Future<double> getRepaymentRate() async {
//     return 0;
//   }
// }