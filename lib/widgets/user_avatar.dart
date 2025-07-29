import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final double radius;

  const UserAvatar({super.key, required this.user, this.radius = 50});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue[100],
      backgroundImage: _getImageProvider(),
      child: user.avatarUrl == null
          ? Icon(Icons.person, size: radius * 1.2, color: Colors.blue[700])
          : null,
    );
  }

  ImageProvider? _getImageProvider() {
    if (user.avatarUrl == null) return null;

    // Check if it's a local file path
    if (user.avatarUrl!.startsWith('/') || user.avatarUrl!.contains('\\')) {
      return FileImage(File(user.avatarUrl!));
    }

    // Otherwise treat as network URL
    return NetworkImage(user.avatarUrl!);
  }
}
