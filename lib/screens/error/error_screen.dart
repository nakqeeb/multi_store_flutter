import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../fetch_screen.dart';

const double defaultPadding = 16;

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key, required this.title, required this.subTitle})
      : super(key: key);
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              SvgPicture.asset("images/inapp/empty_wallet_2.svg"),
              const SizedBox(height: defaultPadding * 2),
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding * 2, vertical: defaultPadding),
                child: Text(
                  subTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: defaultPadding * 1),
              const Spacer(flex: 2),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (ctx) => const FetchScreen(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  minimumSize: const Size(120, 40),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  appLocale!.reload,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
