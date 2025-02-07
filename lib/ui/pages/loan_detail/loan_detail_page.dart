import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';

class LoanDetailPage extends StatelessWidget {
  final MyAction myAction;

  const LoanDetailPage(this.myAction, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar(myAction, Category.loan),
    );
  }
}
