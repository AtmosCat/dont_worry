import 'package:dont_worry/data/model/loan.dart';

class User {
  String name;
  String email;
  String password;
  String phoneNumber;
  List<Loan> loans;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.loans,
  });
}