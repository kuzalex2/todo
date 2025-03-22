// ignore_for_file: cast_nullable_to_non_nullable

import 'package:todo/domain/entity.dart';

class ToDoModel {
  const ToDoModel({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.localImages,
    required this.completed,
  });

  factory ToDoModel.fromSql(Map<String, Object?> map) => ToDoModel(
    id: map['id'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
    title: map['title'] as String,
    description: map['description'] as String?,
    localImages: (map['localImages'] as String?).split(',').toList(),
    completed: (map['completed'] as int) == 1,
  );

  static const tableName = 'todo';
  final String id;
  final DateTime createdAt;
  final String title;
  final String? description;
  final List<String> localImages;
  final bool completed;

  Map<String, Object?> get toSql => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'title': title,
    'description': description,
    'localImages': localImages.join(','),
    'completed': completed ? 1 : 0,
  };

  static String schema = '''
    (
      id TEXT PRIMARY KEY,
      createdAt TEXT NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      localImages TEXT NOT NULL,
      completed INTEGER NOT NULL
    )
  ''';
}

extension on String? {
  List<String> split(String separator) {
    if (this == null) return [];
    return this!.split(separator).where((s) => s.isNotEmpty).toList();
  }
}

extension TodoEntityToModel on TodoEntity {
  ToDoModel get toModel => ToDoModel(
    id: id.id,
    createdAt: createdAt,
    title: title,
    description: description,
    localImages: images.map((e) => e.toModel).whereType<String>().toList(),
    completed: completed,
  );
}

extension on TodoImageEntity {
  String? get toModel => switch (this) {
    TodoLocalImageEntity(localPath: final path) => path,
  };
}

extension ToDoModelToEntity on ToDoModel {
  TodoEntity get toEntity => TodoEntity(
    id: TodoIdEntity(id),
    createdAt: createdAt,
    title: title,
    description: description,
    images: localImages.map(TodoLocalImageEntity.new).toList(),
    completed: completed,
  );
}
