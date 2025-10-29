// lib/providers/user_provider.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/image_pick_result.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  final ApiService api = ApiService();
  List<UserModel> users = [];

  bool loading = false;

  Future<void> loadUsers() async {
    loading = true;
    notifyListeners();
    try {
      users = await api.fetchUsers();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> createUser(UserModel user, ImagePickResult? image) async {
    loading = true; notifyListeners();
    try {
      final created = await api.createUser(user);
      if (image != null) {
        final url = await api.uploadUserImage(
          username: created.username,
          file: image.file,
          bytes: image.bytes,
          filename: image.name,
        );
        // update image field on backend (optional): your backend already updates image in service.
        // reload user to get updated image url
        final updated = await api.getUser(created.username);
        if (updated != null) users.insert(0, updated);
        else users.insert(0, created);
      } else {
        users.insert(0, created);
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(String username, UserModel user, ImagePickResult? image) async {
    loading = true; notifyListeners();
    try {
      final updated = await api.updateUser(username, user);
      if (image != null) {
        await api.uploadUserImage(
          username: updated.username,
          file: image.file,
          bytes: image.bytes,
          filename: image.name,
        );
      }
      await loadUsers();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String username) async {
    await api.deleteUser(username);
    users.removeWhere((u) => u.username == username);
    notifyListeners();
  }
}
