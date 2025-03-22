import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/domain/todo_list_provider.dart';

class AddNewTodoWidget extends ConsumerStatefulWidget {
  const AddNewTodoWidget({super.key});

  @override
  AddNewTodoState createState() => AddNewTodoState();
}

class AddNewTodoState extends ConsumerState<AddNewTodoWidget> {
  final fieldText = TextEditingController();

  @override
  void dispose() {
    fieldText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
        bottom: MediaQuery.of(context).viewPadding.bottom,
      ),
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: fieldText,
                decoration: const InputDecoration(
                  labelText: 'What needs to be done?',
                ),
                onSubmitted: (value) {
                  ref.read(todoListProvider.notifier).add(value);
                  fieldText.clear();
                  // newTodoController.clear();
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                ref.read(todoListProvider.notifier).add(fieldText.text);
                fieldText.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
