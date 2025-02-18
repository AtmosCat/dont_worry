import 'dart:developer';

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

  // path 경로에 DB를 제거
  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dont_worry.db');
    await deleteDatabase(path);
    log('Database deleted');
  }

  // SQL 테이블 구조 작성
  void _databaseCreate(Database db, int version) async {
    var batch = db.batch();
    batch.execute('''
  CREATE TABLE ${Person.tableName}(
    ${Person.personId_} TEXT PRIMARY KEY,
    ${Person.updatedAt_} TEXT NOT NULL,
    ${Person.name_} TEXT NOT NULL,
    ${Person.memo_} TEXT,
    ${Person.hasLend_} INTEGER NOT NULL DEFAULT 0,
    ${Person.hasBorrow_} INTEGER NOT NULL DEFAULT 0,
    ${Person.repaidLendAmount_} INTEGER NOT NULL DEFAULT 0,
    ${Person.repaidBorrowAmount_} INTEGER NOT NULL DEFAULT 0,
    ${Person.remainingLendAmount_} INTEGER NOT NULL DEFAULT 0,
    ${Person.remainingBorrowAmount_} INTEGER NOT NULL DEFAULT 0,
    ${Person.isLendPaidOff_} INTEGER NOT NULL DEFAULT 0,
    ${Person.isBorrowPaidOff_} INTEGER NOT NULL DEFAULT 0,
    ${Person.upcomingLendDueDate_} TEXT,
    ${Person.upcomingBorrowDueDate_} TEXT,
    ${Person.lastLendRepaidDate_} TEXT,
    ${Person.lastBorrowRepaidDate_} TEXT
  )
''');

    batch.execute('''
  CREATE TABLE ${Loan.tableName}(
    ${Loan.loanId_} TEXT PRIMARY KEY,
    ${Loan.personId_} TEXT NOT NULL,
    ${Loan.updatedAt_} TEXT NOT NULL,
    ${Loan.isLending_} INTEGER NOT NULL DEFAULT 0,
    ${Loan.initialAmount_} INTEGER NOT NULL,
    ${Loan.loanDate_} TEXT NOT NULL,
    ${Loan.dueDate_} TEXT,
    ${Loan.title_} TEXT NOT NULL,
    ${Loan.memo_} TEXT,
    ${Loan.repaidAmount_} INTEGER NOT NULL DEFAULT 0,
    ${Loan.remainingAmount_} INTEGER NOT NULL DEFAULT 0,
    ${Loan.repaymentRate_} REAL NOT NULL,
    ${Loan.isPaidOff_} INTEGER NOT NULL DEFAULT 0,
    ${Loan.lastRepaidDate_} TEXT,
    FOREIGN KEY (${Loan.personId_}) REFERENCES ${Person.tableName} (${Person.personId_}) ON DELETE CASCADE
  )
''');

    batch.execute('''
  CREATE TABLE ${Repayment.tableName}(
    ${Repayment.repaymentId_} TEXT PRIMARY KEY,
    ${Repayment.personId_} TEXT NOT NULL,
    ${Repayment.loanId_} TEXT NOT NULL,
    ${Repayment.isLending_} INTEGER NOT NULL,
    ${Repayment.amount_} INTEGER NOT NULL,
    ${Repayment.date_} TEXT NOT NULL,
    FOREIGN KEY(${Repayment.personId_}) REFERENCES ${Person.tableName}(${Person.personId_}) ON DELETE CASCADE,
    FOREIGN KEY (${Repayment.loanId_}) REFERENCES ${Loan.tableName} (${Loan.loanId_}) ON DELETE CASCADE
  )
''');

    await batch.commit();
  }

  // DB연결 종료 메서드
  void closeDatabase() async {
    if (_database != null) await _database!.close();
  }
}
