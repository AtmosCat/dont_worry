import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPopup extends ConsumerStatefulWidget {
  final Function(Person) onSelect;

  SearchPopup({required this.onSelect});

  @override
  _SearchPopupState createState() => _SearchPopupState();
}

class _SearchPopupState extends ConsumerState<SearchPopup> {
  List<Person> allPeople = [];
  List<Person> filteredPeople = [];
  List<String> allPeopleNames = [];
  List<String> filteredPeopleNames = [];
  TextEditingController searchController = TextEditingController();
  Person selectedPerson = Person(name: "");

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      List<Person> allPeople = ref.read(appViewModelProvider).people;
      filteredPeople = allPeople;
      setState(() {
        allPeopleNames = allPeople.map((person) => person.name).toList();
        filteredPeopleNames = allPeopleNames;
      });
    });
  }

  void _filterPeople(String query) {
    setState(() {
      filteredPeopleNames =
          allPeopleNames.where((name) => name.contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        height: 400,
        child: Column(
          children: [
            TextField(
                controller: searchController,
                onChanged: _filterPeople,
                decoration: InputDecoration(
                    hintText: "이름을 입력하세요.",
                    prefixIcon: Icon(Icons.search),
                    labelStyle: TextStyle(color: AppColor.gray30.of(context)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColor.primaryBlue.of(context),
                          width: 2.0), // 포커스 시 테두리 색상
                    ),
                    border: OutlineInputBorder())),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPeopleNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredPeopleNames[index]),
                    onTap: () {
                      searchController.text = filteredPeopleNames[index];
                      selectedPerson = filteredPeople[index];
                      widget.onSelect(selectedPerson);
                    },
                  );
                },
              ),
            ),
            Container(
                alignment: Alignment.bottomRight,
                child: Consumer(
                    builder: (context, ref, child) => ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColor.primaryBlue.of(context)),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (searchController.text.trim().isEmpty) {
                              Navigator.pop(context);
                              SnackbarUtil.showSnackBar(
                                  context, "이름은 빈칸일 수 없습니다.");
                            } else if (allPeopleNames
                                .contains(searchController.text)) {
                              Navigator.pop(context);
                              SnackbarUtil.showSnackBar(
                                  context, "이미 존재하는 이름은 추가할 수 없습니다.");
                            } else {
                              final newPerson =
                                  Person(name: searchController.text);
                              widget.onSelect(newPerson);
                              await ref
                                  .read(appViewModelProvider.notifier)
                                  .createPerson(newPerson);
                              SnackbarUtil.showSnackBar(
                                  context, "사람 정보가 추가되었습니다.");
                            }
                          },
                          child: Text(
                            '직접 추가',
                            style: TextStyle(
                              color: AppColor.containerWhite.of(context),
                            ),
                          ),
                        ))),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
