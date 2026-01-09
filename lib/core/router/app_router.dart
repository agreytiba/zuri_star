import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/booking/presentation/screens/booking_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/salon_details/presentation/screens/salon_details_screen.dart';
import '../../features/reviews/presentation/screens/review_screen.dart';
import '../../features/loyalty/presentation/screens/loyalty_screen.dart';
import '../role/role_router.dart';


final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.read(authProvider.notifier);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/';
      final isOnboarding = state.matchedLocation == '/onboarding';

      if(isSplash && !isLoggedIn && !authState.isLoading) {
         return null; 
      }

      if (isOnboarding) {
        if (isLoggedIn) return '/role';
        return null;
      }

      if (!isLoggedIn && !isLoggingIn && state.matchedLocation != '/') {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/role';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) => const BookingScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/salon-details/:id',
        builder: (context, state) {
          final salonId = state.pathParameters['id'] ?? '';
          return SalonDetailsScreen(salonId: salonId);
        },
      ),
      GoRoute(
        path: '/review/:bookingId/:salonName',
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId'] ?? '';
          final salonName = state.pathParameters['salonName'] ?? '';
          return ReviewScreen(
            bookingId: bookingId,
            salonName: salonName,
          );
        },
      ),
      GoRoute(
        path: '/loyalty',
        builder: (context, state) => const LoyaltyScreen(),
      ),
      GoRoute(
        path: '/role',
        builder: (context, state) => const RoleRouter(),
      ),
      // Legacy route redirect - redirect old salon-owner-home to role router
      GoRoute(
        path: '/salon-owner-home',
        redirect: (context, state) => '/role',
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});


class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
