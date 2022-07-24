import 'package:flutter/material.dart';

class HaveAccount extends StatelessWidget {
  final String titleLabel;
  final String btnLabel;
  final Function() onPressed;
  const HaveAccount({
    Key? key,
    required this.titleLabel,
    required this.btnLabel,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$titleLabel ',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            btnLabel,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
