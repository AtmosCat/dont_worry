import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';

class LoanListPage extends StatelessWidget {
  final MyAction myAction;
  final Category category;
  const LoanListPage(this.myAction, this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar(myAction, category),
    );
  }
}