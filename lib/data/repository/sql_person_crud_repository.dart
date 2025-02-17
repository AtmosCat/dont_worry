import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/repository/sql_database.dart';

class SqlPersonCrudRepository {
  // Create
  static Future<Person> create(Person person) async {
    print("DB 연결 시도");
    var db = await SqlDatabase().database;
    print("DB 연결 성공");

    await db.insert(Person.tableName, person.toJson());
    print("데이터 삽입 완료");

    return person.clone();
  }

  // Update
  static Future<int> update(Person person) async {
    var db = await SqlDatabase().database;
    return await db.update(
      Person.tableName,
      person.toJson(),
      where: '${Person.personId_} = ?',
      whereArgs: [person.personId],
    );
  }

  // Delete
  static Future<int> delete(Person person) async {
    var db = await SqlDatabase().database;
    return await db.delete(Person.tableName,
        where: '${Person.personId_} = ?', whereArgs: [person.personId]);
  }

  static Future<Person?> getById(String personId) async {
    var db = await SqlDatabase().database;
    var result = await db.query(Person.tableName,
        where: '${Person.personId_} = ?', whereArgs: [personId]);

    return result.isNotEmpty ? Person.fromJson(result.first) : null;
  }

  static Future<List<Person>> getList() async {
    print("DB에서 사람 목록 가져오기 시작");
    var db = await SqlDatabase().database;
    print("DB 연결 성공");

    var result = await db.query(Person.tableName);
    print("쿼리 실행 완료, 결과 개수: ${result.length}");

    return result.map((r) => Person.fromJson(r)).toList();
  }
}
