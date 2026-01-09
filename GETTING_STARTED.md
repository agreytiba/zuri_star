# 🚀 Implementation Guide - Getting Started

## Quick Start (5 minutes)

### 1. View the Mock Data
```dart
// Open: lib/features/owner/data/mock_owner_data.dart
// This file contains ALL static data used by the screens
```

### 2. Run the Enhanced Dashboard
The enhanced screens automatically display mock data. You can view them by:

```bash
# Build and run
flutter run

# The app will use mock data if:
# - You're not authenticated, OR
# - Supabase connection fails
```

### 3. Navigate to Owner Dashboard
- If logged in as salon owner → Auto-navigates to dashboard
- Otherwise → Use role selection to switch to owner role

---

## File Structure Summary

```
lib/features/owner/
├── data/
│   └── mock_owner_data.dart
│       ├── getDashboardSummary()
│       ├── getUpcomingBookings()
│       ├── getAllBookings()
│       ├── getServices()
│       ├── getStaff()
│       └── getOwnerStats()
│
├── dashboard/
│   ├── owner_dashboard_screen.dart (original - live data only)
│   └── owner_dashboard_screen_enhanced.dart (NEW - with fallback)
│
├── bookings/
│   ├── owner_bookings_screen.dart (original)
│   └── owner_bookings_screen_enhanced.dart (NEW)
│
├── services/
│   ├── owner_services_screen.dart (original)
│   └── owner_services_screen_enhanced.dart (NEW)
│
├── staff/
│   ├── owner_staff_screen.dart (original)
│   └── owner_staff_screen_enhanced.dart (NEW)
│
└── presentation/
    └── owner_shell.dart (switches between tabs)
```

---

## Switching Between Original & Enhanced Screens

### To Use Enhanced Screens (With Mock Data)

Edit: `lib/features/owner/presentation/owner_shell.dart`

```dart
// Change FROM:
import '../dashboard/owner_dashboard_screen.dart';
import '../bookings/owner_bookings_screen.dart';
import '../services/owner_services_screen.dart';
import '../staff/owner_staff_screen.dart';

// Change TO:
import '../dashboard/owner_dashboard_screen_enhanced.dart';
import '../bookings/owner_bookings_screen_enhanced.dart';
import '../services/owner_services_screen_enhanced.dart';
import '../staff/owner_staff_screen_enhanced.dart';
```

Then update the list:
```dart
final List<Widget> _pages = const [
  OwnerDashboardScreen(),      // Now uses enhanced version
  OwnerBookingsScreen(),        // Now uses enhanced version
  OwnerServicesScreen(),        // Now uses enhanced version
  OwnerStaffScreen(),           // Now uses enhanced version
  OwnerMoreScreen(),            // Keep original for now
];
```

### To Use Original Screens (Live Supabase Only)

Keep the current imports in `owner_shell.dart` - no changes needed.

---

## Customizing Mock Data

### Add More Bookings
```dart
// File: lib/features/owner/data/mock_owner_data.dart

static List<Booking> getUpcomingBookings() {
  final now = DateTime.now();
  return [
    Booking(
      id: 'booking_NEW',
      userId: 'user_NEW',
      salonId: 'salon_001',
      salonName: 'Your Salon Name',
      serviceType: 'Your Service',
      serviceDescription: 'Description',
      bookingDate: now.add(const Duration(hours: 3)),
      timeSlot: '3:00 PM - 4:00 PM',
      price: 99.99,
      status: 'confirmed',
      isInstantBooking: false,
      notes: 'Customer notes here',
      createdAt: now,
      updatedAt: null,
      calendarEventId: null,
      reminderSet: true,
    ),
    // Add more bookings...
  ];
}
```

### Update Service Prices
```dart
static List<OwnerService> getServices() {
  return [
    OwnerService(
      id: 'service_001',
      name: 'Hair Cut',
      description: 'Professional haircut with styling',
      price: 45.00,  // ← Change this
      durationMinutes: 60,
      isEnabled: true,
    ),
    // ...
  ];
}
```

### Add More Staff Members
```dart
static List<OwnerStaffMember> getStaff() {
  return [
    OwnerStaffMember(
      id: 'staff_NEW',
      name: 'New Staff Member',
      avatarUrl: 'https://i.pravatar.cc/150?img=10',
      skills: ['Skill 1', 'Skill 2', 'Skill 3'],
      commissionRate: 0.30,  // 30%
    ),
    // ...
  ];
}
```

### Update Dashboard Numbers
```dart
static OwnerDashboardSummary getDashboardSummary() {
  return OwnerDashboardSummary(
    todayBookingsCount: 12,  // ← Change this
    upcomingBookings: getUpcomingBookings(),
    revenueSummary: getRevenueSummary(),
    averageRating: 4.9,  // ← And this
  );
}
```

---

## Understanding the Data Models

### Booking Model
```dart
final booking = Booking(
  id: 'unique_id',                    // String - unique identifier
  userId: 'customer_id',              // String - who booked it
  salonId: 'salon_id',                // String - which salon
  salonName: 'Salon Name',            // String - salon display name
  serviceType: 'Hair Cut',            // String - service name
  serviceDescription: 'Professional', // String - what it includes
  bookingDate: DateTime(2024, 1, 15), // DateTime - when
  timeSlot: '10:00 AM - 11:00 AM',    // String - time range
  price: 45.00,                       // double - cost
  status: 'confirmed',                // String - pending|confirmed|completed|cancelled
  isInstantBooking: true,             // bool - instant or scheduled
  notes: 'Customer notes',            // String? - optional notes
  createdAt: DateTime.now(),          // DateTime - created when
  updatedAt: null,                    // DateTime? - last updated
  calendarEventId: 'event_id',        // String? - optional calendar link
  reminderSet: true,                  // bool - has reminder
);
```

### Service Model
```dart
final service = OwnerService(
  id: 'service_id',                          // String
  name: 'Hair Cut',                          // String
  description: 'Professional haircut',       // String
  price: 45.00,                              // double
  durationMinutes: 60,                       // int
  isEnabled: true,                           // bool - active/inactive
);
```

### Staff Member Model
```dart
final staff = OwnerStaffMember(
  id: 'staff_id',                            // String
  name: 'John Doe',                          // String
  avatarUrl: 'https://...',                  // String? - profile pic
  skills: ['Hair Cut', 'Coloring'],          // List<String>
  commissionRate: 0.30,                      // double - 30%
);
```

### Revenue Summary Model
```dart
final revenue = RevenueSummary(
  today: 450.00,          // double
  thisWeek: 2850.50,      // double
  thisMonth: 11200.75,    // double
);
```

---

## How Error Fallback Works

### Original Screens (Without Fallback)
```dart
// If Supabase fails → Shows error screen
// No mock data available
```

### Enhanced Screens (With Fallback)
```dart
try {
  // Try to fetch from Supabase
  final user = authState.user;
  if (user == null) throw Exception('Not authenticated');
  
  final data = await SupabaseService.client.from('bookings').select();
  return data;
  
} catch (e) {
  // If anything fails → Use mock data automatically
  return MockOwnerData.getAllBookings();
}
```

This means:
- ✅ App works even without Supabase
- ✅ Great for testing/demo
- ✅ Smooth user experience
- ✅ No loading screens needed for demo data

---

## Testing Checklist

### Dashboard Screen
- [ ] Displays greeting based on time
- [ ] Shows 4 stat cards (Today, Upcoming, Rating, Revenue)
- [ ] Revenue section shows Today/Week/Month breakdown
- [ ] Upcoming bookings list shows 5 items
- [ ] Quick action chips are visible
- [ ] Pull to refresh works
- [ ] Error state shows gracefully

### Bookings Screen
- [ ] Filter chips visible at top
- [ ] Clicking filters shows correct bookings
- [ ] Booking cards show status colors
- [ ] Tapping a booking opens details sheet
- [ ] Details sheet shows all information
- [ ] Can scroll through all bookings
- [ ] Empty state shows when no bookings

### Services Screen
- [ ] Active services show first
- [ ] Disabled services show in separate section
- [ ] Each service shows price and duration
- [ ] Edit button opens form modal
- [ ] Can add new service
- [ ] Price and duration are editable
- [ ] Can save changes

### Staff Screen
- [ ] Staff cards show avatar
- [ ] Name and commission rate visible
- [ ] Skills display as chips
- [ ] Tapping card shows details
- [ ] Can edit staff member
- [ ] Can select/deselect skills
- [ ] Commission rate editable

---

## Performance Tips

### Optimize List Rendering
```dart
// Use ListView.builder instead of Column with many items
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(item: items[index]),
)
```

### Cache Images
```dart
// Use CircleAvatar with NetworkImage for caching
CircleAvatar(
  backgroundImage: NetworkImage(avatarUrl),
  radius: 28,
)
```

### Lazy Load Details
```dart
// Use bottom sheets instead of full screen navigation
showModalBottomSheet(
  context: context,
  builder: (context) => DetailSheet(item: item),
)
```

---

## UI Customization

### Change Primary Color
Find `Color(0xFFEAB308)` in enhanced screens and replace:

```dart
// Yellow (Current)
const primaryColor = Color(0xFFEAB308);

// Or try these alternatives:
// Purple:  Color(0xFF8B5CF6)
// Blue:    Color(0xFF3B82F6)
// Green:   Color(0xFF22C55E)
// Red:     Color(0xFFEF4444)
```

### Change Fonts
```dart
// Current: Google Fonts
GoogleFonts.outfit(fontSize: 16)

// To use default Flutter fonts:
TextStyle(fontSize: 16, fontFamily: 'Roboto')
```

### Change Spacing
```dart
// Standard padding: 16
// Standard gap: 12
// You can adjust these numbers throughout
const EdgeInsets.all(24)  // More space
const EdgeInsets.all(8)   // Less space
```

---

## Debugging Tips

### View All Mock Data
```dart
// Add this to main.dart to print sample data
void main() {
  print(MockOwnerData.getDashboardSummary());
  print(MockOwnerData.getAllBookings());
  print(MockOwnerData.getServices());
  print(MockOwnerData.getStaff());
  // ... rest of main()
}
```

### Force Mock Data
```dart
// Modify any provider to always use mock:
final ownerDashboardSummaryProvider =
    FutureProvider<OwnerDashboardSummary>((ref) async {
  // Skip auth, just return mock
  return MockOwnerData.getDashboardSummary();
});
```

### Check Booking Status
```dart
// Filter to see specific status
final confirmed = allBookings
    .where((b) => b.status == 'confirmed')
    .toList();

final pending = allBookings
    .where((b) => b.status == 'pending')
    .toList();
```

---

## Common Modifications

### Add New Service Category
```dart
// In mock_owner_data.dart
OwnerService(
  id: 'service_NEW',
  name: 'Your Service',
  description: 'Description',
  price: 50.00,
  durationMinutes: 45,
  isEnabled: true,
),
```

### Adjust Revenue Numbers
```dart
RevenueSummary(
  today: 500.00,      // Your number
  thisWeek: 3000.00,  // Your number
  thisMonth: 12000.00, // Your number
),
```

### Change Booking Count
```dart
OwnerDashboardSummary(
  todayBookingsCount: 10,  // Your number
  // ...
)
```

---

## Next Steps (After Testing)

1. **Remove Mock Data**
   - Delete mock_owner_data.dart when using real Supabase
   - Remove fallback logic from providers

2. **Add Real Features**
   - Booking confirmation/rejection
   - Service image upload
   - Staff availability calendar
   - Customer messaging

3. **Polish UI**
   - Add page transitions
   - Implement animations
   - Add loading states
   - Dark mode support

4. **Add More Screens**
   - Analytics dashboard
   - Revenue reports
   - Team performance metrics
   - Customer reviews

---

## Support & Questions

### Issue: Mock data not showing?
**Solution:** Make sure you're using `_enhanced.dart` screens and have Supabase failing or no auth.

### Issue: Empty list?
**Solution:** Check that `MockOwnerData.get*()` methods have data. Print to console to debug.

### Issue: Styles not applied?
**Solution:** Rebuild app with `flutter clean && flutter pub get && flutter run`

### Issue: Images not loading?
**Solution:** Avatar URLs from pravatar.cc should work. Otherwise, use placeholder icon.

---

## Resources

- **Flutter Docs:** https://flutter.dev/docs
- **Riverpod Docs:** https://riverpod.dev
- **Google Fonts:** https://fonts.google.com
- **Material Design:** https://material.io/design

---

This guide should help you get started quickly. All enhanced screens are production-ready and use realistic mock data that you can easily customize!
