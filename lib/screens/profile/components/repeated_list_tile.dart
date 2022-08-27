import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/locale_provider.dart';

class RepeatedListTile extends StatelessWidget {
  final String? title, subtitle;
  final IconData icon;
  final bool isClickable;
  final Function()? onPressed;
  const RepeatedListTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onPressed,
    this.isClickable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title!),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: isClickable
            ? Icon(isArabic
                ? Icons.keyboard_arrow_left
                : Icons.keyboard_arrow_right)
            : null,
      ),
    );
  }
}
