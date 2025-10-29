import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/user_tile.dart';
import 'user_form_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Dời việc gọi loadUsers ra sau frame đầu tiên để tránh lỗi build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsers();
    });
  }


  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    await Provider.of<UserProvider>(context, listen: false).loadUsers();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadUsers,
        child: prov.users.isEmpty
            ? const Center(child: Text('No users found'))
            : ListView.builder(
          itemCount: prov.users.length,
          itemBuilder: (_, i) => UserTile(user: prov.users[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const UserFormScreen()),
          );
          await _loadUsers();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
