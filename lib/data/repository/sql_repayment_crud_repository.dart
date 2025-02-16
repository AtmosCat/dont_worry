import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/data/repository/sql_database.dart';

class SqlRepaymentCrudRepository {
  // Create
  static Future<Repayment> create(Repayment repayment) async {
    var db = await SqlDatabase().database;
    await db.insert(Repayment.tableName, repayment.toJson());
    return repayment.clone();
  }

  // Update
  static Future<int> update(Repayment repayment) async {
    var db = await SqlDatabase().database;
    return await db.update(
      Repayment.tableName,
      repayment.toJson(),
      where: '${Repayment.repaymentId_} = ?',
      whereArgs: [repayment.repaymentId],
    );
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
