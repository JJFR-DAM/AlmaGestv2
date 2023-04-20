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
                  Text('Create Opinion',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => OpinionFormProvider(),
                      child: _OpinionForm())
                ],
              )),
              const SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'opinions'),
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
class _OpinionForm extends StatelessWidget with InputValidationMixin {
  @override
  Widget build(BuildContext context) {
    final opinionForm = Provider.of<OpinionFormProvider>(context);
    OpinionsPlaguesService opService = OpinionsPlaguesService();
    opService.getPlagues();
    opService.getOpinions();
    List<PlagueData> plaguesList = opService.plagues.cast<PlagueData>();
    List<OpinionData> opinionsList = opService.opinions.cast<OpinionData>();
    List<String> plaguesIds = [];
    for (var i in plaguesList) {
      plaguesIds.add(i.name.toString());
    }
    return Form(
      key: opinionForm.formKey,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            maxLength: 4,
            decoration: InputDecorations.authInputDecoration(
              hintText: '',
              labelText: 'OpinionId',
              prefixIcon: Icons.key_outlined,
            ),
            onChanged: (value) => opinionForm.id = value,
            validator: (number) {
              bool isRepeated = false;
              if (isTextValid(number)) {
                for (var i = 0; i < opinionsList.length; i++) {
                  if (number.toString() == opinionsList[i].id.toString()) {
                    isRepeated = true;
                  }
                }
                if (isRepeated == true) {
                  return 'This opinionId already exist';
                } else {
                  return null;
                }
              } else {
                return 'OpinionId field cant be null or contains characters.';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            maxLength: 24,
            decoration: InputDecorations.authInputDecoration(
              hintText: '',
              labelText: 'Headline',
              prefixIcon: Icons.title_rounded,
            ),
            onChanged: (value) => opinionForm.headline = value,
            validator: (text) {
              if (isTextValid(text)) {
                return null;
              } else {
                return 'Headline field cant be null.';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            decoration: InputDecorations.authInputDecoration(
              hintText: '',
              labelText: 'Description',
              prefixIcon: Icons.line_style_rounded,
            ),
            onChanged: (value) => opinionForm.description = value,
            validator: (text) {
              if (isTextValid(text)) {
                return null;
              } else {
                return 'Description field cant be null.';
              }
            },
          ),
          DropdownButtonFormField(
            hint: const Text('Select a Plague'),
            iconSize: 20,
            value: 'plaguesList[1].toString()',
            onChanged: (value) {
              opinionForm.plagueName = value!;
            },
            items: plaguesIds.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e),
              );
            }).toList(),
            validator: (value) {
              return (value != null && value != '0') ? null : 'Select a Plague';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: opinionForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final opService = OpinionsPlaguesService();

                      if (!opinionForm.isValidForm()) return;
                      opinionForm.isLoading = true;
                      final String? errorMessage = await opService.postOpinion(
                        opinionForm.id,
                        opinionForm.headline,
                        opinionForm.description,
                        opinionForm.plagueId,
                        opinionForm.plagueName,
                        '0',
                      );
                      if (errorMessage == 'Opinion created successfully.') {
                        showToast('Created succesfully');
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, 'opinions');
                      } else {
                        opinionForm.isLoading = false;
                        // ignore: avoid_print
                        print(errorMessage);
                      }
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    opinionForm.isLoading ? 'Wait' : 'Create',
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
