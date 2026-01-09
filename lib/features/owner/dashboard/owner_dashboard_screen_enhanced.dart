import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/presentation/providers/auth_providers.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/supabase_service.dart';
import '../data/mock_owner_data.dart';
import '../data/owner_supabase_service.dart';

/// Provider with static data fallback for demonstration
final ownerDashboardSummaryProvider =
    FutureProvider<OwnerDashboardSummary>((ref) async {
  try {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    if (user == null) {
      // Return static data for demo
      return MockOwnerData.getDashboardSummary();
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
  } catch (e) {
    // Return static data on error for demonstration
    return MockOwnerData.getDashboardSummary();
  }
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

Future<int> _fetchTodayBookingsCount(user) async {
  try {
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
  } catch (_) {
    // Return mock data count
    return MockOwnerData.getDashboardSummary().todayBookingsCount;
  }
}

Future<List<Booking>> _fetchUpcomingBookings(user) async {
  try {
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
  } catch (_) {
    // Return mock data
    return MockOwnerData.getUpcomingBookings();
  }
}

Future<RevenueSummary> _fetchRevenueSummary(user) async {
  try {
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
  } catch (_) {
    // Return mock data
    return MockOwnerData.getRevenueSummary();
  }
}

Future<double> _fetchAverageRating(user) async {
  try {
    final response = await SupabaseService.client
        .from('reviews')
        .select('rating')
        .eq('owner_id', user.id);

    final list = response as List;
    if (list.isEmpty) return 0;

    final total = list.fold<double>(
        0, (sum, row) => sum + (row['rating'] as num).toDouble());
    return total / list.length;
  } catch (_) {
    // Return mock rating
    return MockOwnerData.getDashboardSummary().averageRating;
  }
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
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                  _buildGreeting(),
                  const SizedBox(height: 24),
                  _buildHeadlineCards(summary, primaryColor),
                  const SizedBox(height: 24),
                  _buildRevenueSection(summary),
                  const SizedBox(height: 24),
                  _buildUpcomingBookingsCard(summary.upcomingBookings),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Here\'s your salon overview for today',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildHeadlineCards(
    OwnerDashboardSummary summary,
    Color primaryColor,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Today\'s Bookings',
                value: summary.todayBookingsCount.toString(),
                icon: Icons.event_note,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Avg Rating',
                value: summary.averageRating.toStringAsFixed(1),
                icon: Icons.star,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Upcoming',
                value: summary.upcomingBookings.length.toString(),
                icon: Icons.calendar_today,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'This Month',
                value: '\$${summary.revenueSummary.thisMonth.toStringAsFixed(0)}',
                icon: Icons.attach_money,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueSection(OwnerDashboardSummary summary) {
    final revenue = summary.revenueSummary;
    return _SectionCard(
      title: 'Revenue Overview',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RevenueTile(
                label: 'Today',
                amount: revenue.today,
              ),
              _RevenueTile(
                label: 'This Week',
                amount: revenue.thisWeek,
              ),
              _RevenueTile(
                label: 'This Month',
                amount: revenue.thisMonth,
              ),
            ],
          ),
        ],
      ),
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
      title: 'Upcoming Bookings',
      child: Column(
        children: bookings
            .map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _BookingListTile(booking: b),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return _SectionCard(
      title: 'Quick Actions',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: const [
          _QuickActionChip(
            icon: Icons.add_business_outlined,
            label: 'Create Salon',
          ),
          _QuickActionChip(
            icon: Icons.design_services_outlined,
            label: 'Add Service',
          ),
          _QuickActionChip(
            icon: Icons.calendar_today_outlined,
            label: 'View Calendar',
          ),
          _QuickActionChip(
            icon: Icons.people_alt_outlined,
            label: 'Manage Staff',
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
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueTile extends StatelessWidget {
  const _RevenueTile({
    required this.label,
    required this.amount,
  });

  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${amount.toStringAsFixed(0)}',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingListTile extends StatelessWidget {
  const _BookingListTile({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (booking.status) {
      case 'confirmed':
        statusColor = Colors.green;
      case 'pending':
        statusColor = Colors.orange;
      case 'completed':
        statusColor = Colors.blue;
      case 'cancelled':
        statusColor = Colors.red;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.serviceType,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${booking.bookingDate.toString().split('.')[0]} • ${booking.timeSlot}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${booking.price.toStringAsFixed(2)}',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
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
          Icon(icon, size: 32, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade600,
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
      backgroundColor: const Color(0xFFEAB308).withOpacity(0.1),
      onPressed: () {
        // Navigation wired per-action in next phases
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label clicked'),
            duration: const Duration(seconds: 1),
          ),
        );
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
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
            const SizedBox(height: 16),
            Text(
              'Failed to load dashboard',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Showing demo data',
              style: GoogleFonts.inter(color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
