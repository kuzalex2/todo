import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/domain/entity.dart';
import 'package:todo/domain/i_file_picker.dart';
import 'package:todo/ui/edit/providers.dart';
import 'package:todo/ui/widgets.dart';

class TodoEditPage extends ConsumerWidget {
  const TodoEditPage(this.id, {super.key});

  final TodoIdEntity id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editor = ref.watch(oneTodoProvider(id));

    return PopScope(
      canPop: !editor.hasUnsavedChanges,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        if (editor.hasUnsavedChanges) {
          final result = await showModalBottomSheet<bool?>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Save changes?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Save'),
                    ),
                  ],
                ),
          );
          if (context.mounted) {
            switch (result) {
              case true:
                await ref.read(oneTodoProvider(id).notifier).save();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              case false:
                Navigator.of(context).pop();
              case null:
                return;
            }
          }
          return;
        }
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Edit Todo ${id.id}'),
        ),
        body: editor.when(
          loading: LoadingIndicator.new,
          error: (error, __) => MyErrorWidget(error),
          data: (_) => _EditorWidget(id),
        ),
        floatingActionButton: TextButton(
          onPressed:
              editor.hasUnsavedChanges
                  ? ref.read(oneTodoProvider(id).notifier).save
                  : null,
          child: const Text('Save changes'),
        ),
      ),
    );
  }
}

class _EditorWidget extends ConsumerStatefulWidget {
  const _EditorWidget(this.id);

  final TodoIdEntity id;

  @override
  _EditorWidgetState createState() => _EditorWidgetState();
}

class _EditorWidgetState extends ConsumerState<_EditorWidget> {
  final titleText = TextEditingController();
  final descriptionText = TextEditingController();

  @override
  void dispose() {
    titleText.dispose();
    descriptionText.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final editing = ref.read(oneTodoProvider(widget.id));
    titleText.text = editing.value?.saved.title ?? '';
    descriptionText.text = editing.value?.saved.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                controller: titleText,
                decoration: const InputDecoration(labelText: 'title'),
                onChanged:
                    ref
                        .read(oneTodoProvider(widget.id).notifier)
                        .onTitleChanged,
              ),
              TextField(
                controller: descriptionText,
                decoration: const InputDecoration(labelText: 'description'),
                maxLines: 10,
                onChanged:
                    ref
                        .read(oneTodoProvider(widget.id).notifier)
                        .onDescriptionChanged,
              ),
              _ImagesListWidget(widget.id),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagesListWidget extends ConsumerWidget {
  const _ImagesListWidget(this.id);

  final TodoIdEntity id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editor = ref.watch(oneTodoProvider(id));

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height / 2,
      ),
      child: CarouselView.weighted(
        itemSnapping: true,
        flexWeights: const <int>[1, 2, 1],
        onTap: (index) async {
          if (index >= (editor.value?.editing.images.length ?? 0)) {
            final file = await ref.read(filePicker).pickFile();
            if (!context.mounted) return;
            switch (file) {
              case FilePickerCancel():

                /// do nothing
                break;
              case FilePickerSuccess(image: final image):
                unawaited(
                  ref.read(oneTodoProvider(id).notifier).addImage(image),
                );
                return;
              case FilePickerFailure(error: final e):
                debugPrint('Error picking file: $e');
            }
          }
        },
        children: [
          ...?editor.value?.editing.images.toWidgetList,
          const _AddImageWidget(),
        ],
      ),
    );
  }
}

extension on List<TodoImageEntity> {
  List<Widget> get toWidgetList => map(_ImageWidget.new).toList();
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget(this.imageEntity);

  final TodoImageEntity imageEntity;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return ClipRect(
      child: OverflowBox(
        maxWidth: width * 7 / 8,
        minWidth: width * 7 / 8,
        child: Image(
          fit: BoxFit.cover,
          image: switch (imageEntity) {
            TodoLocalImageEntity(localPath: final path) => FileImage(
              File(path),
            ),
          },
        ),
      ),
    );
  }
}

class _AddImageWidget extends StatelessWidget {
  const _AddImageWidget();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return ClipRect(
      child: OverflowBox(
        maxWidth: width * 7 / 8,
        minWidth: width * 7 / 8,
        child: const Center(child: Text('Add image')),
      ),
    );
  }
}
