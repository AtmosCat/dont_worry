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

  // path 경로에 DB를 저장/열람
  Database? _database;
  Future<void> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'dont_worry.db');
    _database = await openDatabase(path, version: 1, onCreate: _databaseCreate);
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
        FOREIGN KEY(${RepaymentFields.personId}) REFERENCES ${Person.tableName}(${PersonFields.personId}) ON DELETE CASCADE
        FOREIGN KEY (${RepaymentFields.loanId}) REFERENCES ${Loan.tableName} (${LoanFields.loanId}) ON DELETE CASCADE
      )
    ''');
    await batch.commit();
  }

  // DB연결 종료 메서드
  void closeDatabase() async {
    if (_database != null) await _database!.close();
  }
}