import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo/domain/entity.dart';
import 'package:todo/ui/edit/todo_edit.dart';
import 'package:todo/ui/home/providers.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget(this.todos, {super.key});

  final List<TodoEntity> todos;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      children: [for (final todo in todos) _TodoItem(todo: todo)],
    );
  }
}

class _TodoItem extends ConsumerWidget {
  const _TodoItem({required this.todo});

  final TodoEntity todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap:
          () => Navigator.of(context).push<void>(
            MaterialPageRoute(builder: (context) => TodoEditPage(todo.id)),
          ),
      leading: Checkbox(
        value: todo.completed,
        onChanged:
            (value) => ref
                .read(todoListProvider.notifier)
                .replace(todo.copyWith(completed: !todo.completed)),
      ),
      title: todo.title.toTitleWidget,
      subtitle: todo.toDescriptionWidget,
      trailing: Wrap(
        children: [
          ...todo.numImagesWidget,
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed:
                () => _showDeleteConfirmation(
                  context,
                  onRemove:
                      () => ref.read(todoListProvider.notifier).remove(todo),
                ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, {VoidCallback? onRemove}) {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 0,
            left: 0,
            child: Material(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: AlertDialog(
                  title: const Text('Delete this item?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        overlayEntry?.remove();
                        overlayEntry = null;
                        onRemove?.call();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        overlayEntry?.remove();
                        overlayEntry = null;
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    if (overlayEntry != null) Overlay.of(context).insert(overlayEntry!);
  }
}

extension on String {
  Widget get toTitleWidget =>
      Text(this, maxLines: 1, overflow: TextOverflow.ellipsis);
}

extension on TodoEntity {
  Widget get toDescriptionWidget => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (description != null)
        Text(
          description!.replaceAll(RegExp(r'\n'), ''),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      Text(DateFormat('yMd').add_jm().format(createdAt)),
    ],
  );
  List<Widget> get numImagesWidget =>
      images.isNotEmpty
          ? [
            Text('${images.length} pics', style: const TextStyle(fontSize: 12)),
          ]
          : [];
}
