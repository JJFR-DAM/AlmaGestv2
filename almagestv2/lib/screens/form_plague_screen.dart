// ignore_for_file: use_build_context_synchronously

import 'package:almagestv2/Models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import 'package:almagestv2/screens/screens.dart';
import 'package:almagestv2/services/services.dart';
import 'package:almagestv2/ui/input_decorations.dart';
import 'package:almagestv2/providers/providers.dart';
import 'package:almagestv2/widgets/widgets.dart';

class FormOpinionScreen extends StatelessWidget {
  const FormOpinionScreen({Key? key}) : super(key: key);

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
                  Text('Create Plague',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => PlagueFormProvider(), child: _plagueForm())
                ],
              )),
              const SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'plagues'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.8)),
                      overlayColor: MaterialStateProperty.all(
                          Colors.grey.withOpacity(0.3)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Text(
                    'Leave without create',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  )),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _plagueForm extends StatelessWidget with InputValidationMixin {
  @override
  Widget build(BuildContext context) {
    final plagueForm = Provider.of<PlagueFormProvider>(context);
    OpinionsPlaguesService opService = OpinionsPlaguesService();
    opService.getPlagues();
    opService.getOpinions();
    List<PlagueData> plaguesList = OpinionScreen.plagues;
    return Form(
      key: plagueForm.formKey,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            maxLength: 24,
            decoration: InputDecorations.authInputDecoration(
              hintText: '',
              labelText: 'Name',
              prefixIcon: Icons.title_rounded,
            ),
            onChanged: (value) => plagueForm.headline = value,
            validator: (text) {
              if (isTextValid(text)) {
                return null;
              } else {
                return 'Name field cant be null.';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            maxLength: 210,
            decoration: InputDecorations.authInputDecoration(
              hintText: '',
              labelText: 'Image',
              prefixIcon: Icons.line_style_rounded,
            ),
            onChanged: (value) => plagueForm.description = value,
            validator: (text) {
              if (isTextValid(text)) {
                return null;
              } else {
                return 'Image field cant be null.';
              }
            },
          ),
          DropdownButtonFormField(
            hint: const Text('Select a Product'),
            iconSize: 20,
            iconEnabledColor: Colors.deepPurpleAccent,
            iconDisabledColor: Colors.deepPurpleAccent,
            focusColor: Colors.deepPurpleAccent,
            onChanged: (value) {
              plagueForm.plagueId = value!.id.toString();
              plagueForm.plagueName = value.name.toString();
            },
            items: plaguesList.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e.name.toString()),
              );
            }).toList(),
            validator: (value) {
              return (value!.name != null) ? null : 'Select a Plague';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: plagueForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final opService = OpinionsPlaguesService();

                      if (!plagueForm.isValidForm()) return;
                      plagueForm.isLoading = true;
                      final String? errorMessage = await opService.postOpinion(
                        plagueForm.id,
                        plagueForm.name,
                        plagueForm.img,
                      );
                      if (errorMessage == 'Plague created successfully.') {
                        customToast('Created succesfully', context);
                        Navigator.pushReplacementNamed(context, 'opinions');
                      } else {
                        plagueForm.isLoading = false;
                        // ignore: avoid_print
                        print(errorMessage);
                      }
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    plagueForm.isLoading ? 'Wait' : 'Create',
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
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 2),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      backgroundColor: Colors.greenAccent,
    );
  }
}
