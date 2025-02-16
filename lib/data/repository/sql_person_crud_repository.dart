import 'package:dont_worry/data/model/person.dart';
import 'package:dont_worry/data/repository/sql_database.dart';

class SqlPersonCrudRepository {
  // Create
  static Future<Person> create(Person person) async {
    var db = await SqlDatabase().database;
    await db.insert(Person.tableName, person.toJson());
    await SqlDatabase.instance.recreateViews(db);
    return person.clone();
  }

  // Update
  static Future<int> update(Person person) async {
    var db = await SqlDatabase().database;
    int result = await db.update(
      Person.tableName,
      person.toJson(),
      where: '${PersonFields.personId} = ?',
      whereArgs: [person.personId],
    );
    await SqlDatabase.instance.recreateViews(db);
    return result;
  }

  // Delete
  static Future<int> delete(Person person) async {
    var db = await SqlDatabase().database;
    int result = await db.delete(Person.tableName,
        where: '${PersonFields.personId} = ?', whereArgs: [person.personId]);
    await SqlDatabase.instance.recreateViews(db);
    return result;
  }

  static Future<Person?> getById(String personId) async {
    var db = await SqlDatabase().database;
    var result = await db.query(Person.tableName,
        columns: [PersonFields.personId, PersonFields.name, PersonFields.memo],
        where: '${PersonFields.personId} = ?',
        whereArgs: [personId]);

    return result.isNotEmpty ? Person.fromJson(result.first) : null;
  }

  static Future<List<Person>> getList() async {
    var db = await SqlDatabase().database;
    var result = await db.query(Person.tableName,
        columns: [PersonFields.personId, PersonFields.name, PersonFields.memo]);
    return result.map((r) => Person.fromJson(r)).toList();
  }

  static Future<List<Person>> getPersonSummaries() async {
    var db = await SqlDatabase().database;
    final result = await db.query(Person.viewName);

    return result.map((r) => Person.fromJson(r)).toList();
  }
}
