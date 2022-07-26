import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    return IconButton(
      icon: Icon(
        isArabic ? Icons.arrow_back_ios : Icons.arrow_back_ios_new,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      },
    );
  }
}
