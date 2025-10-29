// lib/screens/user_form_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/image_pick_result.dart';
import '../providers/user_provider.dart';
import '../widgets/image_picker_widget.dart';

class UserFormScreen extends StatefulWidget {
  final UserModel? initial; // giữ tên initial cho tương thích
  const UserFormScreen({super.key, this.initial});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _username;
  late TextEditingController _email;
  late TextEditingController _password;
  ImagePickResult? _pickedImageResult;

  @override
  void initState() {
    super.initState();
    _username = TextEditingController(text: widget.initial?.username ?? '');
    _email = TextEditingController(text: widget.initial?.email ?? '');
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = UserModel(
      username: _username.text.trim(),
      email: _email.text.trim(),
      password: _password.text.isEmpty ? null : _password.text,
      image: widget.initial?.image, // keep existing until backend returns new url
    );

    final prov = Provider.of<UserProvider>(context, listen: false);
    try {
      if (widget.initial == null) {
        await prov.createUser(user, _pickedImageResult);
      } else {
        await prov.updateUser(widget.initial!.username, user, _pickedImageResult);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit User' : 'Create User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _username,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              ImagePickerWidget(
                existingImageUrl: widget.initial?.image,
                onImagePicked: (result) => _pickedImageResult = result,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text(isEdit ? 'Save' : 'Create')),
            ],
          ),
        ),
      ),
    );
  }
}
