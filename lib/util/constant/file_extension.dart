import 'package:path/path.dart' as path;

enum FileExt {
  dic(value: '.dic'),
  ;

  const FileExt({required this.value});

  final String value;

  bool isMatch(String filePath) => path.extension(filePath) == value;
}
