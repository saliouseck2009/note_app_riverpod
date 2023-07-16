import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable{

}

class AuthInitial extends AuthState{
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState{
  @override
  List<Object?> get props => [];
}

class AuthSuccess extends AuthState{
  final String token;
  AuthSuccess({required this.token});
  @override
  List<Object?> get props => [token];
}

class AuthFailure extends AuthState{
  final String message;
  AuthFailure({required this.message});
  @override
  List<Object?> get props => [message];
}