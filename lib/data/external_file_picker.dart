import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/domain/entity.dart';
import 'package:todo/domain/i_file_picker.dart';
import 'package:uuid/uuid.dart';

class ExternalFilePicker implements IFilePicker {
  @override
  Future<FilePickerResult> pickFile() async {
    try {
      final result = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 80,
      );

      if (result == null) return const FilePickerCancel();

      final copier = File(result.path);
      final destinationPath =
          '${(await getApplicationDocumentsDirectory()).path}/${const Uuid().v4()}';
      await copier.copy(destinationPath);

      return FilePickerSuccess(TodoLocalImageEntity(destinationPath));
    } catch (e) {
      debugPrint('Error: $e');
      return FilePickerFailure(e.toString());
    }
  }
}
