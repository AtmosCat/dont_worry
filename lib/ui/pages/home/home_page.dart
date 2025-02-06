import 'package:dont_worry/ui/pages/home/widgets/home_flexible_header.dart';
import 'package:dont_worry/ui/pages/home/widgets/home_tab_bar.dart';
import 'package:dont_worry/ui/pages/loan_list/loan_list_page.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:flutter/material.dart';

/*  TabBar + 애니메이션을 위해 세팅
  - TabController : 탭바 필수구성 (앱 성능을 위해 생명주기마다 on/off 관리)
  - SingleTickerProviderStateMixin : 탭 위치에 따른 애니메이션 구현, 관리 */

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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
      floatingActionButton: CreateLoanFloatingActionButton(), //플로팅버튼
      body: NestedScrollView(
        /* 상하 스크롤 시, 헤더 숨기기 + 탭바 고정을 위해 세팅
        - NestedScrollView
        - headerSliverBuilder */

        // 확장형 앱바
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              actions: [
                //앱바 우측 more 버튼
                IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showHomeAppBarBottomSheet(context); // more 버튼 바텀시트 호출 메서드
                    })
              ],
              expandedHeight: 200.0, //플렉서블 헤더의 최대 Height
              flexibleSpace: HomeFlexibleHeader(_tabController), // 플레서블 헤더 위젯
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0), // 앱바의 최소 Height
                child: HomeTabBar(_tabController), // 탭바 위젯
              ),
            ),
          ];
        },

        // TabBar 위치에 따라 하단 위젯 세팅
        body: TabBarView(controller: _tabController, children: const [
          LendTabView(), // 빌려간 돈 위젯
          BorrowTabView(), // 빌린 돈 위젯
        ]),
      ),
    );
  }

  // more 버튼 바텀시트 호출 메서드
  Future<dynamic> showHomeAppBarBottomSheet(BuildContext context) {    
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

// 플로팅버튼
class CreateLoanFloatingActionButton extends StatelessWidget {
  const CreateLoanFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        /* TODO: 플로팅버튼 액션
          - CreateLoanPage로 이동
          - 현재 TabBar가 lend인지 borrow인지 함께 전달 필요
        */
      },
      child: const Icon(Icons.add),
    );
  }
}

// '빌려준 돈' 탭의 View
class LendTabView extends StatelessWidget {
  const LendTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    /* TODO: '빌려준 돈' Person List 구현 */
    return ListView(
      padding: EdgeInsets.all(14),
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoanListPage(MyAction.lent, Category.person)),
          ),
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.red,
            ),
            
          ),
        )
      ]
    );
  }
}

// '빌린 돈' 탭의 View
class BorrowTabView extends StatelessWidget {
  const BorrowTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    /* TODO: '빌려준 돈' Person List 구현 */
    return Center(child: Text('빌려간 돈 Content', style: TextStyle(fontSize: 24)));
  }
}
