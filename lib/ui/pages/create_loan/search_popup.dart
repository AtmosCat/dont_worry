import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/repository/sql_person_crud_repository.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';

class SearchPopup extends StatefulWidget {
  final Function(Person) onSelect;

  SearchPopup({required this.onSelect});

  @override
  _SearchPopupState createState() => _SearchPopupState();
}

class _SearchPopupState extends State<SearchPopup> {
  List<Person> allPeople = [];
  List<Person> filteredPeople = [];
  List<String> allPeopleNames = [];
  List<String> filteredPeopleNames = [];
  TextEditingController searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    fetchPeople();
  }

  Future<void> fetchPeople() async {
    List<Person> allPeople = await SqlPersonCrudRepository.getList();
    filteredPeople = allPeople;
    setState(() {
      allPeopleNames = allPeople.map((person) => person.name).toList();
      filteredPeopleNames = allPeopleNames;
    });
  }

  void _filterPeople(String query) {
    setState(() {
      filteredPeopleNames = allPeopleNames
          .where((name) => name.contains(query))
          .toList();
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
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPeopleNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredPeopleNames[index]),
                    onTap: () {
                      widget.onSelect(filteredPeople[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}