import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/screens/welcome/welcome_screen.dart';

class GlobalMethods {
  static void showSnackBar(
      BuildContext context, var scaffoldKey, String message) {
    scaffoldKey.currentState!.hideCurrentSnackBar();
    scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    String btnTitle = 'OK',
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(children: [
            Image.asset(
              'images/inapp/warning-sign.png',
              height: 20,
              width: 20,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(title),
          ]),
          content: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                fct();
              },
              child: Text(
                btnTitle,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> successSignupDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(children: [
            const Icon(
              Icons.done,
              size: 20,
              color: Colors.green,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.purple,
              ),
            ),
          ]),
          content: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.purple,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                fct();
              },
              child: const Text(
                'Login now',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget loadingScreen() {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.7),
        ),
        const Center(
          child: SpinKitFadingCircle(
            color: Colors.white,
          ),
        )
      ],
    );
  }
  /* static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
    bool isLoginBtn = false,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              Image.asset(
                'assets/images/warning-sign.png',
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text('An Error occured'),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  if (isLoginBtn == true) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => const WelcomeScreen(),
                    ));
                  }
                },
                child: Text(
                  isLoginBtn == true ? 'Login' : 'Ok',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
  } */
}
