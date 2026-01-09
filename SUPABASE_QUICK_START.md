# Quick Setup: Supabase Connection for Salon Owner Dashboard

## 🚀 Quick Start (5 Minutes)

### Step 1: Copy Database Schema
```bash
# The schema file is already created at:
# e:\zuriStar\supabase_schema.sql
```

### Step 2: Run Schema in Supabase
1. Go to https://supabase.com/dashboard
2. Select your Zuri Star project
3. Click **SQL Editor** → **New Query**
4. Open `supabase_schema.sql` from the project root
5. Copy entire content
6. Paste into SQL Editor
7. Click **Run** (or Ctrl+Enter)

### Step 3: Verify Tables Created
In Supabase Console:
- Go to **Table Editor**
- You should see these tables:
  - ✓ profiles (already exists)
  - ✓ salons
  - ✓ services
  - ✓ staff
  - ✓ bookings
  - ✓ earnings
  - ✓ reviews
  - ✓ owner_profiles

### Step 4: Create Test Owner Account
1. Open the app
2. Sign up as "Salon Owner"
3. Create a salon:
   - Name: "Test Salon"
   - Description: "Testing Supabase"
   - Phone: "555-0100"
   - Address: "123 Main St"

### Step 5: Add Test Data
**Services:**
1. Go to Services page
2. Click **Add Service**
3. Enter:
   - Name: "Hair Cut"
   - Price: 45.00
   - Duration: 60 minutes
4. Click Save

**Staff:**
1. Go to Staff page
2. Click **Add Staff**
3. Enter:
   - Name: "John Stylist"
   - Commission Rate: 30%
   - Skills: Select "Hair Cut"
4. Click Save

**Bookings:**
1. Create bookings via customer app, OR
2. Manually insert via SQL Editor:
```sql
INSERT INTO public.bookings (
  owner_id, salon_id, user_id, salon_name, service_type,
  customer_name, customer_email, customer_phone,
  booking_date, time_slot, duration_minutes, price, status
) VALUES (
  'OWNER_ID_HERE', 'SALON_ID_HERE', NULL,
  'Test Salon', 'Hair Cut',
  'Jane Customer', 'jane@example.com', '555-0200',
  NOW() + INTERVAL '2 days', '10:00 AM', 60, 45.00, 'pending'
);
```

### Step 6: View Real Data in Dashboard
1. Go to Owner Dashboard
2. See real data from Supabase:
   - Today's bookings count
   - Upcoming bookings
   - Monthly revenue
   - Average rating

## 📊 Dashboard Data Sources

### Dashboard Screen
- **Data Source:** `ownerDashboardSummaryProvider`
- **Shows:**
  - Today's bookings (from `bookings` table where date is today)
  - Average rating (from `reviews` table)
  - Upcoming bookings (from `bookings` where date is next 7 days)
  - Monthly revenue (from `earnings` table)

### Bookings Screen
- **Data Source:** `ownerBookingsProvider`
- **Shows:** All bookings with real-time streaming
- **Filters:** pending, confirmed, completed, cancelled

### Services Screen
- **Data Source:** `ownerServicesProvider`
- **Shows:** All services created by owner
- **Actions:** Add, edit, disable services

### Staff Screen
- **Data Source:** `ownerStaffProvider`
- **Shows:** All staff members with skills
- **Actions:** Add, edit, delete staff

## 🔄 Real-time Updates

The dashboard automatically updates when:
- ✓ New booking is created
- ✓ Booking status changes
- ✓ Revenue is recorded
- ✓ Service is added/edited
- ✓ Staff member is added/edited

No page refresh needed!

## 📝 File Structure

```
lib/features/owner/
├── data/
│   ├── mock_owner_data.dart          # Static demo data (fallback)
│   └── owner_supabase_service.dart   # Supabase API methods ✨ NEW
├── providers/
│   └── owner_providers.dart           # Riverpod providers ✨ NEW
├── dashboard/
│   └── owner_dashboard_screen_enhanced.dart  # Updated with DB integration
├── bookings/
│   └── owner_bookings_screen_enhanced.dart   # Updated with DB integration
├── services/
│   └── owner_services_screen_enhanced.dart   # Updated with DB integration
└── staff/
    └── owner_staff_screen_enhanced.dart      # Updated with DB integration
```

## 🛠️ Key Code Changes

### Before (Mock Data)
```dart
final ownerBookingsProvider = StreamProvider((ref) async* {
  yield MockOwnerData.getAllBookings(); // Static data
});
```

### After (Real Data)
```dart
final ownerBookingsProvider = StreamProvider((ref) async* {
  final service = ref.watch(ownerSupabaseServiceProvider);
  yield* service.getAllBookingsStream(); // Real Supabase data
});
```

### Fallback on Error
```dart
try {
  // Try real data
  yield* supabaseService.getAllBookingsStream();
} catch (_) {
  // Fall back to mock data if offline or error
  yield MockOwnerData.getAllBookings();
}
```

## ✅ Verification Checklist

- [ ] Schema SQL executed successfully
- [ ] 8 tables visible in Table Editor
- [ ] RLS policies enabled on all tables
- [ ] Test owner account created
- [ ] Test salon created
- [ ] Test service added
- [ ] Test staff member added
- [ ] Dashboard shows today's bookings
- [ ] Bookings screen shows real bookings
- [ ] Services screen shows real services
- [ ] Staff screen shows real staff members
- [ ] Filters work on bookings screen
- [ ] Real-time updates working (add booking and see it appear)

## 🐛 Common Issues & Fixes

### Issue: "Authentication required"
**Cause:** User not logged in
**Fix:** Log in with owner account first

### Issue: "No data showing"
**Cause:** No owner profile yet
**Fix:** Go through full owner signup flow

### Issue: "RLS policy violation"
**Cause:** User trying to access other owner's data
**Fix:** This is correct behavior - RLS protecting data

### Issue: "Slow loading"
**Cause:** Too much data or poor network
**Fix:** Uses pagination in queries or check internet

### Issue: "Mock data showing instead of real data"
**Cause:** Supabase not reachable or error occurred
**Fix:** Check internet, check Supabase is running, check logs

## 📚 Next Steps

1. ✅ Run schema (above)
2. ✅ Test with sample data
3. ✅ Customize table fields if needed
4. ✅ Add more business logic
5. ✅ Deploy to production

## 🔒 Security Notes

- All data is protected by RLS (Row Level Security)
- Users can only see their own data
- Salon owners can only manage their salons
- Database triggers prevent manual owner_id tampering
- JWT tokens validate user identity

## 📞 Support

- Supabase docs: https://supabase.com/docs
- Riverpod guide: https://riverpod.dev
- Flutter networking: https://flutter.dev/docs/cookbook/networking

---

**Status:** ✅ Ready to Use
**Last Updated:** January 2026
**Version:** 1.0
