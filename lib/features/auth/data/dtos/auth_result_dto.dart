import '../../domain/auth_result.dart';
import 'user_dto.dart';

/// Data Transfer Object for authentication response
class AuthResultDto {
  final UserDto user;
  final String token;
  final String? refreshToken;

  AuthResultDto({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  /// Convert JSON from API to DTO
  factory AuthResultDto.fromJson(Map<String, dynamic> json) {
    return AuthResultDto(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  /// Convert DTO to domain model
  AuthResult toDomain() {
    return AuthResult(
      user: user.toDomain(),
      token: token,
      refreshToken: refreshToken ?? '',
    );
  }
}
