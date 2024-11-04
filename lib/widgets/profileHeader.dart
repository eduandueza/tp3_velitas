import 'package:flutter/material.dart';

// TODO 

class ProfileHeader extends StatelessWidget {
  final String username;
  final String email;

  const ProfileHeader({super.key, required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        const CircleAvatar(
          radius: 50, 
          backgroundImage: NetworkImage('https://i.ytimg.com/vi/4asGM9wABfU/hq720.jpg?sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AH-CYAC0AWKAgwIABABGGUgWShaMA8=&rs=AOn4CLBVDR-6TuXImREtI1LRd8l-1a3ufg'), 
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
