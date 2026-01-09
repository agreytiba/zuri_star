# Zuri Star - Salon Owner Side: Quick Reference

## 📊 Project Summary

This is a Flutter salon management app with a complete owner-side dashboard featuring:
- **Dashboard:** Overview of bookings, revenue, and ratings
- **Bookings:** Manage customer bookings with filtering
- **Services:** Manage salon services with pricing
- **Staff:** Manage team members and skills
- **Settings:** Owner preferences and analytics

## 🎨 UI Preview - What You'll See

### Dashboard Screen
```
┌─────────────────────────────────────┐
│ Good morning / afternoon / evening!  │
│ Here's your salon overview...        │
├─────────────────────────────────────┤
│ ┌──────────────────────────────────┐│
│ │ 📅 Today's Bookings  │ ⭐ Rating  ││
│ │        8             │   4.8/5   ││
│ │                                  ││
│ │ 📆 Upcoming    │ 💰 This Month  ││
│ │      5        │   $11,200.75   ││
│ └──────────────────────────────────┘│
├─────────────────────────────────────┤
│ REVENUE OVERVIEW                    │
│ Today: $450.00 | Week: $2,850.50   │
│ Month: $11,200.75                  │
├─────────────────────────────────────┤
│ UPCOMING BOOKINGS                   │
│ ├─ Hair Cut • 10:00 AM • $45.00    │
│ ├─ Manicure • 1:00 PM • $35.00     │
│ ├─ Facial • 3:00 PM • $65.00       │
│ └─ [2 more bookings...]            │
├─────────────────────────────────────┤
│ QUICK ACTIONS                       │
│ [Create Salon] [Add Service]        │
│ [View Calendar] [Manage Staff]      │
└─────────────────────────────────────┘
```

### Bookings Screen
```
┌─────────────────────────────────────┐
│ [All] [Pending] [Confirmed]         │
│ [Completed] [Cancelled]             │
├─────────────────────────────────────┤
│ ┌─ Hair Cut ────────────────────┐   │
│ │ Luxe Salon                    │   │
│ │ 2024-01-15 | 10:00 AM - 11 AM│   │
│ │                       [✓ CONFIRMED]│
│ │ $45.00                        │   │
│ └───────────────────────────────┘   │
│ ┌─ Manicure ────────────────────┐   │
│ │ Luxe Salon                    │   │
│ │ 2024-01-15 | 1:00 PM - 2 PM  │   │
│ │                      [⏳ PENDING] │
│ │ $35.00                        │   │
│ └───────────────────────────────┘   │
│ [Click card to see full details]    │
└─────────────────────────────────────┘
```

### Services Screen
```
┌─────────────────────────────────────┐
│ ACTIVE SERVICES                     │
├─────────────────────────────────────┤
│ Hair Cut                            │
│ Professional haircut and styling    │
│ Price: $45.00 | Duration: 60 min    │
│ [Edit]                              │
├─────────────────────────────────────┤
│ Hair Coloring                       │
│ Full color with highlights          │
│ Price: $85.00 | Duration: 120 min   │
│ [Edit]                              │
│ [... more services ...]             │
├─────────────────────────────────────┤
│ DISABLED SERVICES                   │
├─────────────────────────────────────┤
│ Waxing [DISABLED]                   │
│ Full body waxing services           │
│ Price: $30.00 | Duration: 30 min    │
│ [Edit]                              │
└─────────────────────────────────────┘
```

### Staff Screen
```
┌─────────────────────────────────────┐
│ ┌─────────────────────────────────┐ │
│ │ 👤 Sarah Johnson               │ │
│ │ 5 skills    30% Commission     │ │
│ │ [Hair Cut] [Hair Coloring]     │ │
│ │ [Styling]                      │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ 👤 Emma Wilson                 │ │
│ │ 3 skills    25% Commission     │ │
│ │ [Manicure] [Pedicure]          │ │
│ │ [Nail Art]                     │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ 👤 Michael Chen               │ │
│ │ 2 skills    35% Commission     │ │
│ │ [Massage Therapy]              │ │
│ │ [Facial Treatment]             │ │
│ └─────────────────────────────────┘ │
│ [+ Add Staff Member]                │
└─────────────────────────────────────┘
```

## 📁 Key Files & Their Purpose

| File | Purpose |
|------|---------|
| `mock_owner_data.dart` | Static data for all screens (bookings, services, staff) |
| `owner_dashboard_screen_enhanced.dart` | Enhanced dashboard with real UI and mock data |
| `owner_bookings_screen_enhanced.dart` | Bookings list with filtering and details |
| `owner_services_screen_enhanced.dart` | Service management interface |
| `owner_staff_screen_enhanced.dart` | Staff member management |

## 🔄 Data Flow Diagram

```
MockOwnerData (Static)
    ├── getDashboardSummary()
    │   ├── todayBookingsCount: 8
    │   ├── upcomingBookings: [5 bookings]
    │   ├── revenueSummary: {today, week, month}
    │   └── averageRating: 4.8
    │
    ├── getUpcomingBookings()
    │   └── [Next 5 bookings with full details]
    │
    ├── getAllBookings()
    │   └── [All bookings: past, current, cancelled]
    │
    ├── getServices()
    │   └── [8 services with pricing & duration]
    │
    └── getStaff()
        └── [5 staff members with skills & commission]
```

## 💾 Data Models

### Booking
```dart
{
  id: "booking_001",
  userId: "user_101",
  salonName: "Luxe Salon",
  serviceType: "Hair Cut",
  bookingDate: DateTime(2024, 1, 15, 10, 0),
  timeSlot: "10:00 AM - 11:00 AM",
  price: 45.00,
  status: "confirmed", // pending|confirmed|completed|cancelled
}
```

### Service
```dart
{
  id: "service_001",
  name: "Hair Cut",
  description: "Professional haircut with styling",
  price: 45.00,
  durationMinutes: 60,
  isEnabled: true,
}
```

### Staff Member
```dart
{
  id: "staff_001",
  name: "Sarah Johnson",
  avatarUrl: "https://...",
  skills: ["Hair Cut", "Hair Coloring", "Styling"],
  commissionRate: 0.30, // 30%
}
```

### Revenue Summary
```dart
{
  today: 450.00,
  thisWeek: 2850.50,
  thisMonth: 11200.75,
}
```

## 🎯 Statistics Available

```dart
{
  total_bookings: 32,
  completed_bookings: 28,
  cancelled_bookings: 2,
  pending_bookings: 2,
  total_revenue: 11200.75,
  avg_booking_value: 350.02,
  customer_count: 24,
  staff_count: 5,
  service_count: 8,
  avg_rating: 4.8,
  total_ratings: 28,
  booking_this_week: 15,
  booking_this_month: 32,
  occupancy_rate: 0.85, // 85%
}
```

## 🎨 Color Coding

| Status | Color | Icon |
|--------|-------|------|
| Confirmed | 🟢 Green (#22C55E) | ✓ check_circle |
| Pending | 🟠 Orange (#F97316) | ⏳ pending_actions |
| Completed | 🔵 Blue (#3B82F6) | ✓ task_alt |
| Cancelled | 🔴 Red (#EF4444) | ✗ cancel |
| Revenue | 💚 Green (#16A34A) | - |

## 🔗 How to Use Mock Data

### Option 1: Automatic (Fallback on Error)
The screens automatically use mock data if:
- User is not authenticated
- Supabase connection fails
- No data in database

### Option 2: Manual (Force Display)
Edit any provider and remove auth check:
```dart
final ownerBookingsProvider = StreamProvider.autoDispose<List<Booking>>((ref) async* {
  // Skip auth, just return mock data
  yield MockOwnerData.getAllBookings();
});
```

## 📱 Screen Navigation

```
Owner Shell (Bottom Navigation)
├── [Dashboard] → Shows overview & stats
├── [Bookings] → List with filters
├── [Services] → Manage offerings
├── [Staff] → Team management
└── [More] → Settings & earnings
```

## ⚙️ Quick Customization

### Change Sample Data
Edit `lib/features/owner/data/mock_owner_data.dart`:

```dart
// Example: Add more bookings
static List<Booking> getUpcomingBookings() {
  return [
    // Add your sample bookings here
  ];
}
```

### Change UI Colors
Look for `const Color(0xFFEAB308)` in enhanced screens and replace with your color.

### Change Fonts
Screens use `google_fonts` package:
- Headings: `GoogleFonts.outfit()`
- Body: `GoogleFonts.inter()`

## 📊 Sample Numbers

| Metric | Value |
|--------|-------|
| Today's Bookings | 8 |
| Upcoming Bookings | 5 |
| Total Bookings (Month) | 32 |
| Completed | 28 |
| Cancelled | 2 |
| Average Rating | 4.8/5 |
| Revenue Today | $450.00 |
| Revenue This Week | $2,850.50 |
| Revenue This Month | $11,200.75 |
| Services Offered | 8 |
| Active Services | 7 |
| Disabled Services | 1 |
| Staff Members | 5 |
| Customers | 24 |

## 🧪 Testing Checklist

- [ ] Dashboard displays with static data
- [ ] Bookings show all 4 statuses
- [ ] Services display correctly (active & disabled)
- [ ] Staff cards show avatars and skills
- [ ] Filter chips work on bookings screen
- [ ] Modal sheets open/close properly
- [ ] Revenue section updates correctly
- [ ] Quick actions respond to taps
- [ ] Empty states display when needed
- [ ] Error handling works smoothly

## 🔄 Switching Between Screens

To test enhanced vs original:

**Current (Enhanced with Mock Data):**
```dart
// In owner_shell.dart
import '../dashboard/owner_dashboard_screen_enhanced.dart';
```

**Original (Live Supabase):**
```dart
// In owner_shell.dart
import '../dashboard/owner_dashboard_screen.dart';
```

---

**Note:** All static data is in `MockOwnerData` class. Modify there to change what the UI displays. The enhanced screens automatically fall back to mock data when Supabase is unavailable.
