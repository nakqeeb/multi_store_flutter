import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyText1!.color,
        fontFamily: 'Acme',
        fontSize: 24,
        letterSpacing: 1.5,
      ),
    );
  }
}
