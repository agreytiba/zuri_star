class Salon {
  final String id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final List<String> services;
  final bool isMobileService;
  final bool isInSalon;
  final String genderSpecific; // 'male', 'female', 'unisex'
  final Map<String, double> servicePrices;
  final List<String> availableTimeSlots;
  final bool isVerified;
  final String phoneNumber;
  final String email;

  Salon({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.services,
    required this.isMobileService,
    required this.isInSalon,
    required this.genderSpecific,
    required this.servicePrices,
    required this.availableTimeSlots,
    required this.isVerified,
    required this.phoneNumber,
    required this.email,
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      services: List<String>.from(json['services'] ?? []),
      isMobileService: json['is_mobile_service'] ?? false,
      isInSalon: json['is_in_salon'] ?? true,
      genderSpecific: json['gender_specific'] ?? 'unisex',
      servicePrices: Map<String, double>.from(json['service_prices'] ?? {}),
      availableTimeSlots: List<String>.from(json['available_time_slots'] ?? []),
      isVerified: json['is_verified'] ?? false,
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'review_count': reviewCount,
      'images': images,
      'services': services,
      'is_mobile_service': isMobileService,
      'is_in_salon': isInSalon,
      'gender_specific': genderSpecific,
      'service_prices': servicePrices,
      'available_time_slots': availableTimeSlots,
      'is_verified': isVerified,
      'phone_number': phoneNumber,
      'email': email,
    };
  }
}
