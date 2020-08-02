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
      final isSignedIn = await wizard.userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await wizard.userRepository.getUser();
        yield await Future.delayed(Duration(seconds: 5), () {
          return Authenticated(user);
        });
      } else {
        yield await Future.delayed(Duration(seconds: 5), () {
          return Unauthenticated();
        });
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await wizard.userRepository.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    wizard.userRepository.signOut();
  }
}
