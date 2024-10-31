import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String email;

  const ProfileHeader({Key? key, required this.username, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        CircleAvatar(
          radius: 50, 
          backgroundImage: NetworkImage('https://example.com/path/to/profile/image.jpg'), 
        ),
        const SizedBox(height: 8), 
        Text(
          username,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4), 
        Text(
          email,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey, 
          ),
        ),
      ],
    );
  }
}
