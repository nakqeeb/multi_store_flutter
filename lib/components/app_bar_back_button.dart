import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      },
    );
  }
}
