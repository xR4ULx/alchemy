import 'package:alchemy/src/bloc/login_bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:alchemy/src/services/wizard.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Wizard wizard;

  //Constructor
  LoginBloc({@required this.wizard});

  @override
  LoginState get initialState => LoginState.empty();


  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await wizard.userRepository.signInWithGoogle().then((_) async{
        await wizard.userRepository.setActive(true);
      });
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
