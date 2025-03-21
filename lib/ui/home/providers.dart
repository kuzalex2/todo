import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/domain/entity.dart';
import 'package:todo/domain/todo_list_provider.dart';

enum TodoSortField { createTimeAsc, createTimeDesc, titleAsc, titleDesc }

final todoSortToggle = StateProvider<TodoSortField>(
  (ref) => TodoSortField.titleAsc,
);

final todoListProvider =
    AsyncNotifierProvider.autoDispose<TodoList, List<TodoEntity>>(TodoList.new);

final sortedTodos = FutureProvider<List<TodoEntity>>((ref) async {
  final todos = await ref.watch(todoListProvider.future);
  final sortBy = ref.watch(todoSortToggle);

  final comparator = switch (sortBy) {
    TodoSortField.createTimeAsc =>
      (TodoEntity a, TodoEntity b) => a.createdAt.compareTo(b.createdAt),
    TodoSortField.createTimeDesc =>
      (TodoEntity a, TodoEntity b) => b.createdAt.compareTo(a.createdAt),
    TodoSortField.titleAsc =>
      (TodoEntity a, TodoEntity b) => a.title.compareTo(b.title),
    TodoSortField.titleDesc =>
      (TodoEntity a, TodoEntity b) => b.title.compareTo(a.title),
  };

  return todos..sort(comparator);
});
