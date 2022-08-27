import 'package:flutter/widgets.dart';

class LoginFormProvider extends ChangeNotifier {
  //This is the state of the form.
  GlobalKey<FormState> formKey = GlobalKey();
  String email = '';
  String password = '';
  bool _isLoading = false;

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
