import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flu_proj/presentation/base/base_view_model.dart';
import 'package:flu_proj/presentation/common/state_renderer/state_renderer.dart';
import 'package:flu_proj/presentation/common/state_renderer/state_renderer_imp.dart';
import 'package:rxdart/rxdart.dart';

class VerificationViewModel extends BaseViewModel
    with VerificationViewModelInputs, VerificationViewModelOutputs {
  final StreamController _isAllInputValidStreamController =
      BehaviorSubject<void>();
  final StreamController _emailStreamController = BehaviorSubject<String>();
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => verify());
  }

  @override
  void start() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    if (FirebaseAuth.instance.currentUser?.email != null) {
      print(FirebaseAuth.instance.currentUser?.email);
      inputEmail.add(FirebaseAuth.instance.currentUser?.email);
    } else {
      inputState.add(ErrorState(StateRendererType.fullScreenErrorState, "hh"));
    }

    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _timer!.cancel();
  _isAllInputValidStreamController.close();
  _emailStreamController.close();
    super.dispose();

  }

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputValidStreamController.stream.map((state) => state);

  @override
  sendVerification() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    startTimer();
    await FirebaseAuth.instance.currentUser
        ?.sendEmailVerification()
        .then((_) => inputState.add(SuccessState("")))
        .catchError((failure) {
      inputState.add(
          ErrorState(StateRendererType.popupErrorState, failure.toString()));
    });
  }

  @override
  verify() async {
    //  inputState.add(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    FirebaseAuth.instance.currentUser!.reload().then((value) => {
          if (FirebaseAuth.instance.currentUser!.emailVerified)
            {
              isAllInputsValid.add(true),
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set({"isVerefide": true}, SetOptions(merge: true))
            }

        });
  }

  @override
  Sink get isAllInputsValid => _isAllInputValidStreamController.sink;

  @override
  // TODO: implement inputEmail
  Sink get inputEmail => _emailStreamController.sink;

  @override
  // TODO: implement outputEmail
  Stream<String> get outputEmail =>
      _emailStreamController.stream.map((event) => event);
}

abstract class VerificationViewModelInputs {
  Sink get isAllInputsValid;

  Sink get inputEmail;

  sendVerification();

  verify();
}

abstract class VerificationViewModelOutputs {
  Stream<bool> get outputIsAllInputsValid;

  Stream<String> get outputEmail;
}
