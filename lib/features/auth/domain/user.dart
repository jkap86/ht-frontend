/// Pure domain model for authenticated user
/// Contains only business logic, no serialization concerns
class User {
  final String userId;
  final String username;

  const User({
    required this.userId,
    required this.username,
  });

  User copyWith({
    String? userId,
    String? username,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
    );
  }
}
