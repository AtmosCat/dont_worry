import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/data/repository/sql_repayment_crud_repository.dart';
import 'package:dont_worry/ui/pages/loan_detail/widgets/repayment_card.dart';
import 'package:flutter/material.dart';

class RepaymentList extends StatelessWidget {
  const RepaymentList({super.key});

  Future<List<Repayment>> _loadRepaymentData() async {
    return await SqlRepaymentCrudRepository.getList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadRepaymentData(),
        builder: (context, AsyncSnapshot<List<Repayment>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Not Support Sqflite'));
          }

          if (snapshot.hasData) {
            var datas = snapshot.data;
            return Column(
                children: List.generate(datas!.length,
                        (index) => RepaymentCard(repayment: datas[index]))
                    .toList());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}