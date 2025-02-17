import 'dart:async';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/data/repository/sql_loan_crud_repository.dart';
import 'package:dont_worry/data/repository/sql_person_crud_repository.dart';
import 'package:dont_worry/data/repository/sql_repayment_crud_repository.dart';
import 'package:dont_worry/service/loan_service.dart';
import 'package:dont_worry/service/person_service.dart';
import 'package:dont_worry/service/query_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LedgerState {
  final List<Person> people;
  final List<Loan> loans;
  final List<Repayment> repayments;
  LedgerState({
    required this.people,
    required this.loans,
    required this.repayments,
  });
}

class LedgerViewModel extends StateNotifier<LedgerState> {
  final _queryService = QueryService();
  final _loanService = LoanService();
  final _personService = PersonService();

  LedgerViewModel()
      : super(LedgerState(people: [], loans: [], repayments: [])) {
    _init();
  }

  Future<void> _init() async {
    try {
      final people = await SqlPersonCrudRepository.getList();
      final loans = await SqlLoanCrudRepository.getList();
      final repayments = await SqlRepaymentCrudRepository.getList();

      state = LedgerState(people: people, loans: loans, repayments: repayments);
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  // Person CRUD
  Future<void> loadPeople() async {
    try {
      List<Person> people = await SqlPersonCrudRepository.getList();
      state = LedgerState(
        people: people,
        loans: state.loans,
        repayments: state.repayments,
      );
    } catch (e) {
      print('Error loading loans: $e');
    }
  }

  Future<void> createPerson(Person person) async {
    await SqlPersonCrudRepository.create(person);
    await loadPeople();
  }

  Future<void> updatePerson(Person person) async {
    await SqlPersonCrudRepository.update(person);
    await loadPeople();
  }

  Future<void> deletePerson(Person person) async {
    await SqlPersonCrudRepository.delete(person);
    await loadPeople();
  }

  // Loan CRUD
  Future<void> loadLoans() async {
    try {
      List<Person> people = await SqlPersonCrudRepository.getList();
      List<Loan> loans = await SqlLoanCrudRepository.getList();
      state = LedgerState(
        people: people,
        loans: loans,
        repayments: state.repayments,
      );
    } catch (e) {
      print('Error loading loans: $e');
    }
  }

  Future<void> createLoan(Loan loan) async {
    await SqlLoanCrudRepository.create(loan);
    await analyzeLoan(loan: loan);
    await analyzePerson(loan: loan);
    await loadLoans();
  }

  Future<void> updateLoan(Loan loan) async {
    await SqlLoanCrudRepository.update(loan);
    await analyzeLoan(loan: loan);
    await analyzePerson(loan: loan);
    await loadLoans();
  }

  Future<void> deleteLoan(Loan loan) async {
    await SqlLoanCrudRepository.delete(loan);
    await analyzeLoan(loan: loan);
    await analyzePerson(loan: loan);
    await loadLoans();
  }

  // Repayment CRUD
  Future<void> loadRepayments() async {
    try {
      List<Person> people = await SqlPersonCrudRepository.getList();
      List<Loan> loans = await SqlLoanCrudRepository.getList();
      List<Repayment> repayments = await SqlRepaymentCrudRepository.getList();
      state = LedgerState(
        people: people,
        loans: loans,
        repayments: repayments,
      );
    } catch (e) {
      print('Error loading loans: $e');
    }
  }

  Future<void> createRepayment(Repayment repayment) async {
    await SqlRepaymentCrudRepository.create(repayment);
    await analyzeLoan(repayment: repayment);
    await analyzePerson(repayment: repayment);
    await loadRepayments();
  }

  Future<void> updateRepayment(Repayment repayment) async {
    await SqlRepaymentCrudRepository.update(repayment);
    await analyzeLoan(repayment: repayment);
    await analyzePerson(repayment: repayment);
    await loadRepayments();
  }

  Future<void> deleteRepayment(Repayment repayment) async {
    await SqlRepaymentCrudRepository.delete(repayment);
    await analyzeLoan(repayment: repayment);
    await analyzePerson(repayment: repayment);
    await loadRepayments();
  }

  Future<void> analyzeLoan({Loan? loan, Repayment? repayment}) async {
    if (loan == null && repayment == null) {
      throw Exception("Either loan or repayment must be provided");
    }

    // 동일한 ID의 Loan을 찾아내서, 분석 데이터를 업데이트
    loan ??= _queryService.getLoanById(
        loans: state.loans, loanId: repayment!.loanId);
    var updatedLoan =
        _loanService.analyzeLoan(loan: loan, stateRepayments: state.repayments);
    await SqlLoanCrudRepository.update(updatedLoan);
  }

  Future<void> analyzePerson({Loan? loan, Repayment? repayment}) async {
    if (loan == null && repayment == null) {
      throw Exception("Either loan or repayment must be provided");
    }

    // Loan 분석 데이터가 갱신된 State
    loan ??= _queryService.getLoanById(
        loans: state.loans, loanId: repayment!.loanId);
    var updatedLoan =
        _loanService.analyzeLoan(loan: loan, stateRepayments: state.repayments);
    var stateLoans = state.loans
        .map((loan) => loan.loanId == updatedLoan.loanId ? updatedLoan : loan)
        .toList();

    // 동일한 ID의 Person 찾기
    var person = _queryService.getPersonById(
      people: state.people,
      personId: loan.personId,
    );

    // Person 분석 데이터를 업데이트
    var updatedPerson = _personService.analyzePerson(
        person: person, isLending: loan.isLending, stateLoans: stateLoans);

    (!updatedPerson.hasBorrow && !updatedPerson.hasLend)
        ? await SqlPersonCrudRepository.delete(updatedPerson)
        : await SqlPersonCrudRepository.update(updatedPerson);
  }
}

final ledgerViewModelProvider =
    StateNotifierProvider<LedgerViewModel, LedgerState>(
        (ref) => LedgerViewModel());
