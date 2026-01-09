import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/presentation/providers/auth_providers.dart';
import '../../../core/services/supabase_service.dart';

class OwnerMoreScreen extends ConsumerWidget {
  const OwnerMoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'More',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          if (user != null)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(user.name),
              subtitle: Text(user.email),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text('Earnings'),
            subtitle:
                const Text('View daily, weekly and monthly earnings breakdown'),
            onTap: () {
              // TODO: navigate to detailed earnings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.reviews_outlined),
            title: const Text('Reviews'),
            subtitle: const Text('See customer reviews and ratings'),
            onTap: () {
              // TODO: navigate to owner reviews screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Business settings'),
            subtitle: const Text('Business hours, salon details, verification'),
            onTap: () {
              // TODO: navigate to settings screen
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await SupabaseService.signOut();
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}

