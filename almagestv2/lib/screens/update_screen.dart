// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:almagestv2/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:almagestv2/services/services.dart';
import 'package:almagestv2/providers/providers.dart';
import 'package:almagestv2/widgets/widgets.dart';
import 'package:almagestv2/ui/input_decorations.dart';

class UpdateScreen extends StatelessWidget {
  static String userId = '';

  const UpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AuthBackground(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                  child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text('Update',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => UpdateFormProvider(), child: _UpdateForm())
                ],
              )),
              const SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'admin'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.8)),
                      overlayColor: MaterialStateProperty.all(
                          Colors.grey.withOpacity(0.3)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Text(
                    'Leave without update',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  )),
              const SizedBox(height: 50),
            ],
          ),
        )));
  }
}

// ignore: must_be_immutable
class _UpdateForm extends StatelessWidget with InputValidationMixin {
  @override
  Widget build(BuildContext context) {
    final updateForm = Provider.of<UpdateFormProvider>(context);
    updateForm.id = UpdateScreen.userId;
    return Form(
      key: updateForm.formKey,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
                hintText: '', labelText: 'Name', prefixIcon: Icons.person),
            onChanged: (value) => updateForm.firstname = value,
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
            onChanged: (value) => updateForm.secondname = value,
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
            onChanged: (value) => updateForm.email = value,
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
            onChanged: (value) => updateForm.password = value,
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
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
                hintText: '',
                labelText: 'CompanyId',
                prefixIcon: Icons.business_outlined),
            onChanged: (value) => updateForm.companyId = value,
            validator: (companyId) {
              if (isTextValid(companyId)) {
                return null;
              } else {
                return 'CompanyId field cant be null';
              }
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: updateForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final userService =
                          Provider.of<UserService>(context, listen: false);

                      if (!updateForm.isValidForm()) return;
                      updateForm.isLoading = true;
                      final String? errorMessage = await userService.postUpdate(
                          updateForm.id,
                          updateForm.firstname,
                          updateForm.secondname,
                          updateForm.email,
                          updateForm.password,
                          updateForm.companyId);
                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'admin');
                      } else {
                        updateForm.isLoading = false;
                        print(errorMessage);
                      }
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    updateForm.isLoading ? 'Wait' : 'Confirm changes',
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
