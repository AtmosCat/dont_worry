import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/data/repository/sql_loan_crud_repository.dart';
import 'package:dont_worry/data/repository/sql_person_crud_repository.dart';
import 'package:dont_worry/data/repository/sql_repayment_crud_repository.dart';

class QueryService {
  Future<List<Person>> getPeople() async {
    try {
      return await SqlPersonCrudRepository.getPersonSummaries();
    } catch (e) {
      print('Error loading loans: $e');
      return [];
    }
  }

  Future<List<Loan>> getLoans() async {
    try {
      return await SqlLoanCrudRepository.getLoanSummaries();
    } catch (e) {
      print('Error loading loans: $e');
      return [];
    }
  }

  Future<List<Repayment>> getRepayments() async {
    try {
      return await SqlRepaymentCrudRepository.getList();
    } catch (e) {
      print('Error loading loans: $e');
      return [];
    }
  }
}

//   // 선택한 Person의 Loan 리스트 - L
//   Future<List<Loan>> getLoansForPerson(
//       {required String personId, required bool isLending}) async {
//     try {
//       return await SqlLoanCrudRepository.getList(
//           personId: personId, isLending: isLending);
//     } catch (e) {
//       print('Error loading loans: $e');
//       return [];
//     }
//   }

//   // 선택한 Person이 가진 모든 Loan에 대한 Repayment 리스트 - R, L
//   Future<List<Repayment>> getRepaymentsForPerson(
//       {required String personId, required bool isLending}) async {
//     try {
//       List<Loan> loans =
//           await getLoansForPerson(personId: personId, isLending: isLending);
//       List<Repayment> repayments = [];

//       for (var loan in loans) {
//         var loanRepayments = await getRepaymentsForLoan(loanId: loan.loanId);
//         repayments.addAll(loanRepayments);
//       }
//       return repayments;
//     } catch (e) {
//       print('Error loading loans: $e');
//       return [];
//     }
//   }

// // # HomePage : PersonCard List
//   // 빌려준/빌린 Person 리스트 -> "전액 상환여부"에 따라 분류 - P, L, R
//   Future<List<Person>> getPeopleByPaidOff(
//       {required bool isLending, required bool isPaidOff}) async {
//     try {
//       List<Person> filteredPeople = [];
//       List<Person> people = await getPeople();

//       for (var person in people) {
//         List<Loan> loans = await getLoansForPersonByPaidOff(
//             personId: person.personId,
//             isLending: isLending,
//             isPaidOff: isPaidOff);
//         if ((loans.length == 0) == isPaidOff) {
//           filteredPeople.add(person);
//         }
//       }
//       return filteredPeople;
//     } catch (e) {
//       print('Error loading loans: $e');
//       return [];
//     }
//   }

// // # PersonDetailPage : LoanCard List
//   // 선택한 Person의 Loan 리스트 -> "전액 상환여부"에 따라 분류 - L, R
//   Future<List<Loan>> getLoansForPersonByPaidOff(
//       {required String personId,
//       required bool isLending,
//       required bool isPaidOff}) async {
//     try {
//       List<Loan> filteredLoans = [];
//       List<Loan> loans =
//           await getLoansForPerson(personId: personId, isLending: isLending);

//       for (var loan in loans) {
//         List<Repayment> repayments =
//             await getRepaymentsForLoan(loanId: loan.loanId);
//         int totalRepayedAmount =
//             repayments.fold<int>(0, (sum, repayment) => sum + repayment.amount);
//         bool isLoanPaidOff = totalRepayedAmount >= loan.initialAmount;

//         if (isLoanPaidOff == isPaidOff) {
//           filteredLoans.add(loan);
//         }
//       }
//       return filteredLoans;
//     } catch (e) {
//       print('Error loading loans: $e');
//       return [];
//     }
//   }

// // # LoanDetailPage : 상환 내역
//   // 선택한 대출에 대한 Repayment 리스트 - R
//   Future<List<Repayment>> getRepaymentsForLoan({required String loanId}) async {
//     try {
//       return await SqlRepaymentCrudRepository.getList(loanId: loanId);
//     } catch (e) {
//       print('Error loading loans: $e');
//       return [];
//     }
//   }