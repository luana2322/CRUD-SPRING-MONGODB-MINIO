// lib/models/image_pick_result.dart
import 'dart:io';
import 'dart:typed_data';

class ImagePickResult {
  final File? file;           // mobile: File
  final Uint8List? bytes;     // web: bytes
  final String? name;         // file name (useful for upload)

  ImagePickResult({this.file, this.bytes, this.name});
}
