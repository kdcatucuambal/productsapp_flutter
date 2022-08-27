import 'package:flutter/material.dart';
import 'package:products_app/ui/input_decorations.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/login_form_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
      child: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 250),
          CardContainer(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('Login', style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 10),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: const _LoginForm(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, "register"),
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                shape: MaterialStateProperty.all(const StadiumBorder())),
            child: const Text('Create a new account',
                style: TextStyle(fontSize: 18, color: Colors.black87)),
          ),
          const SizedBox(height: 40),
        ],
      )),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Container(
      color: Colors.white,
      child: Form(
          key: loginFormProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'example@gmail.com',
                    labelText: 'Email',
                    prefixIcon: Icons.email),
                onChanged: (value) => loginFormProvider.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);
                  return regExp.hasMatch(value ?? '') ? null : 'Invalid email';
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '********',
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                ),
                onChanged: (value) => loginFormProvider.password = value,
                validator: (value) {
                  if (value != null && value.length >= 6) return null;
                  return 'Password must be at least 6 characters';
                },
              ),
              const SizedBox(height: 30),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                  disabledColor: const Color.fromARGB(255, 176, 146, 226),
                  onPressed: loginFormProvider.isLoading
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();

                          if (!loginFormProvider.isValidForm()) return;

                          loginFormProvider.isLoading = true;

                          Future.delayed(const Duration(seconds: 2))
                              .then((_) => {
                                    loginFormProvider.isLoading = false,
                                    Navigator.of(context)
                                        .pushReplacementNamed('home'),
                                  });
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    child: Text(
                      loginFormProvider.isLoading ? 'Loading...' : 'Next',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          )),
    );
  }
}
