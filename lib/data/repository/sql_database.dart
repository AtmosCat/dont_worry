import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/model/repayment.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDatabase {
  // 단 하나의 DB를 사용 (싱글톤 패턴)
  static final SqlDatabase instance = SqlDatabase._instance();
  SqlDatabase._instance() {
    _initDatabase();
  }
  factory SqlDatabase() {
    return instance;
  }
  Future<Database> get database async {
    if (_database == null) {
      await _initDatabase();
    }
    return _database!;
  }

  // path 경로에 DB를 저장/열람
  Database? _database;
  Future<void> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'dont_worry.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        _databaseCreate(db, version); // 테이블 생성
        await createViews(db); // 초기 뷰 생성
      },
      onOpen: (db) async {
        await recreateViews(db); // 앱 실행 시 최신 뷰로 재생성
      },
    );
  }

  // path 경로에 DB를 제거
  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dont_worry.db');
    await deleteDatabase(path);
    print('Database deleted');
  }

  // SQL 테이블 구조 작성
  void _databaseCreate(Database db, int version) async {
    var batch = db.batch();
    batch.execute('''
  CREATE TABLE ${Person.tableName}(
    ${PersonFields.personId} TEXT NOT NULL PRIMARY KEY,
    ${PersonFields.name} TEXT NOT NULL,
    ${PersonFields.memo} TEXT
  )
''');

    batch.execute('''
  CREATE TABLE ${Loan.tableName}(
    ${LoanFields.personId} TEXT NOT NULL,
    ${LoanFields.loanId} TEXT NOT NULL PRIMARY KEY,
    ${LoanFields.isLending} INTEGER NOT NULL,
    ${LoanFields.initialAmount} INTEGER NOT NULL,
    ${LoanFields.loanDate} TEXT NOT NULL,
    ${LoanFields.dueDate} TEXT NOT NULL,
    ${LoanFields.title} TEXT NOT NULL,
    ${LoanFields.memo} TEXT NOT NULL,
    FOREIGN KEY (${LoanFields.personId}) REFERENCES ${Person.tableName} (${PersonFields.personId}) ON DELETE CASCADE
  )
''');

    batch.execute('''
  CREATE TABLE ${Repayment.tableName}(
    ${RepaymentFields.personId} TEXT NOT NULL,
    ${RepaymentFields.loanId} TEXT NOT NULL,
    ${RepaymentFields.repaymentId} TEXT NOT NULL PRIMARY KEY,
    ${RepaymentFields.amount} INTEGER NOT NULL,
    ${RepaymentFields.date} TEXT NOT NULL,
    FOREIGN KEY(${RepaymentFields.personId}) REFERENCES ${Person.tableName}(${PersonFields.personId}) ON DELETE CASCADE,
    FOREIGN KEY (${RepaymentFields.loanId}) REFERENCES ${Loan.tableName} (${LoanFields.loanId}) ON DELETE CASCADE
  )
''');

    await batch.commit();
  }
Future<void> createViews(Database db) async {
  await db.execute('''
  CREATE VIEW ${Loan.viewName} AS
  SELECT
    ${LoanFields.personId},
    ${LoanFields.loanId},
    ${LoanFields.isLending},
    ${LoanFields.initialAmount},
    ${LoanFields.loanDate},
    ${LoanFields.dueDate},
    ${LoanFields.title},
    ${LoanFields.memo},
    COALESCE(SUM(${RepaymentFields.amount}), 0) AS ${LoanFields.repayedAmount},
    ${LoanFields.initialAmount} - COALESCE(SUM(${RepaymentFields.amount}), 0) AS ${LoanFields.remainingAmount},
    CASE
      WHEN ${LoanFields.initialAmount} = 0 THEN 0
      ELSE COALESCE(SUM(${RepaymentFields.amount}), 0) / ${LoanFields.initialAmount} 
    END AS ${LoanFields.repaymentRate},
    COALESCE(JULIANDAY(${LoanFields.dueDate}) - JULIANDAY(CURRENT_DATE), 0) AS ${LoanFields.dDay}, -- ✅ NULL 방지
    COALESCE(MAX(${RepaymentFields.date}), '') AS ${LoanFields.lastRepayedDate} -- ✅ NULL 방지
  FROM ${Loan.tableName} AS ${Loan.tableName}
  LEFT JOIN ${Repayment.tableName} AS ${Repayment.tableName}
    ON ${LoanFields.loanId} = ${RepaymentFields.loanId}
  GROUP BY ${LoanFields.loanId}
    ''');

 await db.execute('''
DROP VIEW IF EXISTS ${Person.viewName};
CREATE VIEW ${Person.viewName} AS
SELECT
  ${PersonFields.personId} TEXT NOT NULL PRIMARY KEY,
  ${PersonFields.name} TEXT NOT NULL,
  ${PersonFields.memo} TEXT,
  COALESCE(SUM(${LoanFields.repayedAmount}), 0) AS ${PersonFields.repayedAmount},
  COALESCE(SUM(${LoanFields.remainingAmount}), 0) AS ${PersonFields.remainingAmount},
  COALESCE(JULIANDAY(COALESCE(MAX(${LoanFields.dueDate}), CURRENT_DATE)) - JULIANDAY(CURRENT_DATE), 0) AS ${PersonFields.dDay}, -- ✅ NULL 방지
  COALESCE(MAX(${LoanFields.lastRepayedDate}), '') AS ${PersonFields.lastRepayedDate} -- ✅ NULL 방지
FROM ${Person.tableName} AS ${Person.tableName}
LEFT JOIN (SELECT * FROM ${Loan.viewName}) AS ${Loan.viewName} -- ✅ Loan이 없을 경우 방어 처리
  ON ${PersonFields.personId} = ${LoanFields.personId}
GROUP BY ${PersonFields.personId}
''');

}


  Future<void> recreateViews(Database db) async {
    await db.execute('DROP VIEW IF EXISTS ${Loan.viewName}');
    await db.execute('DROP VIEW IF EXISTS ${Person.viewName}');
    await createViews(db); // 뷰 다시 생성
  }

  // DB연결 종료 메서드
  void closeDatabase() async {
    if (_database != null) await _database!.close();
  }
}
