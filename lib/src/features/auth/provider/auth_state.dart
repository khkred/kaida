import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateAuthenticating extends AuthState {
  const AuthStateAuthenticating();
}

class AuthStateAuthenticated extends AuthState {
  final String userId;

  const AuthStateAuthenticated(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AuthStateUnAuthenticated extends AuthState {
  const AuthStateUnAuthenticated();
}
