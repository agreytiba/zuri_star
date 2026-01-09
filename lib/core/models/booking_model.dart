class Booking {
  final String id;
  final String userId;
  final String salonId;
  final String salonName;
  final String serviceType;
  final String serviceDescription;
  final DateTime bookingDate;
  final String timeSlot;
  final double price;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled', 'rescheduled'
  final bool isInstantBooking;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? calendarEventId;
  final bool reminderSet;

  Booking({
    required this.id,
    required this.userId,
    required this.salonId,
    required this.salonName,
    required this.serviceType,
    required this.serviceDescription,
    required this.bookingDate,
    required this.timeSlot,
    required this.price,
    required this.status,
    required this.isInstantBooking,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.calendarEventId,
    required this.reminderSet,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      salonId: json['salon_id'] ?? '',
      salonName: json['salon_name'] ?? '',
      serviceType: json['service_type'] ?? '',
      serviceDescription: json['service_description'] ?? '',
      bookingDate: DateTime.parse(json['booking_date']),
      timeSlot: json['time_slot'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      isInstantBooking: json['is_instant_booking'] ?? false,
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      calendarEventId: json['calendar_event_id'],
      reminderSet: json['reminder_set'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'salon_id': salonId,
      'salon_name': salonName,
      'service_type': serviceType,
      'service_description': serviceDescription,
      'booking_date': bookingDate.toIso8601String(),
      'time_slot': timeSlot,
      'price': price,
      'status': status,
      'is_instant_booking': isInstantBooking,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'calendar_event_id': calendarEventId,
      'reminder_set': reminderSet,
    };
  }

  Booking copyWith({
    String? status,
    DateTime? bookingDate,
    String? timeSlot,
    DateTime? updatedAt,
    bool? reminderSet,
    String? calendarEventId,
  }) {
    return Booking(
      id: id,
      userId: userId,
      salonId: salonId,
      salonName: salonName,
      serviceType: serviceType,
      serviceDescription: serviceDescription,
      bookingDate: bookingDate ?? this.bookingDate,
      timeSlot: timeSlot ?? this.timeSlot,
      price: price,
      status: status ?? this.status,
      isInstantBooking: isInstantBooking,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      calendarEventId: calendarEventId ?? this.calendarEventId,
      reminderSet: reminderSet ?? this.reminderSet,
    );
  }
}
