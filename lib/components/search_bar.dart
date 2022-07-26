import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_store_app/providers/dark_theme_provider.dart';
import 'package:multi_store_app/services/utils.dart';
import 'package:provider/provider.dart';

import '../screens/search/search_screen.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<DarkThemeProvider>(context).isDarkTheme;
    final size = Utils(context).getScreenSize;
    final appLocale = AppLocalizations.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        );
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        height: size.height * 0.043,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: isDarkTheme
                  ? const Color(0xFFdae3e3)
                  : const Color(0xFF758699),
              width: 1.4),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            Text(
              appLocale!.what_looking_for,
              style: TextStyle(
                  // fontSize: 18,
                  fontSize: size.width * 0.04,
                  color: Theme.of(context).textTheme.bodyText1!.color),
            ),
            SizedBox(
              width: size.width * 0.01,
            ),
            Container(
              height: double.infinity,
              width: size.width * 0.2,
              decoration: BoxDecoration(
                color: isDarkTheme
                    ? const Color(0xFFdae3e3)
                    : const Color(0xFF758699),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  appLocale.search,
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
