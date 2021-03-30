import 'dart:async';

import 'package:alchemy/src/bloc/authentication_bloc/bloc.dart';
import 'package:alchemy/src/services/wizard.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Wizard wizard;

  AuthenticationBloc({@required this.wizard});

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
    if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    }
    if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final _authenticate = await wizard.userRepository.isSignedIn();
      final _displayName = await wizard.userRepository.getUser();

      if (_authenticate) {
        if (_displayName != "") {
          await wizard.userRepository.setActive(true);
          yield Authenticated(_displayName);
        } else {
          yield Unauthenticated();
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
      print("NO AUTENTICADO");
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await wizard.userRepository.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    await wizard.userRepository.signOut();
    yield Unauthenticated();
  }
}
