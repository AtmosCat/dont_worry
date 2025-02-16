import 'package:dont_worry/data/model/repayment.dart';
import 'package:dont_worry/data/repository/sql_database.dart';

class SqlRepaymentCrudRepository {
  // Create
  static Future<Repayment> create(Repayment repayment) async {
    var db = await SqlDatabase().database;
    await db.insert(Repayment.tableName, repayment.toJson());
    await SqlDatabase.instance.recreateViews(db);
    return repayment.clone();
  }
  // Update
  static Future<int> update(Repayment repayment) async {
    var db = await SqlDatabase().database;
    int result = await db.update(
      Repayment.tableName,
      repayment.toJson(),
      where: '${RepaymentFields.repaymentId} = ?',
      whereArgs: [repayment.repaymentId],
    );
    await SqlDatabase.instance.recreateViews(db);
    return result;
  }
  // Delete
  static Future<int> delete(Repayment repayment) async {
    var db = await SqlDatabase().database;
    int result = await db.delete(
      Repayment.tableName,
      where: '${RepaymentFields.repaymentId} = ?',
      whereArgs: [repayment.repaymentId],
    );
    await SqlDatabase.instance.recreateViews(db);
    return result;
  }


  // Read Single By Id
  static Future<Repayment?> getById(String repaymentId) async {
    var db = await SqlDatabase().database;
    var result = await db.query(
      Repayment.tableName,
      columns: [
        RepaymentFields.personId,
        RepaymentFields.loanId,
        RepaymentFields.repaymentId,
        RepaymentFields.amount,
        RepaymentFields.date,
      ],
      where: '${RepaymentFields.repaymentId} = ?',
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
      whereClauses.add('${RepaymentFields.loanId} = ?');
      whereArgs.add(loanId);
    }

    var result = await db.query(
      Repayment.tableName,
      columns: [
        RepaymentFields.personId,
        RepaymentFields.loanId,
        RepaymentFields.repaymentId,
        RepaymentFields.amount,
        RepaymentFields.date,
      ],
      where: whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    return result.map((data) => Repayment.fromJson(data)).toList();
  }
}
