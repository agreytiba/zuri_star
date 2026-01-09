import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/presentation/providers/auth_providers.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/supabase_service.dart';

final ownerBookingsProvider =
    StreamProvider.autoDispose<List<Booking>>((ref) async* {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  if (user == null) {
    yield [];
    return;
  }

  final stream = SupabaseService.client
      .from('bookings')
      .stream(primaryKey: ['id'])
      .eq('owner_id', user.id);

  await for (final rows in stream) {
    yield rows
        .map((row) => Booking.fromJson(row as Map<String, dynamic>))
        .toList();
  }
});

class OwnerBookingsScreen extends ConsumerWidget {
  const OwnerBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(ownerBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookings',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(message: e.toString()),
        data: (bookings) {
          if (bookings.isEmpty) {
            return const _EmptyBookingsView();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _BookingCard(booking: booking);
            },
          );
        },
      ),
    );
  }
}

class _BookingCard extends ConsumerWidget {
  const _BookingCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color statusColor;
    switch (booking.status) {
      case 'confirmed':
        statusColor = Colors.green;
      case 'pending':
        statusColor = Colors.orange;
      case 'cancelled':
        statusColor = Colors.red;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.serviceType,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    booking.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              booking.salonName,
              style: GoogleFonts.inter(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              '${booking.bookingDate.toLocal()} • ${booking.timeSlot}',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${booking.price.toStringAsFixed(0)}',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  spacing: 4,
                  children: [
                    _ActionChip(
                      label: 'Confirm',
                      icon: Icons.check_circle_outline,
                      onPressed: () => _updateStatus(ref, 'confirmed'),
                    ),
                    _ActionChip(
                      label: 'Reschedule',
                      icon: Icons.schedule_outlined,
                      onPressed: () {
                        // TODO: open reschedule flow
                      },
                    ),
                    _ActionChip(
                      label: 'Cancel',
                      icon: Icons.cancel_outlined,
                      onPressed: () => _updateStatus(ref, 'cancelled'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(WidgetRef ref, String status) async {
    await SupabaseService.client
        .from('bookings')
        .update({'status': status}).eq('id', booking.id);
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class _EmptyBookingsView extends StatelessWidget {
  const _EmptyBookingsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_busy_outlined, size: 48),
            const SizedBox(height: 8),
            Text(
              'No bookings yet',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Once customers start booking your services, they will appear here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

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
              'Failed to load bookings',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

