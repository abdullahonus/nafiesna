import 'package:equatable/equatable.dart';
import 'model/user_role.dart';

class AuthState extends Equatable {
  const AuthState({
    this.role = UserRole.unauthenticated,
    this.isLoading = false,
    this.errorMessage,
    this.userId,
  });

  final UserRole role;
  final bool isLoading;
  final String? errorMessage;
  final String? userId;

  AuthState copyWith({
    UserRole? role,
    bool? isLoading,
    String? errorMessage,
    String? userId,
  }) {
    return AuthState(
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [role, isLoading, errorMessage, userId];
}
