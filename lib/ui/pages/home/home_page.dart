import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/home/widgets/home_flexible_header.dart';
import 'package:dont_worry/ui/pages/home/widgets/home_tab_bar.dart';
import 'package:dont_worry/ui/pages/home/widgets/home_tab_view.dart';
import 'package:dont_worry/ui/widgets/common_detail_app_bar.dart';
import 'package:dont_worry/ui/pages/home/widgets/home_bottom_app_bar.dart';
import 'package:flutter/material.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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
            HomeTabView(myAction: MyAction.lend), // 빌려간 돈 위젯
            HomeTabView(myAction: MyAction.borrow), // 빌린 돈 위젯
          ]),
        ),
        // #3. 하단 네비게이션바 -> 위젯
        bottomNavigationBar: HomeBottomAppBar(_tabController));
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
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('준비중'),
                  onTap: () {
                    /* TODO: more 버튼 기능 기획, 구현 필요
                    - 알림 등 앱 설정, 약관 확인 등...
                    */
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
}


