import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/entities/user_entity.dart';

/// Supported user roles in the app.
///
/// This mirrors the `role` field in the `profiles` table:
/// - `customer`
/// - `salon_owner`
enum AppRole {
  customer,
  salonOwner,
  unknown,
}

AppRole mapRoleStringToEnum(String? role) {
  switch (role) {
    case 'customer':
      return AppRole.customer;
    case 'salon_owner':
      return AppRole.salonOwner;
    default:
      return AppRole.unknown;
  }
}

bool isCustomer(UserEntity? user) =>
    mapRoleStringToEnum(user?.role) == AppRole.customer;

bool isSalonOwner(UserEntity? user) =>
    mapRoleStringToEnum(user?.role) == AppRole.salonOwner;

/// Simple widget-level guard that can be used around owner-only content.
class RoleGuard extends ConsumerWidget {
  const RoleGuard({
    super.key,
    required this.allowedRoles,
    required this.builder,
    this.unauthorizedBuilder,
    required this.userProvider,
  });

  final List<AppRole> allowedRoles;
  final Widget Function(BuildContext context, WidgetRef ref) builder;
  final Widget Function(BuildContext context, WidgetRef ref)? unauthorizedBuilder;

  /// Provider that exposes the authenticated user (typically `authProvider`).
  final ProviderBase<dynamic> userProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProvider);
    // Expecting state to expose a `user` field; keep this dynamic to avoid
    // tight coupling with auth state implementation.
    final UserEntity? user = state is dynamic ? state.user as UserEntity? : null;
    final role = mapRoleStringToEnum(user?.role);

    if (allowedRoles.contains(role)) {
      return builder(context, ref);
    }

    if (unauthorizedBuilder != null) {
      return unauthorizedBuilder!(context, ref);
    }

    return const SizedBox.shrink();
  }
}

