import 'dart:async';

import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/repository/sql_person_crud_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  final List<Person> people;
  HomeState(this.people);
}

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(HomeState([])) {
    _init();
  }
  Future<void> _init() async {
    await loadPeople();
  }

  Future<void> loadPeople() async {
    try {
      List<Person> people = await SqlPersonCrudRepository.getList();
      state = HomeState(people);
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> createPerson(Person person) async {
    await SqlPersonCrudRepository.create(person);
    loadPeople();
  }

  Future<void> updatePerson(Person person) async {
    await SqlPersonCrudRepository.update(person);
    loadPeople();
  }

  Future<void> deletePerson(Person person) async {
    await SqlPersonCrudRepository.delete(person);
    loadPeople();
  }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) => HomeViewModel());
