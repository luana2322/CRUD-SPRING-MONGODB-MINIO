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
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUsers());
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    await Provider.of<UserProvider>(context, listen: false).loadUsers();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);

    // Lọc danh sách người dùng theo từ khóa tìm kiếm
    final filteredUsers = prov.users.where((user) {
      final query = _searchQuery.toLowerCase();
      return user.username.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
        title: const Text(
          'Danh sách người dùng',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Tải lại danh sách',
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          // Ô tìm kiếm
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên, email hoặc username...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Danh sách người dùng
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _loadUsers,
              child: filteredUsers.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline,
                        size: 80, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      _searchQuery.isEmpty
                          ? 'Chưa có người dùng nào'
                          : 'Không tìm thấy kết quả phù hợp',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredUsers.length,
                itemBuilder: (_, i) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // có thể mở chi tiết user
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UserTile(user: filteredUsers[i]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const UserFormScreen()),
          );
          await _loadUsers();
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm người dùng'),
      ),
    );
  }
}
