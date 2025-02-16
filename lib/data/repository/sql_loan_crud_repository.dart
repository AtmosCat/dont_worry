import 'package:dont_worry/data/model/loan.dart';
import 'package:dont_worry/data/repository/sql_database.dart';

class SqlLoanCrudRepository {
  // Create
  static Future<Loan> create(Loan loan) async {
    var db = await SqlDatabase().database;
    await db.insert(Loan.tableName, loan.toJson());
    return loan.clone();
  }

  // Update
  static Future<int> update(Loan loan) async {
    var db = await SqlDatabase().database;
    int result = await db.update(
      Loan.tableName,
      loan.toJson(),
      where: '${Loan.loanId_} = ? ',
      whereArgs: [loan.loanId],
    );
    return result;
  }

  // Delete
  static Future<int> delete(Loan loan) async {
    var db = await SqlDatabase().database;
    int result = await db.delete(Loan.tableName,
        where: '${Loan.loanId_} = ?', whereArgs: [loan.loanId]);
    return result;
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
