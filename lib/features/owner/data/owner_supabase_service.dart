import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zuri_star/core/models/booking.dart';
import 'package:zuri_star/core/network/supabase_service.dart';
import 'package:zuri_star/features/owner/models/owner_dashboard_summary.dart';
import 'package:zuri_star/features/owner/models/owner_service.dart';
import 'package:zuri_star/features/owner/models/owner_staff_member.dart';
import 'package:zuri_star/features/owner/models/revenue_summary.dart';

class OwnerSupabaseService {
  final SupabaseClient client;
  
  OwnerSupabaseService({required this.client});

  // Get the authenticated user's ID
  String? get _userId => client.auth.currentUser?.id;

  // ============================================
  // DASHBOARD METHODS
  // ============================================

  /// Get dashboard summary for owner
  Future<OwnerDashboardSummary> getDashboardSummary() async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      // Get owner's salon ID
      final salonResponse = await client
          .from('salons')
          .select('id')
          .eq('owner_id', _userId!)
          .single();
      
      final salonId = salonResponse['id'] as String;

      // Get today's bookings
      final today = DateTime.now();
      final todayString = today.toIso8601String().split('T')[0];
      final todayEnd = today.add(Duration(days: 1)).toIso8601String().split('T')[0];

      final bookingsResponse = await client
          .from('bookings')
          .select()
          .eq('owner_id', _userId!)
          .eq('salon_id', salonId)
          .gte('booking_date', '$todayString 00:00:00')
          .lt('booking_date', '$todayEnd 00:00:00');

      final todayBookings = (bookingsResponse as List)
          .map((b) => Booking.fromJson(b as Map<String, dynamic>))
          .toList();

      // Get revenue summary
      final revenueSummary = await getRevenueSummary();

      // Get average rating
      final reviewsResponse = await client
          .from('reviews')
          .select('rating')
          .eq('owner_id', _userId!)
          .eq('salon_id', salonId);

      final ratings = (reviewsResponse as List)
          .map((r) => (r['rating'] as num).toDouble())
          .toList();
      final avgRating = ratings.isEmpty 
          ? 0.0 
          : ratings.reduce((a, b) => a + b) / ratings.length;

      // Get upcoming bookings count
      final upcomingResponse = await client
          .from('bookings')
          .select()
          .eq('owner_id', _userId!)
          .eq('salon_id', salonId)
          .gte('booking_date', today.toIso8601String())
          .lt('booking_date', today.add(Duration(days: 7)).toIso8601String());

      final upcomingCount = (upcomingResponse as List).length;

      return OwnerDashboardSummary(
        todayBookings: todayBookings.length,
        averageRating: avgRating,
        upcomingBookings: upcomingCount,
        monthlyRevenue: revenueSummary.monthlyTotal,
        dailyRevenue: revenueSummary.dailyBreakdown,
        weeklyRevenue: revenueSummary.weeklyBreakdown,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ============================================
  // BOOKINGS METHODS
  // ============================================

  /// Get all bookings for owner (stream)
  Stream<List<Booking>> getAllBookingsStream() {
    if (_userId == null) {
      return Stream.error(Exception('User not authenticated'));
    }

    return client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('owner_id', _userId!)
        .order('booking_date', ascending: false)
        .map((data) => (data as List)
            .map((b) => Booking.fromJson(b as Map<String, dynamic>))
            .toList());
  }

  /// Get all bookings for owner (future)
  Future<List<Booking>> getAllBookings() async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final response = await client
          .from('bookings')
          .select()
          .eq('owner_id', _userId!)
          .order('booking_date', ascending: false);

      return (response as List)
          .map((b) => Booking.fromJson(b as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get upcoming bookings
  Future<List<Booking>> getUpcomingBookings({int days = 7}) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final now = DateTime.now();
      final future = now.add(Duration(days: days));

      final response = await client
          .from('bookings')
          .select()
          .eq('owner_id', _userId!)
          .gte('booking_date', now.toIso8601String())
          .lte('booking_date', future.toIso8601String())
          .order('booking_date', ascending: true);

      return (response as List)
          .map((b) => Booking.fromJson(b as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      await client
          .from('bookings')
          .update({'status': status})
          .eq('id', bookingId)
          .eq('owner_id', _userId!);
    } catch (e) {
      rethrow;
    }
  }

  /// Update booking
  Future<void> updateBooking(String bookingId, Map<String, dynamic> updates) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      await client
          .from('bookings')
          .update(updates)
          .eq('id', bookingId)
          .eq('owner_id', _userId!);
    } catch (e) {
      rethrow;
    }
  }

  // ============================================
  // SERVICES METHODS
  // ============================================

  /// Get owner's services (stream)
  Stream<List<OwnerService>> getServicesStream() {
    if (_userId == null) {
      return Stream.error(Exception('User not authenticated'));
    }

    return client
        .from('services')
        .stream(primaryKey: ['id'])
        .eq('owner_id', _userId!)
        .order('created_at', ascending: false)
        .map((data) => (data as List)
            .map((s) => OwnerService.fromJson(s as Map<String, dynamic>))
            .toList());
  }

  /// Get owner's services (future)
  Future<List<OwnerService>> getServices() async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final response = await client
          .from('services')
          .select()
          .eq('owner_id', _userId!)
          .order('created_at', ascending: false);

      return (response as List)
          .map((s) => OwnerService.fromJson(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Create a new service
  Future<OwnerService> createService(Map<String, dynamic> serviceData) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      serviceData['owner_id'] = _userId;

      final response = await client
          .from('services')
          .insert(serviceData)
          .select()
          .single();

      return OwnerService.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Update service
  Future<void> updateService(String serviceId, Map<String, dynamic> updates) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      await client
          .from('services')
          .update(updates)
          .eq('id', serviceId)
          .eq('owner_id', _userId!);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete service
  Future<void> deleteService(String serviceId) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      await client
          .from('services')
          .delete()
          .eq('id', serviceId)
          .eq('owner_id', _userId!);
    } catch (e) {
      rethrow;
    }
  }

  // ============================================
  // STAFF METHODS
  // ============================================

  /// Get owner's staff (stream)
  Stream<List<OwnerStaffMember>> getStaffStream() {
    if (_userId == null) {
      return Stream.error(Exception('User not authenticated'));
    }

    return client
        .from('staff')
        .stream(primaryKey: ['id'])
        .eq('owner_id', _userId!)
        .order('created_at', ascending: false)
        .map((data) => (data as List)
            .map((s) => OwnerStaffMember.fromJson(s as Map<String, dynamic>))
            .toList());
  }

  /// Get owner's staff (future)
  Future<List<OwnerStaffMember>> getStaff() async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final response = await client
          .from('staff')
          .select()
          .eq('owner_id', _userId!)
          .order('created_at', ascending: false);

      return (response as List)
          .map((s) => OwnerStaffMember.fromJson(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Create a new staff member
  Future<OwnerStaffMember> createStaff(Map<String, dynamic> staffData) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      staffData['owner_id'] = _userId;

      final response = await client
          .from('staff')
          .insert(staffData)
          .select()
          .single();

      return OwnerStaffMember.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Update staff member
  Future<void> updateStaff(String staffId, Map<String, dynamic> updates) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      await client
          .from('staff')
          .update(updates)
          .eq('id', staffId)
          .eq('owner_id', _userId!);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete staff member
  Future<void> deleteStaff(String staffId) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      await client
          .from('staff')
          .delete()
          .eq('id', staffId)
          .eq('owner_id', _userId!);
    } catch (e) {
      rethrow;
    }
  }

  // ============================================
  // REVENUE METHODS
  // ============================================

  /// Get revenue summary
  Future<RevenueSummary> getRevenueSummary() async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final dayStart = DateTime(now.year, now.month, now.day);

      // Get month's earnings
      final monthResponse = await client
          .from('earnings')
          .select('amount')
          .eq('owner_id', _userId!)
          .gte('date', monthStart.toIso8601String().split('T')[0])
          .lte('date', monthEnd.toIso8601String().split('T')[0]);

      final monthTotal = (monthResponse as List)
          .fold<double>(0, (sum, item) => sum + (item['amount'] as num).toDouble());

      // Get week's earnings
      final weekResponse = await client
          .from('earnings')
          .select('amount')
          .eq('owner_id', _userId!)
          .gte('date', weekStart.toIso8601String().split('T')[0])
          .lte('date', now.toIso8601String().split('T')[0]);

      final weekTotal = (weekResponse as List)
          .fold<double>(0, (sum, item) => sum + (item['amount'] as num).toDouble());

      // Get today's earnings
      final dayResponse = await client
          .from('earnings')
          .select('amount')
          .eq('owner_id', _userId!)
          .eq('date', dayStart.toIso8601String().split('T')[0]);

      final dayTotal = (dayResponse as List)
          .fold<double>(0, (sum, item) => sum + (item['amount'] as num).toDouble());

      // Build daily breakdown for the month
      Map<String, double> dailyBreakdown = {};
      for (int i = 0; i < monthEnd.day; i++) {
        final date = DateTime(now.year, now.month, i + 1);
        final dateString = date.toIso8601String().split('T')[0];
        final dayEarnings = await client
            .from('earnings')
            .select('amount')
            .eq('owner_id', _userId!)
            .eq('date', dateString);

        dailyBreakdown[dateString] = (dayEarnings as List)
            .fold<double>(0, (sum, item) => sum + (item['amount'] as num).toDouble());
      }

      // Build weekly breakdown
      Map<String, double> weeklyBreakdown = {};
      for (int i = 0; i < 4; i++) {
        final weekStart = monthStart.add(Duration(days: i * 7));
        final weekEnd = (i == 3) ? monthEnd : weekStart.add(Duration(days: 6));
        final weekLabel = 'Week ${i + 1}';
        
        final weekEarnings = await client
            .from('earnings')
            .select('amount')
            .eq('owner_id', _userId!)
            .gte('date', weekStart.toIso8601String().split('T')[0])
            .lte('date', weekEnd.toIso8601String().split('T')[0]);

        weeklyBreakdown[weekLabel] = (weekEarnings as List)
            .fold<double>(0, (sum, item) => sum + (item['amount'] as num).toDouble());
      }

      return RevenueSummary(
        monthlyTotal: monthTotal,
        weeklyTotal: weekTotal,
        dailyTotal: dayTotal,
        dailyBreakdown: dailyBreakdown,
        weeklyBreakdown: weeklyBreakdown,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Record earning from completed booking
  Future<void> recordEarning({
    required String bookingId,
    required double amount,
    String? description,
  }) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      await client.from('earnings').insert({
        'owner_id': _userId,
        'booking_id': bookingId,
        'amount': amount,
        'date': DateTime.now().toIso8601String().split('T')[0],
        'description': description ?? 'Booking payment',
      });
    } catch (e) {
      rethrow;
    }
  }

  // ============================================
  // REVIEWS METHODS
  // ============================================

  /// Get reviews for owner
  Future<List<Map<String, dynamic>>> getReviews() async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      return await client
          .from('reviews')
          .select()
          .eq('owner_id', _userId!)
          .order('created_at', ascending: false);
    } catch (e) {
      rethrow;
    }
  }
}
