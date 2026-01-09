import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/presentation/providers/auth_providers.dart';
import '../../auth/domain/entities/user_entity.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/supabase_service.dart';

final ownerDashboardSummaryProvider =
    FutureProvider<OwnerDashboardSummary>((ref) async {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  if (user == null) {
    throw Exception('User not authenticated');
  }

  final todayBookings = await _fetchTodayBookingsCount(user);
  final upcomingBookings = await _fetchUpcomingBookings(user);
  final revenue = await _fetchRevenueSummary(user);
  final rating = await _fetchAverageRating(user);

  return OwnerDashboardSummary(
    todayBookingsCount: todayBookings,
    upcomingBookings: upcomingBookings,
    revenueSummary: revenue,
    averageRating: rating,
  );
});

class OwnerDashboardSummary {
  final int todayBookingsCount;
  final List<Booking> upcomingBookings;
  final RevenueSummary revenueSummary;
  final double averageRating;

  OwnerDashboardSummary({
    required this.todayBookingsCount,
    required this.upcomingBookings,
    required this.revenueSummary,
    required this.averageRating,
  });
}

class RevenueSummary {
  final double today;
  final double thisWeek;
  final double thisMonth;

  RevenueSummary({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
  });
}

Future<int> _fetchTodayBookingsCount(UserEntity user) async {
  final today = DateTime.now();
  final startOfDay =
      DateTime(today.year, today.month, today.day).toIso8601String();
  final endOfDay =
      DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();

  final response = await SupabaseService.client
      .from('bookings')
      .select('id')
      .eq('owner_id', user.id)
      .gte('booking_date', startOfDay)
      .lte('booking_date', endOfDay);

  return (response as List).length;
}

Future<List<Booking>> _fetchUpcomingBookings(UserEntity user) async {
  final now = DateTime.now().toIso8601String();

  final response = await SupabaseService.client
      .from('bookings')
      .select()
      .eq('owner_id', user.id)
      .gte('booking_date', now)
      .order('booking_date')
      .limit(5);

  return (response as List)
      .map((json) => Booking.fromJson(json as Map<String, dynamic>))
      .toList();
}

Future<RevenueSummary> _fetchRevenueSummary(UserEntity user) async {
  // These queries assume an `earnings` table with `owner_id`, `amount`, `date`.
  // They respect RLS by always filtering on `owner_id = auth.uid()`.
  final today = DateTime.now();
  final startOfToday =
      DateTime(today.year, today.month, today.day).toIso8601String();
  final startOfWeek =
      today.subtract(Duration(days: today.weekday - 1)).toIso8601String();
  final startOfMonth = DateTime(today.year, today.month).toIso8601String();

  Future<double> _sumForRange(String from) async {
    final response = await SupabaseService.client
        .from('earnings')
        .select('amount')
        .eq('owner_id', user.id)
        .gte('date', from);

    final list = response as List;
    return list.fold<double>(
      0,
      (sum, row) => sum + (row['amount'] as num).toDouble(),
    );
  }

  final todayTotal = await _sumForRange(startOfToday);
  final weekTotal = await _sumForRange(startOfWeek);
  final monthTotal = await _sumForRange(startOfMonth);

  return RevenueSummary(
    today: todayTotal,
    thisWeek: weekTotal,
    thisMonth: monthTotal,
  );
}

Future<double> _fetchAverageRating(UserEntity user) async {
  final response = await SupabaseService.client
      .from('reviews')
      .select('rating')
      .eq('owner_id', user.id);

  final list = response as List;
  if (list.isEmpty) return 0;

  final total =
      list.fold<double>(0, (sum, row) => sum + (row['rating'] as num).toDouble());
  return total / list.length;
}

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryColor = Color(0xFFEAB308);
    final summaryAsync = ref.watch(ownerDashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Owner Dashboard',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _OwnerDashboardError(error: error),
        data: (summary) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(ownerDashboardSummaryProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeadlineCards(summary, primaryColor),
                  const SizedBox(height: 24),
                  _buildUpcomingBookingsCard(summary.upcomingBookings),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeadlineCards(
    OwnerDashboardSummary summary,
    Color primaryColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Today\'s Bookings',
            value: summary.todayBookingsCount.toString(),
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Avg Rating',
            value: summary.averageRating.toStringAsFixed(1),
            color: Colors.indigo,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingBookingsCard(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return _EmptyStateCard(
        icon: Icons.event_note_outlined,
        title: 'No upcoming bookings',
        message: 'New bookings will appear here as customers reserve slots.',
      );
    }

    return _SectionCard(
      title: 'Upcoming bookings',
      child: Column(
        children: bookings
            .map(
              (b) => ListTile(
                leading: const Icon(Icons.event_available),
                title: Text(b.salonName),
                subtitle: Text(
                  '${b.serviceType} • ${b.bookingDate.toLocal()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  '\$${b.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return _SectionCard(
      title: 'Quick actions',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: const [
          _QuickActionChip(
            icon: Icons.add_business_outlined,
            label: 'Create salon',
          ),
          _QuickActionChip(
            icon: Icons.design_services_outlined,
            label: 'Add service',
          ),
          _QuickActionChip(
            icon: Icons.calendar_today_outlined,
            label: 'View bookings',
          ),
          _QuickActionChip(
            icon: Icons.people_alt_outlined,
            label: 'Add staff',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: title,
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () {
        // Navigation wired per-action in next phases.
      },
    );
  }
}

class _OwnerDashboardError extends StatelessWidget {
  const _OwnerDashboardError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent),
            const SizedBox(height: 8),
            Text(
              'Failed to load dashboard',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

