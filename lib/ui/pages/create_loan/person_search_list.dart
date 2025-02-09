import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/repository/user_repository.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';

class PersonSearchList extends StatefulWidget {
  final MyAction myAction;

  const PersonSearchList({
    required this.myAction,
    super.key,
  });

  @override
  State<PersonSearchList> createState() => _PersonSearchListState();
}

class _PersonSearchListState extends State<PersonSearchList> {
  final UserRepository userRepository = UserRepository();
  List<String> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  List<String> allItems = [];

  @override
  void initState() {
    super.initState();
    fetchPersons(); // 비동기 데이터 로드
    searchController.addListener(_filterItems);
  }

  /// 비동기적으로 데이터를 가져와 UI 업데이트
  Future<void> fetchPersons() async {
    List<Person> persons = await userRepository.getPersonList() ?? [];
    setState(() {
      allItems = persons.map((person) => person.name).toList();
      filteredItems = allItems;
    });
  }

  void _filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredItems =
          allItems.where((item) => item.toLowerCase().contains(query)).toList();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_filterItems);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // ScrollView로 감싸서 화면 넘침 방지
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: '이름을 입력하세요',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          // ListView가 filteredItems가 있을 때만 보이도록 설정
          if (filteredItems.isNotEmpty)
            SizedBox(
              height: 200, // ListView의 높이 설정
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredItems[index]),
                    onTap: () {
                      searchController.text = filteredItems[index]; // 항목 클릭 시 텍스트 설정
                      setState(() {
                        filteredItems.clear(); // 클릭 후 ListView 비우기
                      });
                      FocusScope.of(context).requestFocus(FocusNode()); // 포커스 해제
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
