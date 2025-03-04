import 'dart:developer';
import 'dart:io';
import 'package:dont_worry/data/app_view_model.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/repository/sql_database.dart';
import 'package:dont_worry/data/shared_preferences/tab_preferences.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/widgets/create_loan_floating_action_button.dart';
import 'package:dont_worry/ui/pages/home/widgets/home_flexible_header.dart';
import 'package:dont_worry/ui/pages/home/widgets/home_tab_bar.dart';
import 'package:dont_worry/ui/pages/home/widgets/home_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // 탭바 애니메이션을 위해 TickerPdovider + TabController 세팅
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    log('탭 컨트롤러 세팅!');
    _tabController = TabController(length: 2, vsync: this);
    loadLastTab();
    _tabController.addListener(() async {
      if (_tabController.index != _tabController.previousIndex) {
        await TabPreference.saveSelectedTab(_tabController.index);
      }
    });
  }

  Future<void> loadLastTab() async {
    int lastTab = await TabPreference.getSelectedTab();
    if (mounted) {
      setState(() {
        _tabController.index = lastTab;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // HomePage UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CreateLoanFloatingActionButton(tabController: _tabController),
      body: NestedScrollView(
        // #1. 확장형 Silver 앱바 세팅
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              // #1-1. 상단 앱바
              pinned: true,
              centerTitle: true,
              title: Title(
                  color: AppColor.containerWhite.of(context),
                  child: Text('돈워리',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColor.primaryBlue.of(context)))),
              actions: [
                IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showMoreBottomSheet(context); // more 버튼 바텀시트
                    })
              ],
              // #1-2. (확장) 플렉서블 헤더 -> 위젯
              flexibleSpace: HomeFlexibleHeader(_tabController),
              expandedHeight: 240.0, //최대 높이
              // #1-3. (축소) 탭바 -> 위젯
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0), // 최소 높이
                child: HomeTabBar(_tabController),
              ),
            ),
          ];
        },

        // #2. 탭바 뷰 세팅 -> 위젯
        body: TabBarView(controller: _tabController, children: [
          HomeTabView(isLending: true), // 빌려간 돈 위젯
          HomeTabView(isLending: false), // 빌린 돈 위젯
        ]),
      ),
      // #3. 하단 네비게이션바 -> 위젯
      // bottomNavigationBar: HomeBottomAppBar(_tabController)
    );
  }


  // more 버튼 바텀시트 호출 메서드
  Future<dynamic> showMoreBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: SizedBox(
            height: 200,
            child: Column(
              children: <Widget>[
                Consumer(
                    builder: (context, ref, child) => ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('TEST_Person 생성'),
                        onTap: () {
                          createPerson(
                            context: context,
                            ref: ref,
                          );
                          Navigator.pop(context);
                        })),
                ListTile(
                  leading: Icon(Icons.delete,
                      color: AppColor.primaryRed.of(context)),
                  title: Text(
                    'TEST_DB 완전 초기화',
                    style: TextStyle(
                        color: AppColor.primaryRed.of(context),
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    deleteDatabaseFile();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteDatabaseFile() async {
    await SqlDatabase.deleteDatabaseFile();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('경고'),
          content: Text('데이터베이스가 초기화되었습니다. 앱을 종료합니다.'),
          actions: [
            TextButton(
                onPressed: () {
                  exit(0); // 앱 종료
                },
                child: Text('확인'))
          ],
        );
      },
    );
  }

  void createPerson(
      {required BuildContext context, required WidgetRef ref}) async {
    Person newPerson = Person(name: '이름');
    await ref.read(appViewModelProvider.notifier).createPerson(newPerson);
  }
}