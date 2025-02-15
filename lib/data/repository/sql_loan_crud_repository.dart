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
      print("Database insert error: $e");
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
        where: '${LoanFields.loanId} = ?',
        whereArgs: [loan.loanId],
      );
      return updatedRows > 0; // 업데이트된 행이 있으면 true 반환
    } catch (e) {
      print("Loan 업데이트 실패: $e");
      return false; // 실패 시 false 반환
    }
  }

  // Delete
  static Future<bool> delete(Loan loan) async {
    var db = await SqlDatabase().database;
    int result = await db.delete(
      Loan.tableName,
      where: '${LoanFields.loanId} = ?',
      whereArgs: [loan.loanId],
    );
    return result > 0; // 삭제된 행이 1개 이상이면 true, 아니면 false
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
  static Future<List<Loan>> getList({String? personId}) async {
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
