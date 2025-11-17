/// Domain model for a league member
class LeagueMember {
  final int rosterId;
  final String userId;
  final String username;
  final bool paid;

  const LeagueMember({
    required this.rosterId,
    required this.userId,
    required this.username,
    required this.paid,
  });

  LeagueMember copyWith({
    int? rosterId,
    String? userId,
    String? username,
    bool? paid,
  }) {
    return LeagueMember(
      rosterId: rosterId ?? this.rosterId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      paid: paid ?? this.paid,
    );
  }
}
