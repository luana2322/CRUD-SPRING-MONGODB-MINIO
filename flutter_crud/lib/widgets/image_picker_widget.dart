// lib/widgets/image_picker_widget.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/image_pick_result.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(ImagePickResult?) onImagePicked;
  final String? existingImageUrl;

  const ImagePickerWidget({
    super.key,
    required this.onImagePicked,
    this.existingImageUrl,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _pickedFile;
  Uint8List? _pickedBytes;
  String? _pickedName;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (picked == null) return;

    if (kIsWeb) {
      // web: read bytes
      final bytes = await picked.readAsBytes();
      setState(() {
        _pickedBytes = bytes;
        _pickedFile = null;
        _pickedName = picked.name;
      });
      widget.onImagePicked(ImagePickResult(file: null, bytes: bytes, name: picked.name));
    } else {
      // mobile: use File
      final file = File(picked.path);
      setState(() {
        _pickedFile = file;
        _pickedBytes = null;
        _pickedName = picked.name;
      });
      widget.onImagePicked(ImagePickResult(file: file, bytes: null, name: picked.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget preview;
    if (_pickedBytes != null) {
      preview = Image.memory(_pickedBytes!, fit: BoxFit.cover);
    } else if (_pickedFile != null) {
      preview = Image.file(_pickedFile!, fit: BoxFit.cover);
    } else if (widget.existingImageUrl != null && widget.existingImageUrl!.isNotEmpty) {
      preview = Image.network(widget.existingImageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 60));
    } else {
      preview = const Icon(Icons.person, size: 60, color: Colors.grey);
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(width: 120, height: 120, child: preview),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text('Choose'),
            ),
            const SizedBox(width: 8),
            if (_pickedBytes != null || _pickedFile != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    _pickedFile = null;
                    _pickedBytes = null;
                    _pickedName = null;
                  });
                  widget.onImagePicked(null);
                },
                child: const Text('Remove'),
              ),
          ],
        ),
      ],
    );
  }
}
