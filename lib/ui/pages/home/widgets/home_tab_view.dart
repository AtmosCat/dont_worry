import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/ui/pages/home/widgets/person_card.dart';
import 'package:dont_worry/ui/widgets/list_header.dart';
import 'package:dont_worry/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTabView extends StatelessWidget {
  final bool isLending;
  HomeTabView({
    required this.isLending,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(4), children: [
      ListHeader(isLending: isLending, unitType: UnitType.person),
      personList(),
      ListHeader(unitType: UnitType.person),
      personList(),
      SizedBox(height: 60)
    ]);
  }

  Consumer personList() {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final peopleState = ref.watch(appViewModelProvider).people;
      

      return peopleState.isEmpty
          ? const Center(child: CircularProgressIndicator()) // 로딩 중
          : Column(
              children: List.generate(
                peopleState.length,
                (index) =>
                    PersonCard(person: peopleState[index], isLending: isLending),
              ),
            );
    });
  }
}