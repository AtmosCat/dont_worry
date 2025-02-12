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
    return await db.update(
      Loan.tableName,
      loan.toJson(),
      where: '${LoanFields.loanId} = ? ',
      whereArgs: [loan.loanId],
    );
  }

  // Delete
  static Future<int> delete(Loan loan) async {
    var db = await SqlDatabase().database;
    return await db.delete(Loan.tableName,
        where: '${LoanFields.loanId} = ?', whereArgs: [loan.loanId]);
  }

  // Read Single By Id
  static Future<Loan?> getById(String loanId) async {
    var db = await SqlDatabase().database;
    var result = await db.query(
      Loan.tableName,
      columns: [
        LoanFields.personId,
        LoanFields.loanId,
        LoanFields.isLending,
        LoanFields.initialAmount,
        LoanFields.repayments,
        LoanFields.loanDate,
        LoanFields.dueDate,
        LoanFields.title,
        LoanFields.memo,
      ],
      where: '${LoanFields.loanId} = ?',
      whereArgs: [loanId],
    );
    return result.isNotEmpty ? Loan.fromJson(result.first) : null;
  }

  // Read List
  static Future<List<Loan>> getList(String? personId) async {
    var db = await SqlDatabase().database;
    var whereClauses = <String>[];
    var whereArgs = <dynamic>[];

    if (personId != null) {
      whereClauses.add('${LoanFields.personId} = ?');
      whereArgs.add(personId);
    }

    var result = await db.query(
      Loan.tableName,
      columns: [
        LoanFields.personId,
        LoanFields.loanId,
        LoanFields.isLending,
        LoanFields.initialAmount,
        LoanFields.repayments,
        LoanFields.loanDate,
        LoanFields.dueDate,
        LoanFields.title,
        LoanFields.memo,
      ],
      where: whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null,
      whereArgs: whereArgs,
    );

    return result.map((r) => Loan.fromJson(r)).toList();
  }
}
