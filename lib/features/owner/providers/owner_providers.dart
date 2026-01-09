import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zuri_star/core/models/booking.dart';
import 'package:zuri_star/core/services/supabase_service.dart';
import 'package:zuri_star/features/owner/data/mock_owner_data.dart';
import 'package:zuri_star/features/owner/data/owner_supabase_service.dart';
import 'package:zuri_star/features/owner/models/owner_dashboard_summary.dart';
import 'package:zuri_star/features/owner/models/owner_service.dart';
import 'package:zuri_star/features/owner/models/owner_staff_member.dart';

// ============================================
// SUPABASE SERVICE PROVIDER
// ============================================

final ownerSupabaseServiceProvider = Provider<OwnerSupabaseService>((ref) {
  return OwnerSupabaseService(client: SupabaseService.client);
});

// ============================================
// DASHBOARD PROVIDERS
// ============================================

/// Dashboard summary with real-time data from Supabase
final ownerDashboardSummaryProvider =
    FutureProvider<OwnerDashboardSummary>((ref) async {
  try {
    final supabaseService = ref.watch(ownerSupabaseServiceProvider);
    return await supabaseService.getDashboardSummary();
  } catch (e) {
    // Fallback to mock data
    return MockOwnerData.getDashboardSummary();
  }
});

// ============================================
// BOOKINGS PROVIDERS
// ============================================

/// All bookings for owner (streaming)
final ownerBookingsProvider =
    StreamProvider<List<Booking>>((ref) async* {
  try {
    final supabaseService = ref.watch(ownerSupabaseServiceProvider);
    yield* supabaseService.getAllBookingsStream();
  } catch (e) {
    // Fallback to mock data
    yield MockOwnerData.getAllBookings();
  }
});

/// Upcoming bookings for owner
final ownerUpcomingBookingsProvider =
    FutureProvider<List<Booking>>((ref) async {
  try {
    final supabaseService = ref.watch(ownerSupabaseServiceProvider);
    return await supabaseService.getUpcomingBookings();
  } catch (e) {
    // Fallback to mock data
    return MockOwnerData.getUpcomingBookings();
  }
});

// ============================================
// SERVICES PROVIDERS
// ============================================

/// Owner's services (streaming)
final ownerServicesProvider =
    StreamProvider<List<OwnerService>>((ref) async* {
  try {
    final supabaseService = ref.watch(ownerSupabaseServiceProvider);
    yield* supabaseService.getServicesStream();
  } catch (e) {
    // Fallback to mock data
    yield MockOwnerData.getServices();
  }
});

// ============================================
// STAFF PROVIDERS
// ============================================

/// Owner's staff members (streaming)
final ownerStaffProvider =
    StreamProvider<List<OwnerStaffMember>>((ref) async* {
  try {
    final supabaseService = ref.watch(ownerSupabaseServiceProvider);
    yield* supabaseService.getStaffStream();
  } catch (e) {
    // Fallback to mock data
    yield MockOwnerData.getStaff();
  }
});

// ============================================
// REVENUE PROVIDERS
// ============================================

/// Revenue summary provider
final ownerRevenueSummaryProvider =
    FutureProvider((ref) async {
  try {
    final supabaseService = ref.watch(ownerSupabaseServiceProvider);
    return await supabaseService.getRevenueSummary();
  } catch (e) {
    // Fallback to mock data
    return MockOwnerData.getRevenueSummary();
  }
});

// ============================================
// REVIEWS PROVIDERS
// ============================================

/// Owner's reviews
final ownerReviewsProvider =
    FutureProvider((ref) async {
  try {
    final supabaseService = ref.watch(ownerSupabaseServiceProvider);
    return await supabaseService.getReviews();
  } catch (e) {
    return [];
  }
});
