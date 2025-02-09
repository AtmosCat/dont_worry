class Repayment {
  int amount; // 상환액수 (원 단위)
  DateTime date; // 상환일자

  Repayment({
    required this.amount,
    required this.date,
  });

  Repayment.fromJson(Map<String, dynamic> json)
      : this(
          amount: json['amount'],
          date: DateTime.parse(json['date']),
        );

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}
