import 'package:zuri_star/core/models/booking_model.dart';
import '../dashboard/owner_dashboard_screen.dart';
import '../services/owner_services_screen.dart';
import '../staff/owner_staff_screen.dart';

/// Mock data for salon owner dashboard demonstration
class MockOwnerData {
  /// Sample dashboard summary
  static OwnerDashboardSummary getDashboardSummary() {
    return OwnerDashboardSummary(
      todayBookingsCount: 8,
      upcomingBookings: getUpcomingBookings(),
      revenueSummary: getRevenueSummary(),
      averageRating: 4.8,
    );
  }

  /// Sample revenue summary
  static RevenueSummary getRevenueSummary() {
    return RevenueSummary(
      today: 450.00,
      thisWeek: 2850.50,
      thisMonth: 11200.75,
    );
  }

  /// Sample upcoming bookings for the next 7 days
  static List<Booking> getUpcomingBookings() {
    final now = DateTime.now();
    return [
      Booking(
        id: 'booking_001',
        userId: 'user_101',
        salonId: 'salon_001',
        salonName: 'Luxe Salon',
        serviceType: 'Hair Cut',
        serviceDescription: 'Professional haircut and styling',
        bookingDate: now.add(const Duration(hours: 2)),
        timeSlot: '10:00 AM - 11:00 AM',
        price: 45.00,
        status: 'confirmed',
        isInstantBooking: true,
        notes: 'Customer wants fade with line design',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
        calendarEventId: 'event_001',
        reminderSet: true,
      ),
      Booking(
        id: 'booking_002',
        userId: 'user_102',
        salonId: 'salon_001',
        salonName: 'Luxe Salon',
        serviceType: 'Manicure',
        serviceDescription: 'Full manicure with gel polish',
        bookingDate: now.add(const Duration(hours: 4)),
        timeSlot: '1:00 PM - 2:00 PM',
        price: 35.00,
        status: 'confirmed',
        isInstantBooking: false,
        notes: null,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: null,
        calendarEventId: 'event_002',
        reminderSet: true,
      ),
      Booking(
        id: 'booking_003',
        userId: 'user_103',
        salonId: 'salon_001',
        salonName: 'Luxe Salon',
        serviceType: 'Facial Treatment',
        serviceDescription: 'Hydrating facial with massage',
        bookingDate: now.add(const Duration(hours: 6)),
        timeSlot: '3:00 PM - 4:00 PM',
        price: 65.00,
        status: 'pending',
        isInstantBooking: true,
        notes: 'First time customer, sensitive skin',
        createdAt: now.subtract(const Duration(hours: 5)),
        updatedAt: null,
        calendarEventId: 'event_003',
        reminderSet: false,
      ),
      Booking(
        id: 'booking_004',
        userId: 'user_104',
        salonId: 'salon_001',
        salonName: 'Luxe Salon',
        serviceType: 'Hair Coloring',
        serviceDescription: 'Full color with highlights',
        bookingDate: now.add(const Duration(days: 1, hours: 10)),
        timeSlot: '10:00 AM - 12:00 PM',
        price: 120.00,
        status: 'confirmed',
        isInstantBooking: false,
        notes: 'Customer wants ash blonde',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 1)),
        calendarEventId: 'event_004',
        reminderSet: true,
      ),
      Booking(
        id: 'booking_005',
        userId: 'user_105',
        salonId: 'salon_001',
        salonName: 'Luxe Salon',
        serviceType: 'Pedicure',
        serviceDescription: 'Deluxe pedicure with massage',
        bookingDate: now.add(const Duration(days: 2, hours: 2)),
        timeSlot: '2:00 PM - 3:00 PM',
        price: 40.00,
        status: 'confirmed',
        isInstantBooking: true,
        notes: null,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: null,
        calendarEventId: 'event_005',
        reminderSet: true,
      ),
    ];
  }

  /// Sample services offered by the salon
  static List<OwnerService> getServices() {
    return [
      OwnerService(
        id: 'service_001',
        name: 'Hair Cut',
        description: 'Professional haircut with styling consultation',
        price: 45.00,
        durationMinutes: 60,
        isEnabled: true,
      ),
      OwnerService(
        id: 'service_002',
        name: 'Hair Coloring',
        description: 'Full color, highlights, or balayage services',
        price: 85.00,
        durationMinutes: 120,
        isEnabled: true,
      ),
      OwnerService(
        id: 'service_003',
        name: 'Manicure',
        description: 'Gel or regular manicure with polish',
        price: 35.00,
        durationMinutes: 45,
        isEnabled: true,
      ),
      OwnerService(
        id: 'service_004',
        name: 'Pedicure',
        description: 'Deluxe pedicure with foot massage',
        price: 40.00,
        durationMinutes: 60,
        isEnabled: true,
      ),
      OwnerService(
        id: 'service_005',
        name: 'Facial Treatment',
        description: 'Hydrating, anti-aging, or acne facial',
        price: 65.00,
        durationMinutes: 75,
        isEnabled: true,
      ),
      OwnerService(
        id: 'service_006',
        name: 'Waxing',
        description: 'Full body waxing services for men and women',
        price: 30.00,
        durationMinutes: 30,
        isEnabled: false,
      ),
      OwnerService(
        id: 'service_007',
        name: 'Massage Therapy',
        description: 'Swedish, deep tissue, or therapeutic massage',
        price: 75.00,
        durationMinutes: 60,
        isEnabled: true,
      ),
      OwnerService(
        id: 'service_008',
        name: 'Eyebrow Threading',
        description: 'Professional eyebrow shaping and threading',
        price: 15.00,
        durationMinutes: 15,
        isEnabled: true,
      ),
    ];
  }

  /// Sample staff members
  static List<OwnerStaffMember> getStaff() {
    return [
      OwnerStaffMember(
        id: 'staff_001',
        name: 'Sarah Johnson',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        skills: ['Hair Cut', 'Hair Coloring', 'Styling'],
        commissionRate: 0.30,
      ),
      OwnerStaffMember(
        id: 'staff_002',
        name: 'Emma Wilson',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        skills: ['Manicure', 'Pedicure', 'Nail Art'],
        commissionRate: 0.25,
      ),
      OwnerStaffMember(
        id: 'staff_003',
        name: 'Michael Chen',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        skills: ['Massage Therapy', 'Facial Treatment'],
        commissionRate: 0.35,
      ),
      OwnerStaffMember(
        id: 'staff_004',
        name: 'Priya Patel',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        skills: [
          'Facial Treatment',
          'Waxing',
          'Eyebrow Threading',
        ],
        commissionRate: 0.28,
      ),
      OwnerStaffMember(
        id: 'staff_005',
        name: 'David Martinez',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        skills: ['Hair Cut', 'Beard Grooming'],
        commissionRate: 0.32,
      ),
    ];
  }

  /// Sample all bookings (for bookings tab)
  static List<Booking> getAllBookings() {
    final now = DateTime.now();
    return [
      ...getUpcomingBookings(),
      // Past bookings
      Booking(
        id: 'booking_006',
        userId: 'user_106',
        salonId: 'salon_001',
        salonName: 'Luxe Salon',
        serviceType: 'Hair Cut',
        serviceDescription: 'Professional haircut and styling',
        bookingDate: now.subtract(const Duration(days: 1)),
        timeSlot: '10:00 AM - 11:00 AM',
        price: 45.00,
        status: 'completed',
        isInstantBooking: true,
        notes: null,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 1)),
        calendarEventId: 'event_006',
        reminderSet: true,
      ),
      Booking(
        id: 'booking_007',
        userId: 'user_107',
        salonId: 'salon_001',
        salonName: 'Luxe Salon',
        serviceType: 'Facial Treatment',
        serviceDescription: 'Hydrating facial with massage',
        bookingDate: now.subtract(const Duration(days: 2)),
        timeSlot: '2:00 PM - 3:00 PM',
        price: 65.00,
        status: 'completed',
        isInstantBooking: false,
        notes: null,
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 2)),
        calendarEventId: 'event_007',
        reminderSet: true,
      ),
      Booking(
        id: 'booking_008',
        userId: 'user_108',
        salonId: 'salon_001',
        salonName: 'Luxe Salon',
        serviceType: 'Manicure',
        serviceDescription: 'Full manicure with gel polish',
        bookingDate: now.subtract(const Duration(days: 3)),
        timeSlot: '11:00 AM - 12:00 PM',
        price: 35.00,
        status: 'cancelled',
        isInstantBooking: true,
        notes: 'Customer requested cancellation',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 3)),
        calendarEventId: null,
        reminderSet: false,
      ),
      Booking(
        id: 'booking_009',
        userId: 'user_109',
        salonId: 'salon_001',
        salonName: 'Luxe Salon',
        serviceType: 'Massage Therapy',
        serviceDescription: 'Swedish massage with aromatherapy',
        bookingDate: now.subtract(const Duration(days: 5)),
        timeSlot: '3:00 PM - 4:00 PM',
        price: 75.00,
        status: 'completed',
        isInstantBooking: false,
        notes: null,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 5)),
        calendarEventId: 'event_009',
        reminderSet: true,
      ),
    ];
  }

  /// Statistics summary for dashboard
  static Map<String, dynamic> getOwnerStats() {
    final now = DateTime.now();
    return {
      'total_bookings': 32,
      'completed_bookings': 28,
      'cancelled_bookings': 2,
      'pending_bookings': 2,
      'total_revenue': 11200.75,
      'avg_booking_value': 350.02,
      'customer_count': 24,
      'staff_count': 5,
      'service_count': 8,
      'avg_rating': 4.8,
      'total_ratings': 28,
      'booking_this_week': 15,
      'booking_this_month': 32,
      'occupancy_rate': 0.85, // 85%
    };
  }
}
