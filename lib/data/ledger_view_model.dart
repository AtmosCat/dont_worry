import 'dart:async';
import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/data/repository/sql_loan_crud_repository.dart';
import 'package:dont_worry/data/repository/sql_person_crud_repository.dart';
import 'package:dont_worry/data/repository/sql_repayment_crud_repository.dart';
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

  LedgerViewModel()
      : super(LedgerState(people: [], loans: [], repayments: [])) {
    _init();
  }

  Future<void> _init() async {
    try {
      final people = await _queryService.getPeople();
      final loans = await _queryService.getLoans();
      final repayments = await _queryService.getRepayments();

      state = LedgerState(people: people, loans: loans, repayments: repayments);
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  // Person CRUD
  Future<void> loadPeople() async {
    List<Person> people = await _queryService.getPeople();
    state = LedgerState(
      people: people,
      loans: state.loans,
      repayments: state.repayments,
    );
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
    List<Loan> loans = await _queryService.getLoans();

    state = LedgerState(
      people: state.people,
      loans: loans,
      repayments: state.repayments,
    );
  }

  Future<void> createLoan(Loan loan) async {
    await SqlLoanCrudRepository.create(loan);
    await loadLoans();
  }

  Future<void> updateLoan(Loan loan) async {
    await SqlLoanCrudRepository.update(loan);
    await loadLoans();
  }

  Future<void> deleteLoan(Loan loan) async {
    await SqlLoanCrudRepository.delete(loan);
    await loadLoans();
  }

  // Repayment CRUD
  Future<void> loadRepayments() async {
    List<Repayment> repayments = await _queryService.getRepayments();
    
    state = LedgerState(
      people: state.people,
      loans: state.loans,
      repayments: repayments,
    );
  }

  Future<void> createRepayment(Repayment repayment) async {
    await SqlRepaymentCrudRepository.create(repayment);
    await loadRepayments();
  }

  Future<void> updateRepayment(Repayment repayment) async {
    await SqlRepaymentCrudRepository.update(repayment);
    await loadRepayments();
  }

  Future<void> deleteRepayment(Repayment repayment) async {
    await SqlRepaymentCrudRepository.delete(repayment);
    await loadRepayments();
  }
}

final ledgerViewModelProvider =
    StateNotifierProvider<LedgerViewModel, LedgerState>(
        (ref) => LedgerViewModel());