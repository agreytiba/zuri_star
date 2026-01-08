import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class SalonOwnerHomeScreen extends ConsumerWidget {
  const SalonOwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    const primaryColor = Color(0xFFEAB308);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Salon Dashboard',
           style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
               ref.read(authProvider.notifier).logout();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
         padding: const EdgeInsets.all(20),
         child: Column(
           children: [
             _buildStatCard('Total Bookings', '12', primaryColor),
             const SizedBox(height: 16),
             _buildStatCard('Pending Requests', '4', Colors.orange),
             const SizedBox(height: 16),
             _buildStatCard('Total Revenue', '\$1,240', Colors.green),
             const SizedBox(height: 32),
             Text('Manage Your Salon', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
             // Add more management widgets here
           ],
         ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(title, style: GoogleFonts.inter(color: Colors.black54, fontSize: 16)),
           const SizedBox(height: 8),
           Text(value, style: GoogleFonts.outfit(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
