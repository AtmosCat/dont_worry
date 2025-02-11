import 'package:uuid/uuid.dart';

class Repayment {
  String personId;
  String loanId;
  String repaymentId;
  int amount; // 상환액수 (원 단위)
  DateTime date; // 상환일자

  Repayment({
    required this.personId,
    required this.loanId,
    String? repaymentId,
    required this.amount,
    required this.date,
  }) : repaymentId = repaymentId ?? Uuid().v4();
}
