import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:provider/provider.dart';

import '../../providers/locale_provider.dart';

class ChangeLanguageScreen extends StatelessWidget {
  const ChangeLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.locale ?? const Locale('en');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AppBarTitle(title: appLocale!.change_language),
        leading: const AppBarBackButton(),
      ),
      body: Column(
        children: [
          RadioListTile(
            value: const Locale('ar'),
            groupValue: locale,
            onChanged: (Locale? value) {
              print(value);
              localeProvider.setLocal = 'ar';
            },
            title: const Text('عربي'),
          ),
          RadioListTile(
            value: const Locale('en'),
            groupValue: locale,
            onChanged: (Locale? value) {
              localeProvider.setLocal = 'en';
            },
            title: const Text('English'),
          ),
        ],
      ),
    );
  }
}
