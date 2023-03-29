// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:almagestv2/services/services.dart';
import 'package:almagestv2/providers/providers.dart';
import 'package:almagestv2/widgets/widgets.dart';
import 'package:almagestv2/ui/input_decorations.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
              Text('Register',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 30),
              ChangeNotifierProvider(
                  create: (_) => RegisterFormProvider(), child: _RegisterForm())
            ],
          )),
          const SizedBox(height: 50),
          TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.white.withOpacity(0.8)),
                  overlayColor:
                      MaterialStateProperty.all(Colors.grey.withOpacity(0.3)),
                  shape: MaterialStateProperty.all(const StadiumBorder())),
              child: const Text(
                'Are you already registered?',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              )),
          const SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _RegisterForm extends StatelessWidget with InputValidationMixin {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Form(
      key: registerForm.formKey,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        // ignore: sort_child_properties_last
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
                hintText: '', labelText: 'Name', prefixIcon: Icons.person),
            onChanged: (value) => registerForm.firstname = value,
            validator: (name) {
              if (isTextValid(name)) {
                return null;
              } else {
                return 'First name field cant be null';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
                hintText: '', labelText: 'Surname', prefixIcon: Icons.person),
            onChanged: (value) => registerForm.secondname = value,
            validator: (surname) {
              if (isTextValid(surname)) {
                return null;
              } else {
                return 'Surname field cant be null';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hintText: 'example@example.com',
                labelText: 'Email',
                prefixIcon: Icons.alternate_email_rounded),
            onChanged: (value) => registerForm.email = value,
            validator: (email) {
              if (isEmailValid(email)) {
                return null;
              } else {
                return 'Enter a valid email address';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
                hintText: '*******',
                labelText: 'Password',
                prefixIcon: Icons.lock_outline),
            onChanged: (value) => registerForm.password = value,
            validator: (password) {
              if (isPasswordValid(password)) {
                return null;
              } else {
                return 'Enter a valid password';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
                hintText: '*******',
                labelText: 'Password',
                prefixIcon: Icons.lock_outline),
            onChanged: (value) => registerForm.cpassword = value,
            validator: (value) {
              if (value != registerForm.password) {
                return "The passwords don't match";
              } else if (value == '') {
                return "The password cant be null";
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: registerForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final userServiec =
                          Provider.of<UserService>(context, listen: false);

                      if (!registerForm.isValidForm()) return;

                      registerForm.isLoading = true;

                      //validar si el login es correcto
                      final String? errorMessage = await userServiec.register(
                        registerForm.firstname,
                        registerForm.secondname,
                        registerForm.email,
                        registerForm.password,
                        registerForm.cpassword,
                      );
                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'login');
                      } else {
                        //mostrar error en pantalla
                        // customToast('The email is already registered', context);
                        registerForm.isLoading = false;
                        print(errorMessage);
                      }
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    registerForm.isLoading ? 'Wait' : 'Register',
                    style: const TextStyle(color: Colors.white),
                  )))
        ],
      ),
    );
  }

  void customToast(String s, BuildContext context) {
    showToast(
      s,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}

mixin InputValidationMixin {
  bool isTextValid(texto) => texto.length > 0;

  bool isPasswordValid(password) => password.length >= 6;

  bool isEmailValid(email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }
}
