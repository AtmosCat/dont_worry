import 'dart:developer';

import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/data/repository/sql_database.dart';

class SqlRepaymentCrudRepository {
  // Create
  static Future<bool> create(Repayment repayment) async {
    try {
      var db = await SqlDatabase().database;
      int result = await db.insert(
        Repayment.tableName,
        repayment.toJson(),
        // conflictAlgorithm: ConflictAlgorithm.replace, // 중복된 키 충동 시 기존 데이터 업데이트하는 옵션
      );
      return result > 0;
    } catch (e) {
      log("Repayment 생성 실패: $e");
      return false;
    }
  }

  // Update
  static Future<bool> update(Repayment repayment) async {
    try {
      var db = await SqlDatabase().database;
      int updatedRows = await db.update(
        Repayment.tableName,
        repayment.toJson(),
        where: '${Repayment.repaymentId_} = ?',
        whereArgs: [repayment.repaymentId],
      );
      return updatedRows > 0; // 업데이트된 행이 있으면 true 반환
    } catch (e) {
      log("Repayment 업데이트 실패: $e");
      return false; // 실패 시 false 반환
    }
  }

  // Delete
  static Future<int> delete(Repayment repayment) async {
    var db = await SqlDatabase().database;
    return await db.delete(
      Repayment.tableName,
      where: '${Repayment.repaymentId_} = ?',
      whereArgs: [repayment.repaymentId],
    );
  }

  // Read Single By Id
  static Future<Repayment?> getById(String repaymentId) async {
    var db = await SqlDatabase().database;
    var result = await db.query(
      Repayment.tableName,
      where: '${Repayment.repaymentId_} = ?',
      whereArgs: [repaymentId],
    );

    if (result.isNotEmpty) {
      return Repayment.fromJson(result.first);
    } else {
      return null;
    }
  }

  // Read List By Parent Id
  static Future<List<Repayment>> getList({String? loanId}) async {
    var db = await SqlDatabase().database;
    var whereClauses = <String>[];
    var whereArgs = <dynamic>[];

    if (loanId != null) {
      whereClauses.add('${Repayment.loanId_} = ?');
      whereArgs.add(loanId);
    }

    var result = await db.query(
      Repayment.tableName,
      where: whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    return result.map((data) => Repayment.fromJson(data)).toList();
  }
}
