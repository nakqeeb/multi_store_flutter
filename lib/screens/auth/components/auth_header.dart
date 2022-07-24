import 'package:flutter/material.dart';

import '../../welcome/welcome_screen.dart';

class AuthHeader extends StatelessWidget {
  final String label;
  const AuthHeader({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (ctx) => WelcomeScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.home_work,
              color: Theme.of(context).colorScheme.secondary,
              size: 40,
            ),
          )
        ],
      ),
    );
  }
}
