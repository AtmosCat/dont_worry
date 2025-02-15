import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/repository/sql_database.dart';

class SqlPersonCrudRepository {
  // Create
  static Future<Person> create(Person person) async {
    var db = await SqlDatabase().database;
    await db.insert(Person.tableName, person.toJson());
    return person.clone();
  }

  // Update
  static Future<bool> update(Person person) async {
    try {
      var db = await SqlDatabase().database;
      int updatedRows = await db.update(
        Person.tableName,
        person.toJson(),
        where: '${PersonFields.personId} = ?',
        whereArgs: [person.personId],
      );

      return updatedRows > 0; // 성공적으로 업데이트되면 true
    } catch (e) {
      print("업데이트 실패: $e"); // 예외 메시지 출력 (로그 확인용)
      return false; // 실패 시 false 반환
    }
  }

  // Delete
// Delete
  static Future<bool> delete(Person person) async {
    var db = await SqlDatabase().database;
    int result = await db.delete(
      Person.tableName,
      where: '${PersonFields.personId} = ?',
      whereArgs: [person.personId],
    );
    return result > 0; // 삭제된 행이 1개 이상이면 true, 아니면 false
  }

  static Future<Person?> getById(String personId) async {
    var db = await SqlDatabase().database;
    var result = await db.query(Person.tableName,
        columns: [
          PersonFields.personId,
          PersonFields.name,
          PersonFields.loans,
          PersonFields.memo
        ],
        where: '${PersonFields.personId} = ?',
        whereArgs: [personId]);

    return result.isNotEmpty ? Person.fromJson(result.first) : null;
  }

  static Future<List<Person>> getList() async {
    var db = await SqlDatabase().database;
    var result = await db.query(Person.tableName, columns: [
      PersonFields.personId,
      PersonFields.name,
      PersonFields.loans,
      PersonFields.memo
    ]);
    return result.map((r) => Person.fromJson(r)).toList();
  }
}
