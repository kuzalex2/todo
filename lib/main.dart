import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/external_file_picker.dart';
// ignore: unused_import
import 'package:todo/data/memory_todo_repository.dart';
// ignore: unused_import
import 'package:todo/data/sqllite/sqlite_repository.dart';
import 'package:todo/domain/todo_list_provider.dart';
import 'package:todo/ui/edit/providers.dart';
import 'package:todo/ui/home/todo_home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      /// simple DI
      overrides: [
        // todoRepositoryProvider.overrideWithValue(MemoryTodoRepository()),
        todoRepositoryProvider.overrideWithValue(SqliteRepository()),
        filePicker.overrideWithValue(ExternalFilePicker()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Demo',
      darkTheme: ThemeData.dark().copyWith(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TodoHomePage(),
    );
  }
}
