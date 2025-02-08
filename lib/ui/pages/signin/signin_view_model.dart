import 'package:dont_worry/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 상태 클래스
class SigninState {
  final String email;
  final String password;

  SigninState({
    required this.email,
    required this.password,
  });
}

class SigninViewModel extends AutoDisposeNotifier<SigninState> {
  @override
  SigninState build() {
    return SigninState(
      email: "",
      password: "",
    );
  }

  final userRepository = UserRepository();

  Future<bool> signin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    bool isSuccess = await userRepository.signin(
      context: context,
      email: email,
      password: password,
    );
    return isSuccess;
  }
}

// 3. Provider 정의
final signinViewModel =
    NotifierProvider.autoDispose<SigninViewModel, SigninState>(
  () {
    return SigninViewModel();
  },
);
