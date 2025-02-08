import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/user.dart';
import 'package:dont_worry/data/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 상태클래스 만들기
class HomeState {
  List<Loan> loans;

  HomeState({
    required this.loans,
  });
}

// 뷰모델 만들기
class HomeViewModel extends AutoDisposeNotifier<HomeState> {
  @override
  HomeState build() {

    fetchLoans();

    return HomeState(
      loans: [],
    );
  }

  final userRepository = UserRepository();

  // currentUser의 대출 리스트 가져오기
  Future<void> fetchLoans() async {
    final loans = await userRepository.getLoans();
    state = HomeState(
      loans: loans ?? [],
    );
  }

}

// 3. 뷰모델 관리자 만들기
final homeViewModel =
    NotifierProvider.autoDispose<HomeViewModel, HomeState>(
  () {
    return HomeViewModel();
  },
);
