/// Represents a payout configuration for a league
class Payout {
  final String id;
  final PayoutType type;
  final int place;
  final double amount;

  const Payout({
    required this.id,
    required this.type,
    required this.place,
    required this.amount,
  });

  factory Payout.fromJson(Map<String, dynamic> json) {
    return Payout(
      id: json['id'] as String,
      type: PayoutType.fromString(json['type'] as String),
      place: json['place'] as int,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'place': place,
      'amount': amount,
    };
  }

  Payout copyWith({
    String? id,
    PayoutType? type,
    int? place,
    double? amount,
  }) {
    return Payout(
      id: id ?? this.id,
      type: type ?? this.type,
      place: place ?? this.place,
      amount: amount ?? this.amount,
    );
  }

  String get displayType => type.displayName;

  String get displayPlace => _getOrdinal(place);

  String get displayAmount => '\$${amount.toStringAsFixed(2)}';

  static String _getOrdinal(int place) {
    if (place == 1) return '1st';
    if (place == 2) return '2nd';
    if (place == 3) return '3rd';
    return '${place}th';
  }
}

/// Types of payouts available
enum PayoutType {
  playoffFinish('playoff_finish', 'Playoff Finish'),
  regSeasonPoints('reg_season_points', 'Reg Season Points');

  final String value;
  final String displayName;

  const PayoutType(this.value, this.displayName);

  static PayoutType fromString(String value) {
    return PayoutType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => PayoutType.playoffFinish,
    );
  }
}
