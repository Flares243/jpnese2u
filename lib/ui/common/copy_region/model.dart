import 'dart:typed_data';

sealed class CopyContent {
  const CopyContent();
}

class CopyText extends CopyContent {
  const CopyText(this.text);

  final String text;
}

class CopyFile extends CopyContent {
  const CopyFile({required this.path, this.bytes});

  final String path;
  final Uint8List? bytes;
}
