import '../../domain/user.dart';

/// Data Transfer Object for User
/// Handles JSON serialization/deserialization
class UserDto {
  final String userId;
  final String username;

  UserDto({
    required this.userId,
    required this.username,
  });

  /// Convert JSON from API to DTO
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      userId: json['id'] as String,
      username: json['username'] as String,
    );
  }

  /// Convert DTO to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
    };
  }

  /// Convert DTO to domain model
  User toDomain() {
    return User(
      userId: userId,
      username: username,
    );
  }

  /// Create DTO from domain model
  factory UserDto.fromDomain(User user) {
    return UserDto(
      userId: user.userId,
      username: user.username,
    );
  }
}
