class Review {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String salonId;
  final String bookingId;
  final double rating;
  final String comment;
  final List<String> images;
  final DateTime createdAt;
  final int helpfulCount;
  final bool isVerifiedBooking;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.salonId,
    required this.bookingId,
    required this.rating,
    required this.comment,
    required this.images,
    required this.createdAt,
    required this.helpfulCount,
    required this.isVerifiedBooking,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userAvatar: json['user_avatar'] ?? '',
      salonId: json['salon_id'] ?? '',
      bookingId: json['booking_id'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      helpfulCount: json['helpful_count'] ?? 0,
      isVerifiedBooking: json['is_verified_booking'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'salon_id': salonId,
      'booking_id': bookingId,
      'rating': rating,
      'comment': comment,
      'images': images,
      'created_at': createdAt.toIso8601String(),
      'helpful_count': helpfulCount,
      'is_verified_booking': isVerifiedBooking,
    };
  }
}
