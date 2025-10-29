import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../screens/user_form_screen.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  const UserTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<UserProvider>(context, listen: false);

    return ListTile(
      leading: user.image != null && user.image!.isNotEmpty
          ? CircleAvatar(
        backgroundImage: NetworkImage(user.image!),
        radius: 24,
      )
          : CircleAvatar(
        radius: 24,
        backgroundColor: Colors.blueAccent,
        child: Text(
          user.username.isNotEmpty
              ? user.username[0].toUpperCase()
              : '?',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      title: Text(
        user.username,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(user.email),
      trailing: PopupMenuButton<String>(
        onSelected: (value) async {
          if (value == 'edit') {
            // Chuyển đến màn hình form edit user
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UserFormScreen(initial: user),
              ),
            );
          } else if (value == 'delete') {
            // Hộp thoại xác nhận xóa
            final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Delete user'),
                content: Text('Are you sure you want to delete ${user.username}?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );

            // Xóa user nếu xác nhận
            if (confirm == true) {
              await prov.deleteUser(user.username);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.username} deleted')),
              );
            }
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }
}
