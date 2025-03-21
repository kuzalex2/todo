import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/domain/entity.dart';
import 'package:todo/domain/i_todo_repository.dart';

final Provider<ITodoRepository> todoRepositoryProvider = Provider((ref) {
  /// will be overridden in DI
  return _EmptyTodoRepository();
});

class TodoList extends AutoDisposeAsyncNotifier<List<TodoEntity>> {
  @override
  Future<List<TodoEntity>> build() async {
    final repository = ref.read(todoRepositoryProvider);
    return repository.fetch();
  }

  Future<void> reload() async {
    ref.invalidateSelf();
  }

  Future<void> add(String title) async {
    if (title.isEmpty) {
      return;
    }
    final repository = ref.read(todoRepositoryProvider);
    try {
      final newTodos = await repository.add(TodoEntity.create(title));
      state = AsyncData(newTodos);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Future<void> replace(TodoEntity newItem) async {
    final repository = ref.read(todoRepositoryProvider);

    try {
      await repository.delete(newItem);
      final newTodos = await repository.add(newItem);

      state = AsyncData(newTodos);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Future<void> remove(TodoEntity target) async {
    final repository = ref.read(todoRepositoryProvider);

    try {
      final newTodos = await repository.delete(target);
      state = AsyncData(newTodos);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}

class _EmptyTodoRepository implements ITodoRepository {
  @override
  Future<List<TodoEntity>> fetch() async {
    return [];
  }

  @override
  Future<List<TodoEntity>> add(TodoEntity item) {
    throw UnimplementedError();
  }

  @override
  Future<List<TodoEntity>> delete(TodoEntity item) {
    throw UnimplementedError();
  }
}
