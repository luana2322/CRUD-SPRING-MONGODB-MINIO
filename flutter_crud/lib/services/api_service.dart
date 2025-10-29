// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class ApiService {
  static final String base = AppConfig.getBaseUrl();

  Future<List<UserModel>> fetchUsers() async {
    final res = await http.get(Uri.parse('$base/users'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users: ${res.statusCode}');
    }
  }

  Future<UserModel?> getUser(String username) async {
    final res = await http.get(Uri.parse('$base/users/$username'));
    if (res.statusCode == 200) {
      return UserModel.fromJson(json.decode(res.body));
    } else if (res.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error ${res.statusCode}');
    }
  }

  Future<UserModel> createUser(UserModel user) async {
    final res = await http.post(
      Uri.parse('$base/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return UserModel.fromJson(json.decode(res.body));
    } else {
      throw Exception('Create failed: ${res.statusCode} ${res.body}');
    }
  }

  /// 🧩 Cập nhật người dùng
  Future<UserModel> updateUser(String username, UserModel user) async {
    final bodyData = json.encode(user.toJson(includePassword: false));
    print('Updating user: $username');
    print('Body: $bodyData');

    final res = await http.put(
      Uri.parse('$base/users/$username'),
      headers: {'Content-Type': 'application/json'},
      body: bodyData,
    );

    print('Response code: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      return UserModel.fromJson(json.decode(res.body));
    } else {
      throw Exception('Update failed: ${res.statusCode} ${res.body}');
    }
  }

  Future<void> deleteUser(String username) async {
    final res = await http.delete(Uri.parse('$base/users/$username'));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Delete failed: ${res.statusCode}');
    }
  }

  /// Upload ảnh user (qua MinIO)
  Future<String> uploadUserImage({
    required String username,
    File? file,
    Uint8List? bytes,
    String? filename,
  }) async {
    final uri = Uri.parse('$base/users/$username/image');
    final request = http.MultipartRequest('POST', uri);

    if (file != null) {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final parts = mimeType.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType(parts[0], parts[1]),
        ),
      );
    } else if (bytes != null) {
      final name = filename ?? 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final mimeType = lookupMimeType(name) ?? 'application/octet-stream';
      final parts = mimeType.split('/');
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: name,
          contentType: MediaType(parts[0], parts[1]),
        ),
      );
    } else {
      throw Exception('No file or bytes provided');
    }

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode == 200) {
      try {
        final parsed = json.decode(resp.body);
        if (parsed is Map && parsed['url'] != null) {
          return parsed['url'];
        }
      } catch (_) {}
      return resp.body;
    } else {
      throw Exception('Upload failed: ${resp.statusCode} ${resp.body}');
    }
  }
}
