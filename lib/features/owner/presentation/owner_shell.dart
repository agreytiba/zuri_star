import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dashboard/owner_dashboard_screen.dart';
import '../bookings/owner_bookings_screen.dart';
import '../services/owner_services_screen.dart';
import '../staff/owner_staff_screen.dart';
import '../settings/owner_more_screen.dart';

/// Root shell for salon owners with bottom navigation.
///
/// Tabs:
/// - Dashboard
/// - Bookings
/// - Services
/// - Staff
/// - More (earnings, settings, etc.)
class OwnerShell extends ConsumerStatefulWidget {
  const OwnerShell({super.key});

  @override
  ConsumerState<OwnerShell> createState() => _OwnerShellState();
}

class _OwnerShellState extends ConsumerState<OwnerShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    OwnerDashboardScreen(),
    OwnerBookingsScreen(),
    OwnerServicesScreen(),
    OwnerStaffScreen(),
    OwnerMoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEAB308);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services_outlined),
            activeIcon: Icon(Icons.design_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group),
            label: 'Staff',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            activeIcon: Icon(Icons.more),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

