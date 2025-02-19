import 'dart:async';
import 'dart:developer';
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

class AppState {
  final List<Person> people;
  final List<Loan> loans;
  final List<Repayment> repayments;
  AppState({
    required this.people,
    required this.loans,
    required this.repayments,
  });
}

class AppViewModel extends StateNotifier<AppState> {
  final _queryService = QueryService();
  final _loanService = LoanService();
  final _personService = PersonService();

  AppViewModel() : super(AppState(people: [], loans: [], repayments: [])) {
    _init();
  }

  Future<void> _init() async {
    try {
      final people = await SqlPersonCrudRepository.getList();
      final loans = await SqlLoanCrudRepository.getList();
      final repayments = await SqlRepaymentCrudRepository.getList();

      state = AppState(people: people, loans: loans, repayments: repayments);
    } catch (e) {
      log('Error initializing data: $e');
    }
  }

  // Person CRUD
  Future<void> loadPeople() async {
    try {
      log("loadPeople() 실행");
      List<Person> people =
          await SqlPersonCrudRepository.getList(); // ❌ 여기서 멈출 가능성
      log("DB에서 사람 목록 가져오기 완료");

      state = AppState(
        people: people,
        loans: state.loans,
        repayments: state.repayments,
      );
      log("state 업데이트 완료, people 개수: ${people.length}");
    } catch (e) {
      log('Error loading loans: $e');
    }
  }

  Future<void> createPerson(Person person) async {
    await SqlPersonCrudRepository.create(person);
    log("DB에 $person 추가 완료");
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
      state = AppState(
        people: people,
        loans: loans,
        repayments: state.repayments,
      );
    } catch (e) {
      log('Error loading loans: $e');
    }
  }

  Future<void> createLoan(Loan loan) async {
    await SqlLoanCrudRepository.create(loan);
    log("DB에 $loan 추가 완료");
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
      state = AppState(
        people: people,
        loans: loans,
        repayments: repayments,
      );
    } catch (e) {
      log('Error loading loans: $e');
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
    List<Loan> loans = await SqlLoanCrudRepository.getList();
    List<Repayment> repayments = await SqlRepaymentCrudRepository.getList();
    loan ??= _queryService.getLoanById(loans: loans, loanId: repayment!.loanId);
    var updatedLoan =
        _loanService.analyzeLoan(loan: loan, stateRepayments: repayments);
    await SqlLoanCrudRepository.update(updatedLoan);
  }

  Future<void> analyzePerson({Loan? loan, Repayment? repayment}) async {
    if (loan == null && repayment == null) {
      throw Exception("Either loan or repayment must be provided");
    }

    List<Person> people = await SqlPersonCrudRepository.getList();
    List<Loan> loans = await SqlLoanCrudRepository.getList();

    loan ??= _queryService.getLoanById(loans: loans, loanId: repayment!.loanId);

    // 동일한 ID의 Person 찾기
    var person = _queryService.getPersonById(
      people: people,
      personId: loan.personId,
    );
    // Person 분석 데이터를 업데이트
    var updatedPerson = _personService.analyzePerson(
        person: person, isLending: loan.isLending, stateLoans: loans);

    log('삭제 검증 시작');
    (!updatedPerson.hasBorrow && !updatedPerson.hasLend)
        ? await SqlPersonCrudRepository.delete(updatedPerson)
        : await SqlPersonCrudRepository.update(updatedPerson);
    log('삭제 완료');
  }
}

final appViewModelProvider =
    StateNotifierProvider<AppViewModel, AppState>((ref) => AppViewModel());
