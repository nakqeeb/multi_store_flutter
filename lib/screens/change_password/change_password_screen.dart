import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/providers/auth_customer_provider.dart';
import 'package:multi_store_app/services/utils.dart';
import 'package:provider/provider.dart';

import '../../components/default_button.dart';
import '../../services/global_methods.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  String? _oldPassword, _newPassword;

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();
    final appLocale = AppLocalizations.of(context);
    final authCustomerProvider =
        Provider.of<AuthCustomerProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      GlobalMethods.loadingDialog(
          title: appLocale!.please_wait, context: context);
      await authCustomerProvider.resetPassword(_oldPassword!, _newPassword!);
      if (authCustomerProvider.passwordsDoesNotMatched == true) {
        GlobalMethods.showSnackBar(
            context, _scaffoldKey, appLocale.old_password_is_not_correct);

        Navigator.pop(context);
        return;
      }
      Navigator.pop(context);
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      Fluttertoast.showToast(
        msg: appLocale.password_is_changed,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final appLocale = AppLocalizations.of(context);
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: AppBarTitle(title: appLocale!.change_password),
          leading: const AppBarBackButton(),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.focusedChild?.unfocus();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      //autofocus: true,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return appLocale.password_no_empty;
                        } else if (value.length < 6) {
                          return appLocale.password_six_char;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _oldPassword = value!;
                      },
                      decoration: textFormDecoration(context).copyWith(
                        labelText: appLocale.old_password,
                        hintText: appLocale.enter_old_password,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return appLocale.password_no_empty;
                        } else if (value.length < 6) {
                          return appLocale.password_six_char;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newPassword = value!;
                      },
                      decoration: textFormDecoration(context).copyWith(
                        labelText: appLocale.new_password,
                        hintText: appLocale.enter_new_password,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  DefaultButton(
                    onPressed: () {
                      _resetPassword();
                    },
                    height: size.height * 0.05,
                    width: size.width * 0.7,
                    radius: 15,
                    color: Theme.of(context).colorScheme.tertiary,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          appLocale.change_password,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }

  InputDecoration textFormDecoration(BuildContext context) {
    return InputDecoration(
      labelText: 'Full Name',
      hintText: 'Enter your full name',
      labelStyle:
          TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}
