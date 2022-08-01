import 'package:flutter/material.dart';

import '../../../components/default_button.dart';
import '../../../services/utils.dart';

class AuthMainButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  const AuthMainButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: DefaultButton(
        onPressed: onPressed,
        height: size.height * 0.06,
        width: size.width * 0.8,
        radius: 25,
        color: Theme.of(context).colorScheme.secondary,
        widget: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
