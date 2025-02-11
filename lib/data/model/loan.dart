import 'package:dont_worry/data/model/repayment.dart';
import 'package:uuid/uuid.dart';

/* SQL 사용을 위해,
tableName과 Fields{} 클래스를 정의해줬습니다 */

/* 모든 파라미터를 'string' key로
- 반드시 Id를 가지고 있을 것
- 상위 클래스 Person의 Id를 가지고 있을 것
- 하위 클래스에 대한 List<Repayment>는 생략 */

class LoanFields{
  static final String personId = 'personId';
  static final String loanId = 'loanId';
  static final String isLending = 'isLending';
  static final String initialAmount = 'initialAmount';
  static final String loanDate = 'loanDate';
  static final String dueDate = 'dueDate';
  static final String title = 'title';
  static final String memo = 'memo';
}

class Loan {
  static String tableName = 'loan';  // 테이블 이름을 'string' key로
  String personId;
  String loanId;
  bool isLending; // 빌리는지, 빌려주는지 여부
  int initialAmount; // 최초 대출금액
  List<Repayment>? repayments; //상환 내역
  DateTime loanDate; // 차용일
  DateTime? dueDate; // 변제일
  String title; //제목 (= 기본값 loanDate)
  String? memo; // 세부메모

  Loan({
    required this.personId,
    String? loanId,
    required this.isLending,
    required this.initialAmount,
    this.repayments,
    required this.loanDate,
    this.dueDate,
    required this.title,
    this.memo,
  }) : loanId = loanId ?? Uuid().v4();
}

// 상환액 (상환내역의 총합)
int totalRepaymentAmount(List<Repayment> repayments) {
  int total = 0;
  for (var repayment in repayments) {
    total += repayment.amount;
  }
  return total;
}

// 잔여대출액 {최초대출금액 - 상환액}
int remainingLoanAmount(int initialAmount, List<Repayment> repayments) {
  return initialAmount - totalRepaymentAmount(repayments);
}

// 상환비율
double repaymentRate(int initialAmount, List<Repayment> repayments) {
  return totalRepaymentAmount(repayments) / initialAmount;
}

// 변제일까지의 D-day
int daysUntilDueDate(DateTime dueDate) {
  final now = DateTime.now();
  return dueDate.difference(now).inDays;
}
