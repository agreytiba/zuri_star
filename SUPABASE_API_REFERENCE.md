# Supabase Integration - API Reference

## OwnerSupabaseService Class

Complete API reference for accessing Supabase data in the salon owner module.

### Initialization

```dart
// Get from provider
final service = ref.watch(ownerSupabaseServiceProvider);

// Or direct instantiation
final service = OwnerSupabaseService(client: SupabaseService.client);
```

---

## Dashboard Methods

### getDashboardSummary()
Returns complete dashboard statistics.

**Signature:**
```dart
Future<OwnerDashboardSummary> getDashboardSummary()
```

**Returns:**
```dart
OwnerDashboardSummary(
  todayBookings: 3,
  averageRating: 4.8,
  upcomingBookings: 5,
  monthlyRevenue: 2450.75,
  dailyRevenue: {
    '2026-01-09': 450.00,
    '2026-01-10': 320.50,
    // ... more dates
  },
  weeklyRevenue: {
    'Week 1': 1200.00,
    'Week 2': 1250.75,
    // ... more weeks
  }
)
```

**Example:**
```dart
final dashboard = await service.getDashboardSummary();
print('Today: ${dashboard.todayBookings} bookings');
print('Rating: ${dashboard.averageRating}/5');
print('Revenue: \$${dashboard.monthlyRevenue}');
```

---

## Bookings Methods

### getAllBookingsStream()
Stream all bookings in real-time.

**Signature:**
```dart
Stream<List<Booking>> getAllBookingsStream()
```

**Example:**
```dart
service.getAllBookingsStream().listen((bookings) {
  print('Total bookings: ${bookings.length}');
  for (var booking in bookings) {
    print('${booking.serviceName} - ${booking.status}');
  }
});
```

### getAllBookings()
Fetch all bookings once.

**Signature:**
```dart
Future<List<Booking>> getAllBookings()
```

**Example:**
```dart
final bookings = await service.getAllBookings();
final confirmed = bookings.where((b) => b.status == 'confirmed').length;
print('Confirmed: $confirmed');
```

### getUpcomingBookings({int days = 7})
Get bookings for next N days.

**Signature:**
```dart
Future<List<Booking>> getUpcomingBookings({int days = 7})
```

**Parameters:**
- `days` (int): Number of days in future to fetch (default: 7)

**Example:**
```dart
// Get next 14 days of bookings
final upcoming = await service.getUpcomingBookings(days: 14);
print('Upcoming 2 weeks: ${upcoming.length} bookings');
```

### updateBookingStatus(String bookingId, String status)
Update booking status.

**Signature:**
```dart
Future<void> updateBookingStatus(String bookingId, String status)
```

**Parameters:**
- `bookingId` (String): Booking ID
- `status` (String): New status ('pending', 'confirmed', 'completed', 'cancelled')

**Example:**
```dart
await service.updateBookingStatus(bookingId, 'confirmed');
print('Booking confirmed');
```

### updateBooking(String bookingId, Map<String, dynamic> updates)
Update any booking fields.

**Signature:**
```dart
Future<void> updateBooking(String bookingId, Map<String, dynamic> updates)
```

**Example:**
```dart
await service.updateBooking(bookingId, {
  'status': 'rescheduled',
  'booking_date': DateTime.now().add(Duration(days: 3)),
  'notes': 'Rescheduled due to weather',
});
```

---

## Services Methods

### getServicesStream()
Stream all services in real-time.

**Signature:**
```dart
Stream<List<OwnerService>> getServicesStream()
```

**Example:**
```dart
service.getServicesStream().listen((services) {
  final active = services.where((s) => s.isEnabled).length;
  print('Active services: $active');
});
```

### getServices()
Fetch all services once.

**Signature:**
```dart
Future<List<OwnerService>> getServices()
```

**Example:**
```dart
final services = await service.getServices();
final totalRevenue = services.fold<double>(0, (sum, s) => sum + s.price);
print('Total service value: \$${totalRevenue}');
```

### createService(Map<String, dynamic> serviceData)
Create new service.

**Signature:**
```dart
Future<OwnerService> createService(Map<String, dynamic> serviceData)
```

**Required Fields:**
- `name` (String): Service name
- `price` (double): Service price
- `duration_minutes` (int): Duration in minutes

**Optional Fields:**
- `description` (String): Service description
- `category` (String): Service category
- `image_url` (String): Service image

**Example:**
```dart
final newService = await service.createService({
  'name': 'Hair Cut',
  'description': 'Professional haircut with styling',
  'category': 'Hair',
  'price': 45.00,
  'duration_minutes': 60,
  'image_url': 'https://example.com/haircut.jpg',
});
print('Created: ${newService.name}');
```

### updateService(String serviceId, Map<String, dynamic> updates)
Update service details.

**Signature:**
```dart
Future<void> updateService(String serviceId, Map<String, dynamic> updates)
```

**Example:**
```dart
await service.updateService(serviceId, {
  'price': 50.00,
  'description': 'Premium haircut with scalp massage',
  'is_enabled': true,
});
```

### deleteService(String serviceId)
Delete service.

**Signature:**
```dart
Future<void> deleteService(String serviceId)
```

**Example:**
```dart
await service.deleteService(serviceId);
print('Service deleted');
```

---

## Staff Methods

### getStaffStream()
Stream all staff members in real-time.

**Signature:**
```dart
Stream<List<OwnerStaffMember>> getStaffStream()
```

**Example:**
```dart
service.getStaffStream().listen((staff) {
  print('Team size: ${staff.length}');
  for (var member in staff) {
    print('${member.name} - ${member.skills.join(", ")}');
  }
});
```

### getStaff()
Fetch all staff once.

**Signature:**
```dart
Future<List<OwnerStaffMember>> getStaff()
```

**Example:**
```dart
final staff = await service.getStaff();
final totalCommission = staff.fold<double>(0, 
  (sum, s) => sum + s.commissionRate
);
print('Avg commission: ${totalCommission / staff.length}%');
```

### createStaff(Map<String, dynamic> staffData)
Create new staff member.

**Signature:**
```dart
Future<OwnerStaffMember> createStaff(Map<String, dynamic> staffData)
```

**Required Fields:**
- `name` (String): Staff member name
- `commission_rate` (double): Commission percentage (0-100)
- `skills` (List<String>): Array of skill names

**Optional Fields:**
- `email` (String): Email address
- `phone` (String): Phone number
- `avatar_url` (String): Profile photo URL
- `hourly_rate` (double): Hourly rate

**Example:**
```dart
final newStaff = await service.createStaff({
  'name': 'Sarah Stylist',
  'email': 'sarah@salon.com',
  'phone': '555-0101',
  'avatar_url': 'https://example.com/sarah.jpg',
  'commission_rate': 30.0,
  'skills': ['Hair Cut', 'Hair Coloring', 'Styling'],
  'hourly_rate': 25.00,
});
print('Hired: ${newStaff.name}');
```

### updateStaff(String staffId, Map<String, dynamic> updates)
Update staff member.

**Signature:**
```dart
Future<void> updateStaff(String staffId, Map<String, dynamic> updates)
```

**Example:**
```dart
await service.updateStaff(staffId, {
  'commission_rate': 35.0,
  'skills': ['Hair Cut', 'Hair Coloring', 'Styling', 'Manicure'],
  'is_active': true,
});
```

### deleteStaff(String staffId)
Delete staff member.

**Signature:**
```dart
Future<void> deleteStaff(String staffId)
```

**Example:**
```dart
await service.deleteStaff(staffId);
print('Staff member removed');
```

---

## Revenue Methods

### getRevenueSummary()
Get detailed revenue breakdown.

**Signature:**
```dart
Future<RevenueSummary> getRevenueSummary()
```

**Returns:**
```dart
RevenueSummary(
  monthlyTotal: 11200.75,
  weeklyTotal: 2800.50,
  dailyTotal: 450.00,
  dailyBreakdown: {
    '2026-01-09': 450.00,
    '2026-01-08': 380.50,
    // ... all days of month
  },
  weeklyBreakdown: {
    'Week 1': 2200.00,
    'Week 2': 2500.75,
    'Week 3': 3200.00,
    'Week 4': 3300.00,
  }
)
```

**Example:**
```dart
final revenue = await service.getRevenueSummary();
print('This month: \$${revenue.monthlyTotal}');
print('Today: \$${revenue.dailyTotal}');
print('This week: \$${revenue.weeklyTotal}');
```

### recordEarning({required String bookingId, required double amount, String? description})
Record earnings from completed booking.

**Signature:**
```dart
Future<void> recordEarning({
  required String bookingId,
  required double amount,
  String? description,
})
```

**Parameters:**
- `bookingId` (String): Associated booking ID
- `amount` (double): Amount earned
- `description` (String, optional): Transaction description

**Example:**
```dart
await service.recordEarning(
  bookingId: bookingId,
  amount: 45.00,
  description: 'Hair cut service - Sarah Stylist',
);
```

---

## Reviews Methods

### getReviews()
Fetch all reviews for owner's salons.

**Signature:**
```dart
Future<List<Map<String, dynamic>>> getReviews()
```

**Example:**
```dart
final reviews = await service.getReviews();
final avgRating = reviews.fold<double>(0, (sum, r) => sum + r['rating']) / reviews.length;
print('Average rating: ${avgRating.toStringAsFixed(1)}/5');
```

---

## Error Handling

All methods throw exceptions on error. Use try-catch:

```dart
try {
  final bookings = await service.getAllBookings();
  // Use bookings
} on PostgrestException catch (e) {
  print('Database error: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

---

## Using with Riverpod

### In a Provider
```dart
final myProvider = FutureProvider((ref) async {
  final service = ref.watch(ownerSupabaseServiceProvider);
  return await service.getDashboardSummary();
});
```

### In a Widget
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(ownerDashboardSummaryProvider);
    
    return summary.when(
      loading: () => LoadingScreen(),
      error: (err, stack) => ErrorScreen(error: err),
      data: (summary) => DashboardContent(summary: summary),
    );
  }
}
```

---

## Real-time Updates Example

```dart
// Subscribe to bookings updates
service.getAllBookingsStream().listen(
  (bookings) {
    print('Bookings updated: ${bookings.length}');
    // UI rebuilds automatically with stream
  },
  onError: (e) {
    print('Error in bookings stream: $e');
    // Fall back to mock data
  },
);
```

---

## Performance Tips

1. **Use Streams for Real-time Data**
   - Use `getAllBookingsStream()` instead of polling
   - Automatic updates without manual refresh

2. **Limit Data Fetching**
   ```dart
   // Good - specific time range
   final upcoming = await service.getUpcomingBookings(days: 7);
   
   // Bad - fetches all bookings ever
   final all = await service.getAllBookings();
   ```

3. **Use Providers for Caching**
   - Providers cache results
   - Automatic invalidation on data changes
   - Avoids duplicate network requests

4. **Pagination for Large Lists**
   ```dart
   // Future enhancement - implement pagination
   const pageSize = 20;
   final page1 = await service.getAllBookings(); // limit(20)
   ```

---

## Fallback to Mock Data

If Supabase is unavailable:

```dart
try {
  final data = await service.getAllBookings();
} catch (e) {
  // Fall back to mock data
  final data = MockOwnerData.getAllBookings();
}
```

All providers automatically do this!

---

## Status Codes

| Status | Meaning | Next Action |
|--------|---------|------------|
| pending | Awaiting confirmation | Send reminder |
| confirmed | Confirmed by owner | Prepare resources |
| completed | Service delivered | Record earnings |
| cancelled | Booking cancelled | Free up slot |
| rescheduled | Moved to new time | Update schedule |

---

## Common Use Cases

### Get Today's Revenue
```dart
final revenue = await service.getRevenueSummary();
final today = revenue.dailyTotal;
```

### List All Confirmed Bookings
```dart
final bookings = await service.getAllBookings();
final confirmed = bookings.where((b) => b.status == 'confirmed').toList();
```

### Add New Service
```dart
await service.createService({
  'name': 'Manicure',
  'price': 30.00,
  'duration_minutes': 45,
});
```

### Update Staff Availability
```dart
await service.updateStaff(staffId, {
  'is_active': false,
  'skills': ['Hair Cut'], // Remove skills
});
```

### Record Service Payment
```dart
await service.recordEarning(
  bookingId: bookingId,
  amount: 45.00,
  description: 'Hair cut service',
);
```

---

## Debugging

Enable logging to debug queries:

```dart
// In Supabase client
SupabaseService.client.logLevel = LogLevel.debug;
```

Check logs in Supabase Console:
1. Go to Logs → Database
2. See all queries executed
3. Check for errors or slow queries

---

## Related Classes

### Booking
```dart
class Booking {
  final String id;
  final String serviceName;
  final String status;
  final DateTime bookingDate;
  final double price;
  // ... more fields
}
```

### OwnerService
```dart
class OwnerService {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final bool isEnabled;
}
```

### OwnerStaffMember
```dart
class OwnerStaffMember {
  final String id;
  final String name;
  final String? avatarUrl;
  final List<String> skills;
  final double commissionRate;
}
```

### RevenueSummary
```dart
class RevenueSummary {
  final double monthlyTotal;
  final double weeklyTotal;
  final double dailyTotal;
  final Map<String, double> dailyBreakdown;
  final Map<String, double> weeklyBreakdown;
}
```

---

**Last Updated:** January 2026
**Version:** 1.0
**Status:** Complete & Production Ready
