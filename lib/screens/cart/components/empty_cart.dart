import 'package:flutter/material.dart';
import 'package:multi_store_app/fetch_screen.dart';
import 'package:multi_store_app/screens/welcome/welcome_screen.dart';

import '../../../bottom_bar/customer_bottom_bar.dart';
import '../../../services/utils.dart';

class EmptyCart extends StatelessWidget {
  final String textTitle, buttonTitle;
  final bool isGuest;
  const EmptyCart({
    Key? key,
    required this.textTitle,
    required this.buttonTitle,
    this.isGuest = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 50,
          ),
          MaterialButton(
            minWidth: size.width * 0.6,
            height: size.height * 0.06,
            onPressed: () {
              if (isGuest) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const WelcomeScreen()),
                  ),
                );
                return;
              }
              Navigator.canPop(context)
                  ? Navigator.pop(context)
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const CustomerBottomBar()),
                      ),
                    );
            },
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Text(
              buttonTitle,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
