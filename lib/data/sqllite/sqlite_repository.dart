import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data/sqllite/sqllite_model.dart';
import 'package:todo/domain/entity.dart';
import 'package:todo/domain/i_todo_repository.dart';

class SqliteRepository implements ITodoRepository {
  static const _dbName = 'todo_database.db';

  Future<Database> get _database async => openDatabase(
    join(await getDatabasesPath(), _dbName),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE ${ToDoModel.tableName}${ToDoModel.schema}',
      );
    },
    version: 1,
  );

  @override
  Future<List<TodoEntity>> fetch() async {
    final todos = await (await _database).query(ToDoModel.tableName);

    return [for (final item in todos) ToDoModel.fromSql(item).toEntity];
  }

  @override
  Future<List<TodoEntity>> add(TodoEntity item) async {
    // throw 'aaa';
    await (await _database).insert(
      ToDoModel.tableName,
      item.toModel.toSql,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return fetch();
  }

  @override
  Future<List<TodoEntity>> delete(TodoEntity item) async {
    await (await _database).delete(
      ToDoModel.tableName,
      where: 'id = ?',
      whereArgs: [item.id.id],
    );
    return fetch();
  }
}
