import 'package:flutter/material.dart';

class OpinionFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String id = '';
  String headline = '';
  String description = '';
  String plagueId = '';
  String plagueName = '';
  String numLikes = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
