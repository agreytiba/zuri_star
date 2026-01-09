class LoyaltyReward {
  final String id;
  final String userId;
  final int points;
  final String tier; // 'bronze', 'silver', 'gold', 'platinum'
  final List<Discount> availableDiscounts;
  final List<RewardTransaction> transactions;
  final DateTime lastUpdated;

  LoyaltyReward({
    required this.id,
    required this.userId,
    required this.points,
    required this.tier,
    required this.availableDiscounts,
    required this.transactions,
    required this.lastUpdated,
  });

  factory LoyaltyReward.fromJson(Map<String, dynamic> json) {
    return LoyaltyReward(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      points: json['points'] ?? 0,
      tier: json['tier'] ?? 'bronze',
      availableDiscounts: (json['available_discounts'] as List?)
              ?.map((d) => Discount.fromJson(d))
              .toList() ??
          [],
      transactions: (json['transactions'] as List?)
              ?.map((t) => RewardTransaction.fromJson(t))
              .toList() ??
          [],
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'points': points,
      'tier': tier,
      'available_discounts': availableDiscounts.map((d) => d.toJson()).toList(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class Discount {
  final String id;
  final String title;
  final String description;
  final int pointsRequired;
  final double discountPercentage;
  final DateTime expiryDate;
  final bool isUsed;
  final String? applicableServices;

  Discount({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    required this.discountPercentage,
    required this.expiryDate,
    required this.isUsed,
    this.applicableServices,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pointsRequired: json['points_required'] ?? 0,
      discountPercentage: (json['discount_percentage'] ?? 0.0).toDouble(),
      expiryDate: DateTime.parse(json['expiry_date']),
      isUsed: json['is_used'] ?? false,
      applicableServices: json['applicable_services'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points_required': pointsRequired,
      'discount_percentage': discountPercentage,
      'expiry_date': expiryDate.toIso8601String(),
      'is_used': isUsed,
      'applicable_services': applicableServices,
    };
  }
}

class RewardTransaction {
  final String id;
  final int points;
  final String type; // 'earned', 'redeemed'
  final String description;
  final DateTime date;

  RewardTransaction({
    required this.id,
    required this.points,
    required this.type,
    required this.description,
    required this.date,
  });

  factory RewardTransaction.fromJson(Map<String, dynamic> json) {
    return RewardTransaction(
      id: json['id'] ?? '',
      points: json['points'] ?? 0,
      type: json['type'] ?? 'earned',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'type': type,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}
