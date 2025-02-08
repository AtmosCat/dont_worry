import 'package:dont_worry/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 상태 클래스
class SignupState {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  SignupState({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });
}

class SignupViewModel extends AutoDisposeNotifier<SignupState> {
  @override
  SignupState build() {
    return SignupState(name: "", email: "", password: "", phoneNumber: "");
  }

  final userRepository = UserRepository();

  Future<bool> signup({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    bool isSuccess = await userRepository.signup(
      context: context,
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
    return isSuccess;
  }
}

// 3. Provider 정의
final signupViewModel =
    NotifierProvider.autoDispose<SignupViewModel, SignupState>(
  () {
    return SignupViewModel();
  },
);
