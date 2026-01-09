import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/owner/presentation/owner_shell.dart';
import 'role_guard.dart';

/// Decides which "shell" of the app to show based on the authenticated user's role.
///
/// This widget should be used as a single entry point after authentication,
/// so that:
/// - `customer` → customer experience (existing HomeScreen & flows)
/// - `salon_owner` → salon owner experience (OwnerShell / dashboard)
/// - any other / missing role → Unauthorized screen
class RoleRouter extends ConsumerWidget {
  const RoleRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (authState.isLoading) {
      return const _RoleLoadingScreen();
    }

    if (!authState.isAuthenticated || user == null) {
      // Not authenticated – let the GoRouter redirect logic kick in.
      // We keep this simple here and just show a minimal screen.
      return const _NotAuthenticatedScreen();
    }

    final role = mapRoleStringToEnum(user.role);

    switch (role) {
      case AppRole.customer:
        // Existing customer experience – reuse current HomeScreen.
        return const HomeScreen();
      case AppRole.salonOwner:
        // Owner experience – use dedicated owner shell with bottom navigation.
        return const OwnerShell();
      case AppRole.unknown:
      default:
        return const UnauthorizedRoleScreen();
    }
  }
}

class _RoleLoadingScreen extends StatelessWidget {
  const _RoleLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _NotAuthenticatedScreen extends StatelessWidget {
  const _NotAuthenticatedScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('You are not logged in'),
      ),
    );
  }
}

/// Fallback screen when a logged-in user has a role that is not supported.
class UnauthorizedRoleScreen extends StatelessWidget {
  const UnauthorizedRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Your account role is not authorized to access this app.\n'
            'Please contact support if you believe this is a mistake.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

