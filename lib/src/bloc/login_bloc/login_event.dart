import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent();

  @override
  List<Object> get props => [];
}

// LoginWithGooglePressed - login con google
class LoginWithGooglePressed extends LoginEvent {}
