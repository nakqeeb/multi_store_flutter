import 'package:flutter/material.dart';

class RepeatedListTile extends StatelessWidget {
  final String? title, subtitle;
  final IconData icon;
  final bool isSettings;
  final Function()? onPressed;
  const RepeatedListTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onPressed,
    this.isSettings = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title!),
        subtitle: isSettings ? null : Text(subtitle!),
        trailing: isSettings ? const Icon(Icons.keyboard_arrow_right) : null,
      ),
    );
  }
}
