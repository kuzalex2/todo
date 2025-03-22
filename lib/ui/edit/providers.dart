import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/domain/entity.dart';
import 'package:todo/domain/i_file_picker.dart';
import 'package:todo/domain/todo_list_provider.dart';

class TodoEditor extends Equatable {
  const TodoEditor(this.saved, this.editing);

  final TodoEntity saved;
  final TodoEntity editing;

  TodoEditor copyWith({TodoEntity? saved, TodoEntity? editing}) {
    return TodoEditor(saved ?? this.saved, editing ?? this.editing);
  }

  @override
  List<Object> get props => [saved, editing];
}

final oneTodoProvider = AsyncNotifierProvider.autoDispose
    .family<OneTodoNotifier, TodoEditor, TodoIdEntity>(OneTodoNotifier.new);

class OneTodoNotifier
    extends AutoDisposeFamilyAsyncNotifier<TodoEditor, TodoIdEntity> {
  @override
  Future<TodoEditor> build(TodoIdEntity id) async {
    final todos = await ref.watch(todoListProvider.future);
    final todo = todos.firstWhere((todo) => todo.id == id);
    return TodoEditor(todo, todo);
  }

  Future<void> onTitleChanged(String title) async {
    final previousState = await future;

    state = AsyncData(
      previousState.copyWith(
        editing: previousState.editing.copyWith(title: title),
      ),
    );
  }

  Future<void> onDescriptionChanged(String description) async {
    final previousState = await future;

    state = AsyncData(
      previousState.copyWith(
        editing: previousState.editing.copyWith(description: description),
      ),
    );
  }

  Future<void> addImage(TodoLocalImageEntity image) async {
    final previousState = await future;

    state = AsyncData(
      previousState.copyWith(
        editing: previousState.editing.copyWith(
          images: List.of(previousState.editing.images)..add(image),
        ),
      ),
    );
  }

  Future<void> save() async {
    final previousState = await future;

    try {
      await ref.read(todoListProvider.notifier).replace(previousState.editing);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

extension AsyncValueTodoEditorExtension on AsyncValue<TodoEditor> {
  bool get hasUnsavedChanges => hasValue && value?.saved != value?.editing;
}

class MockFilePicker implements IFilePicker {
  @override
  Future<FilePickerResult> pickFile() async => const FilePickerCancel();
}

final Provider<IFilePicker> filePicker = Provider((ref) {
  return MockFilePicker();
});
