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
    _database = await openDatabase(path, version: 1, onCreate: _databaseCreate);
  }

  // SQL 테이블 구조 작성
  void _databaseCreate(Database db, int version) async {
    var batch = db.batch();
    batch.execute('''
      create table ${Person.tableName}(
        ${PersonFields.personId} text not null primary key,
        ${PersonFields.name} text not null,
        ${PersonFields.loans} text not null,
        ${PersonFields.memo} text
      )
    ''');

    batch.execute('''
      create table ${Loan.tableName}(
        ${LoanFields.personId} text not null,
        ${LoanFields.loanId} text not null primary key,
        ${LoanFields.isLending} integer not null,
        ${LoanFields.initialAmount} integer not null,
        ${LoanFields.repayments} text not null,
        ${LoanFields.loanDate} text not null,
        ${LoanFields.dueDate} text not null,
        ${LoanFields.title} text not null,
        ${LoanFields.memo} text not null,
        foreign key (${LoanFields.personId}) references ${Person.tableName} (${PersonFields.personId}) on delete cascade
      )
    ''');

    batch.execute('''
      create table ${Repayment.tableName}(
        ${RepaymentFields.personId} text not null,
        ${RepaymentFields.loanId} text not null,
        ${RepaymentFields.repaymentId} text not null primary key,
        ${RepaymentFields.amount} integer not null,
        ${RepaymentFields.date} text not null,
        foreign key(${RepaymentFields.personId}) references ${Person.tableName}(${PersonFields.personId}) on delete cascade
        foreign key (${RepaymentFields.loanId}) references ${Loan.tableName} (${LoanFields.loanId}) on delete cascade
      )
    ''');
    await batch.commit();
  }

  // DB연결 종료 메서드
  void closeDatabase() async {
    if (_database != null) await _database!.close();
  }
}