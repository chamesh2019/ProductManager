import 'package:flutter/material.dart';
import '../models/user.dart';
import 'user_avatar.dart';

class WelcomeHeader extends StatelessWidget {
  final User user;

  const WelcomeHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAvatar(user: user),
        const SizedBox(height: 16),
        Text(
          'Welcome back,',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.fullName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
