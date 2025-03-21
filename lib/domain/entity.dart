import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class TodoIdEntity extends Equatable {
  const TodoIdEntity(this.id);
  factory TodoIdEntity.create() => TodoIdEntity(const Uuid().v4());

  final String id;

  @override
  List<Object> get props => [id];
}

sealed class TodoImageEntity {
  const TodoImageEntity();
}

class TodoLocalImageEntity extends TodoImageEntity with EquatableMixin {
  const TodoLocalImageEntity(this.path);

  final String path;

  @override
  List<Object> get props => [path];
}

class TodoEntity extends Equatable {
  const TodoEntity({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.images,
    required this.completed,
  });

  factory TodoEntity.create(String title) => TodoEntity(
    id: TodoIdEntity.create(),
    title: title,
    description: null,
    images: const [],
    completed: false,
    createdAt: DateTime.now(),
  );

  final TodoIdEntity id;
  final DateTime createdAt;
  final String title;
  final String? description;
  final List<TodoImageEntity> images;
  final bool completed;

  TodoEntity copyWith({
    String? title,
    String? description,
    List<TodoImageEntity>? images,
    bool? completed,
  }) {
    return TodoEntity(
      id: id,
      createdAt: createdAt,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    completed,
    createdAt,
    description,
    images,
  ];
}
