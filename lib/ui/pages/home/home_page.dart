import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/home/widgets/home_flexible_header.dart';
import 'package:dont_worry/ui/pages/home/widgets/home_tab_bar.dart';
import 'package:dont_worry/ui/pages/home/widgets/person_card.dart';
import 'package:dont_worry/ui/widgets/detail_app_bar.dart';
import 'package:dont_worry/ui/pages/home/widgets/home_bottom_app_bar.dart';
import 'package:dont_worry/ui/widgets/list_header.dart';
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton:
      //     CreateLoanFloatingActionButton(_tabController), //플로팅버튼
      bottomNavigationBar: AnimatedBuilder(
          animation: _tabController.animation!,
          builder: (context, child) {
            final double value = _tabController.animation!.value;
            final int currentIndex = (value + 0.5).floor();
            return HomeBottomAppBar(
                myAction: currentIndex == 0 ? MyAction.lend : MyAction.borrow);
          }),
      body: NestedScrollView(
        /* 상하 스크롤 시, 헤더 숨기기 + 탭바 고정을 위해 세팅
        - NestedScrollView
        - headerSliverBuilder */

        // 확장형 앱바
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              title: Title(
                  color: AppColor.containerWhite.of(context),
                  child: Text(
                    '돈워리', // 추후 로고 개발예정
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColor.primaryBlue.of(context)),
                  )),
              centerTitle: true,
              actions: [
                //앱바 우측 more 버튼
                IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showHomeAppBarBottomSheet(context); // more 버튼 바텀시트 호출 메서드
                    })
              ],
              expandedHeight: 240.0, //플렉서블 헤더의 최대 Height
              flexibleSpace: HomeFlexibleHeader(_tabController), // 플레서블 헤더 위젯
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0), // 앱바의 최소 Height
                child: HomeTabBar(_tabController), // 탭바 위젯
              ),
            ),
          ];
        },

        // TabBar 위치에 따라 하단 위젯 세팅
        body: TabBarView(controller: _tabController, children: [
          PersonTabView(myAction: MyAction.lend), // 빌려간 돈 위젯
          PersonTabView(myAction: MyAction.borrow), // 빌린 돈 위젯
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

// '빌려준 돈', '빌린 돈' 탭의 View
class PersonTabView extends StatelessWidget {
  final MyAction myAction;
  PersonTabView({
    required this.myAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    /* TODO: '빌려준 돈' Person List 구현 */
    return ListView(padding: EdgeInsets.all(4), children: [
      ListHeader(myAction: myAction, category: Category.person),
      PersonCard(myAction: myAction, person: dummyPerson1),
      ListHeader(category: Category.person),
      PersonCard(
          myAction: myAction,
          person: dummyPerson2),
      PersonCard(
          myAction: myAction,
          person: dummyPerson2),
      PersonCard(
          myAction: myAction,
          person: dummyPerson2),
      SizedBox(height: 60)
    ]);
  }

// 더미데이터
  final Person dummyPerson1 = Person(
    personId: 'test001_person',
    name: '홍길동',
    loans: [
      Loan(
        personId: 'test001_person',
        loanId: 'test001_loan',
        isLending: true, // 빌려준 돈
        initialAmount: 10000, // 1만원
        repayments: [
          Repayment(
              personId: 'test001_person',
              loanId: 'test001_loan',
              repaymentId: 'test001_repayment',
              amount: 5000,
              date: DateTime(2024, 10, 26)),
        ], // 5천원 상환
        loanDate: DateTime(2024, 10, 25), // 2024년 10월 25일
        dueDate: DateTime(2024, 11, 24), // 2024년 11월 24일
        title: '간식값',
        memo: '내일까지 갚아라',
      )
    ], // 빈 리스트
    memo: '특이사항 없음',
  );

  final Person dummyPerson2 = Person(
            personId: 'test002_person',
            name: '다가픔',
            loans: [], // 빈 리스트
            memo: '특이사항 없음',
          );
}