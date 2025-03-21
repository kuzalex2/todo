import 'dart:io';

import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/domain/entity.dart';
import 'package:todo/domain/i_file_picker.dart';
import 'package:uuid/uuid.dart';

class ExternalFilePicker implements IFilePicker {
  @override
  Future<FilePickerResult> pickFile() async {
    try {
      final result = await file_picker.FilePicker.platform.pickFiles(
        type: file_picker.FileType.image,
      );
      if (result == null) return const FilePickerCancel();

      final toCopy = File.fromUri(Uri.parse(result.files.first.identifier!));
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${const Uuid().v4()}';
      await toCopy.copy(path);

      return FilePickerSuccess(TodoLocalImageEntity(path));
    } catch (e) {
      debugPrint('Error: $e');
      return FilePickerFailure(e.toString());
    }
  }
}
