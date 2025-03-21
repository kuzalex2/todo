import 'package:todo/domain/entity.dart';

abstract class ITodoRepository {
  Future<List<TodoEntity>> fetch();
  Future<List<TodoEntity>> add(TodoEntity item);
  Future<List<TodoEntity>> delete(TodoEntity item);
}
