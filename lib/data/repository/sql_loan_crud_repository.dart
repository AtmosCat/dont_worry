import 'dart:developer';

import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/repository/sql_database.dart';

class SqlLoanCrudRepository {
  // Create
  static Future<bool> create(Loan loan) async {
    try {
      var db = await SqlDatabase().database;
      int result = await db.insert(Loan.tableName, loan.toJson());
      return result > 0;
    } catch (e) {
      log("Database insert error: $e");
      return false;
    }
  }

  // Update
  static Future<bool> update(Loan loan) async {
    try {
      var db = await SqlDatabase().database;
      int updatedRows = await db.update(
        Loan.tableName,
        loan.toJson(),
        where: '${Loan.loanId_} = ?',
        whereArgs: [loan.loanId],
      );
      return updatedRows > 0; // 업데이트된 행이 있으면 true 반환
    } catch (e) {
      log("Loan 업데이트 실패: $e");
      return false; // 실패 시 false 반환
    }
  }

  // Delete
  static Future<bool> delete(Loan loan) async {
    var db = await SqlDatabase().database;
    int result = await db.delete(
      Loan.tableName,
      where: '${Loan.loanId_} = ?',
      whereArgs: [loan.loanId],
    );
    return result > 0; // 삭제된 행이 1개 이상이면 true, 아니면 false
  }

  // Read Single By Id
  static Future<Loan?> getById(String loanId) async {
    var db = await SqlDatabase().database;
    var result = await db.query(
      Loan.tableName,
      where: '${Loan.loanId_} = ?',
      whereArgs: [loanId],
    );
    return result.isNotEmpty ? Loan.fromJson(result.first) : null;
  }

  // Read List
  static Future<List<Loan>> getList({String? personId, bool? isLending}) async {
    var db = await SqlDatabase().database;
    var whereClauses = <String>[];
    var whereArgs = <dynamic>[];

    if (personId != null) {
      whereClauses.add('${Loan.personId_} = ?');
      whereArgs.add(personId);
    }

    if (isLending != null) {
      whereClauses.add('${Loan.isLending_} = ?');
      whereArgs.add(isLending ? 1 : 0);
    }

    var result = await db.query(
      Loan.tableName,
      where: whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null,
      whereArgs: whereArgs,
    );

    return result.map((r) => Loan.fromJson(r)).toList();
  }
}
