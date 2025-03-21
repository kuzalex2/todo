import 'package:todo/domain/entity.dart';

sealed class FilePickerResult {
  const FilePickerResult();
}

class FilePickerSuccess extends FilePickerResult {
  const FilePickerSuccess(this.image);
  final TodoLocalImageEntity image;
}

class FilePickerCancel extends FilePickerResult {
  const FilePickerCancel();
}

class FilePickerFailure extends FilePickerResult {
  const FilePickerFailure(this.error);
  final String error;
}

abstract class IFilePicker {
  Future<FilePickerResult> pickFile();
}
