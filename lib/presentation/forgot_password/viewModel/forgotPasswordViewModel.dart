import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flu_proj/app/functions.dart';
import 'package:flu_proj/presentation/base/base_view_model.dart';
import 'package:flu_proj/presentation/common/state_renderer/state_renderer.dart';
import 'package:flu_proj/presentation/common/state_renderer/state_renderer_imp.dart';
import 'package:flu_proj/presentation/resourses/strings_manager.dart';


class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {


  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();

  var email = "";

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    super.dispose();

    _emailStreamController.close();
    _isAllInputValidStreamController.close();
  }

  @override
  forgotPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((_) => {inputState.add(SuccessState(AppStrings.resetPasswordMessage))});
    } catch (error) {
      inputState
          .add(ErrorState(StateRendererType.popupErrorState, error.toString()));
    }

  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Sink get isAllInputsValid => _isAllInputValidStreamController.sink;

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputValidStreamController.stream
          .map((email) => _isAllInputValid());

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  _validate() {
    isAllInputsValid.add(null);
  }

  _isAllInputValid() {
    return isEmailValid(email);
  }
}

abstract class ForgotPasswordViewModelInputs {
  Sink get inputEmail;

  Sink get isAllInputsValid;

  setEmail(String email);

  forgotPassword();
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outputIsEmailValid;

  Stream<bool> get outputIsAllInputsValid;
}
