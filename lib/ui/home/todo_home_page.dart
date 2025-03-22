import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/domain/todo_list_provider.dart';
import 'package:todo/ui/home/add_new_todo.dart';
import 'package:todo/ui/home/providers.dart';
import 'package:todo/ui/home/todo_list.dart';
import 'package:todo/ui/widgets.dart';

class TodoHomePage extends ConsumerWidget {
  const TodoHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(sortedTodos);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Todo list sample'),
        actions: [
          Visibility(visible: todos.hasValue, child: const _SortSwitcher()),
        ],
      ),
      body: todos.when(
        skipLoadingOnReload: true,
        loading: LoadingIndicator.new,
        error:
            (error, __) => MyErrorWidget(
              error,
              onRetry: () => ref.read(todoListProvider.notifier).reload(),
            ),
        data: TodoListWidget.new,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: Visibility(
        visible: todos.hasValue,
        child: const AddNewTodoWidget(),
      ),
    );
  }
}

class _SortSwitcher extends ConsumerWidget {
  const _SortSwitcher();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSort = ref.watch(todoSortToggle);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Sort by: ', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        DropdownButton<TodoSortField>(
          value: selectedSort,
          onChanged: (TodoSortField? newValue) {
            if (newValue != null) {
              ref.read(todoSortToggle.notifier).state = newValue;
            }
          },
          items: const [
            DropdownMenuItem(
              value: TodoSortField.titleAsc,
              child: Text('▲ Title'),
            ),
            DropdownMenuItem(
              value: TodoSortField.titleDesc,
              child: Text('▼ Title'),
            ),
            DropdownMenuItem(
              value: TodoSortField.createTimeAsc,
              child: Text('▲ Creation Time'),
            ),
            DropdownMenuItem(
              value: TodoSortField.createTimeDesc,
              child: Text('▼ Creation Time'),
            ),
          ],
        ),
      ],
    );
  }
}
