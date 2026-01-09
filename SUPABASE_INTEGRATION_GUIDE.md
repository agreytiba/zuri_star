# Zuri Star - Supabase Database Integration Guide

## Overview

This guide explains how the Zuri Star salon booking app connects to Supabase database and accesses real data on the salon owner dashboard.

## Database Schema

### Tables Created

#### 1. **Profiles Table**
- Stores user account information
- Fields: id, full_name, email, role (customer/salon_owner), avatar_url, created_at
- Auto-created on user signup via trigger

#### 2. **Salons Table**
- Represents salon businesses owned by users
- Fields: id, owner_id, name, description, address, city, state, phone, email, profile_image_url, cover_image_url, is_active, created_at, updated_at
- Key Index: owner_id

#### 3. **Services Table**
- Services offered by each salon
- Fields: id, salon_id, owner_id, name, description, category, price, duration_minutes, is_enabled, image_url, created_at, updated_at
- Key Indexes: salon_id, owner_id, is_enabled

#### 4. **Staff Table**
- Team members working at each salon
- Fields: id, salon_id, owner_id, name, email, phone, avatar_url, skills (array), commission_rate, hourly_rate, is_active, created_at, updated_at
- Key Indexes: salon_id, owner_id, is_active

#### 5. **Bookings Table**
- Customer bookings/appointments
- Fields: id, salon_id, owner_id, user_id, service_id, staff_id, salon_name, service_type, customer_name, customer_email, customer_phone, booking_date, time_slot, duration_minutes, price, status (pending/confirmed/completed/cancelled), is_instant_booking, notes, created_at, updated_at
- Key Indexes: salon_id, owner_id, user_id, status, booking_date
- Status Trigger: Automatically updates updated_at on change

#### 6. **Earnings Table**
- Revenue tracking for salon owners
- Fields: id, salon_id, owner_id, booking_id, amount, date, type (service/booking/refund), description, created_at
- Key Indexes: owner_id, salon_id, date
- Used for revenue summaries

#### 7. **Reviews Table**
- Customer reviews for salons
- Fields: id, salon_id, owner_id, user_id, booking_id, rating (1-5), comment, is_anonymous, is_verified, created_at, updated_at
- Key Indexes: salon_id, owner_id

#### 8. **Owner Profiles Table**
- Extended profile data for salon owners
- Fields: id, user_id, full_name, profile_image_url, bio, total_bookings_completed, total_earnings, average_rating, total_ratings, is_verified, created_at, updated_at
- Key Index: user_id

## Row Level Security (RLS)

All tables have Row Level Security enabled. Policies ensure:
- Users can only view/modify their own data
- Salon owners can only manage their own salons, services, and staff
- Public data (salons, reviews) is viewable by everyone
- Bookings are restricted to booking user and salon owner

## Architecture

### Service Layer: `OwnerSupabaseService`

Located in: `lib/features/owner/data/owner_supabase_service.dart`

Provides methods for:
- Dashboard summary
- Bookings management
- Services management
- Staff management
- Revenue tracking
- Reviews management

Example usage:
```dart
final service = OwnerSupabaseService(client: SupabaseService.client);
final dashboard = await service.getDashboardSummary();
final bookings = await service.getAllBookings();
```

### Provider Layer: `owner_providers.dart`

Located in: `lib/features/owner/providers/owner_providers.dart`

Riverpod providers that wrap the service:
- `ownerSupabaseServiceProvider` - Access to OwnerSupabaseService
- `ownerDashboardSummaryProvider` - FutureProvider for dashboard data
- `ownerBookingsProvider` - StreamProvider for real-time bookings
- `ownerServicesProvider` - StreamProvider for services
- `ownerStaffProvider` - StreamProvider for staff
- `ownerRevenueSummaryProvider` - Revenue data
- `ownerReviewsProvider` - Customer reviews

All providers have fallback to mock data if Supabase is unavailable.

### UI Layer: Enhanced Screens

#### Dashboard Screen
- File: `lib/features/owner/dashboard/owner_dashboard_screen_enhanced.dart`
- Displays:
  - Today's bookings count
  - Average rating
  - Upcoming bookings count
  - Monthly revenue
  - Revenue breakdown (daily, weekly)
  - Upcoming bookings list
  - Quick action buttons

#### Bookings Screen
- File: `lib/features/owner/bookings/owner_bookings_screen_enhanced.dart`
- Features:
  - All bookings with streaming updates
  - Filter by status (pending, confirmed, completed, cancelled)
  - Expandable booking details
  - Status color coding
  - Update booking status

#### Services Screen
- File: `lib/features/owner/services/owner_services_screen_enhanced.dart`
- Features:
  - Add new services
  - Edit existing services
  - View active/disabled services
  - Pricing management
  - Duration specification
  - Service search and filtering

#### Staff Screen
- File: `lib/features/owner/staff/owner_staff_screen_enhanced.dart`
- Features:
  - Add new staff members
  - Edit staff details
  - Manage skills (multi-select)
  - Commission rate tracking
  - Staff avatars and profiles

## Data Flow

```
User Interaction (UI Screen)
        ↓
    Provider (Riverpod)
        ↓
OwnerSupabaseService
        ↓
    Supabase Client
        ↓
   Supabase Backend
        ↓
PostgreSQL Database
```

With fallback:
```
If Supabase fails
        ↓
MockOwnerData (static data)
```

## Key Features

### Real-time Updates
- Services use `StreamProvider` for real-time data
- Bookings update automatically when changes occur
- Staff list updates in real-time

### Error Handling
- All methods wrapped in try-catch
- Automatic fallback to mock data on errors
- User-friendly error messages

### Authentication
- Owner can only access their own data
- User ID from `SupabaseService.client.auth.currentUser?.id`
- RLS enforces data isolation at database level

### Revenue Tracking
- Automatic earnings calculation
- Daily, weekly, and monthly breakdowns
- Integration with completed bookings

## Setup Instructions

### 1. Run Database Schema

1. Go to [Supabase Console](https://supabase.com)
2. Select your project
3. Go to SQL Editor
4. Copy entire content from `supabase_schema.sql`
5. Create new query and paste
6. Execute the query

### 2. Enable Email Templates (Optional)

For password reset and email confirmations:
1. Go to Authentication → Email Templates
2. Customize templates as needed

### 3. Configure Flutter App

The app automatically initializes Supabase in `main.dart`:
```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### 4. Test the Connection

1. Create a salon owner account
2. Create a salon in dashboard
3. Add services and staff
4. Create bookings via customer app
5. View data in enhanced screens

## Usage Examples

### Get Dashboard Summary
```dart
final supabaseService = ref.watch(ownerSupabaseServiceProvider);
final dashboard = await supabaseService.getDashboardSummary();
print('Today: ${dashboard.todayBookings} bookings');
print('Revenue: \$${dashboard.monthlyRevenue}');
```

### Stream Bookings
```dart
final bookingsAsync = ref.watch(ownerBookingsProvider);
bookingsAsync.whenData((bookings) {
  for (var booking in bookings) {
    print('${booking.serviceName} - ${booking.status}');
  }
});
```

### Update Booking Status
```dart
final service = ref.watch(ownerSupabaseServiceProvider);
await service.updateBookingStatus(bookingId, 'confirmed');
```

### Create Service
```dart
final service = ref.watch(ownerSupabaseServiceProvider);
await service.createService({
  'salon_id': salonId,
  'name': 'Hair Cut',
  'description': 'Professional haircut',
  'price': 45.0,
  'duration_minutes': 60,
});
```

### Record Earning
```dart
await service.recordEarning(
  bookingId: bookingId,
  amount: 45.0,
  description: 'Hair cut service',
);
```

## Database Triggers

### Auto-update Timestamps
- `salons` updated_at
- `services` updated_at
- `staff` updated_at
- `bookings` updated_at

### Auto-set Owner ID
- `bookings` owner_id set from salon_id
- `reviews` owner_id set from salon_id

## Performance Optimization

### Indexes
Database includes indexes on commonly queried fields:
- `owner_id` (all tables)
- `salon_id` (services, staff, bookings, reviews)
- `user_id` (bookings, reviews)
- `booking_date` (bookings)
- `date` (earnings)
- `status` (bookings)

### Pagination
For large datasets:
```dart
const pageSize = 20;
final response = await client
    .from('bookings')
    .select()
    .eq('owner_id', userId)
    .limit(pageSize)
    .offset(currentPage * pageSize);
```

## Troubleshooting

### Issue: "User not authenticated"
- Ensure user is logged in
- Check auth token in SupabaseService
- Verify RLS policies

### Issue: "No bookings showing"
- Check that salon is created
- Verify booking_date is in future
- Check RLS policies allow access

### Issue: "Slow queries"
- Add indexes to frequently queried fields
- Reduce LIMIT in queries
- Use pagination for large datasets

### Issue: "Data not updating"
- Check StreamProvider is watching correct data
- Verify updated_at triggers are active
- Check RLS policies for insert/update

## Migration Guide (From Mock to Real Data)

1. Ensure all screens import from `owner_providers.dart`
2. Replace mock data calls with provider watches
3. Test each screen with real Supabase data
4. Update error handling if needed
5. Monitor analytics for issues

## Future Enhancements

- [ ] Offline support with local caching
- [ ] Background sync for offline changes
- [ ] Push notifications for bookings
- [ ] Analytics dashboard
- [ ] Bulk operations
- [ ] Advanced filtering and search
- [ ] Recurring bookings
- [ ] Service packages

## Support

For issues or questions:
1. Check Supabase documentation: https://supabase.com/docs
2. Review error logs in Supabase console
3. Test queries in SQL editor
4. Check app logs in debug console

---

**Last Updated:** January 2026
**Version:** 1.0
**Status:** Production Ready
