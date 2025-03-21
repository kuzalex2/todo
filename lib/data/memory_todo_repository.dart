import 'package:todo/domain/entity.dart';
import 'package:todo/domain/i_todo_repository.dart';

class MemoryTodoRepository implements ITodoRepository {
  final List<TodoEntity> _todos = [
    TodoEntity(
      id: const TodoIdEntity('id1'),
      title: 'title1',
      description: 'description1',
      images: const [],
      completed: false,
      createdAt: DateTime.now(),
    ),
    TodoEntity(
      id: const TodoIdEntity('id2'),
      title: 'title2',
      description: 'description2',
      images: const [],

      completed: false,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<TodoEntity>> fetch() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return _todos;
  }

  @override
  Future<List<TodoEntity>> add(TodoEntity item) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _todos
      ..removeWhere((element) => element.id == item.id)
      ..add(item);
    return _todos;
  }

  @override
  Future<List<TodoEntity>> delete(TodoEntity item) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    _todos.removeWhere((element) => element.id == item.id);
    return _todos;
  }
}
