# 🎬 Demo Script - Salon Owner Dashboard

## How to Run the Demo

This script shows how to run and interact with the Zuri Star salon owner dashboard with static data.

---

## 🚀 Step 1: Prepare the Project

```bash
# Navigate to project directory
cd e:\zuriStar

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run the app
flutter run
```

**Expected Result:** App launches and shows home/login screen

---

## 🎯 Step 2: Navigate to Owner Dashboard

### Scenario A: If You Have Owner Account
1. Login with owner credentials
2. App auto-routes to owner dashboard
3. See dashboard with mock data

### Scenario B: If You Don't Have Account
1. Look for role/mode selection
2. Select "Owner" role
3. You'll see the dashboard (or a login first)

### Scenario C: Force Mock Data View
Edit `lib/features/owner/presentation/owner_shell.dart`:
```dart
// First, update imports to use enhanced versions
import '../dashboard/owner_dashboard_screen_enhanced.dart';
import '../bookings/owner_bookings_screen_enhanced.dart';
import '../services/owner_services_screen_enhanced.dart';
import '../staff/owner_staff_screen_enhanced.dart';

// Then run
flutter run
```

---

## 📊 Step 3: Explore Dashboard Screen

### What You'll See
```
┌─────────────────────────────────┐
│ Good morning!                   │
│ Here's your overview...         │
├─────────────────────────────────┤
│ [8 Bookings] [4.8 Rating]       │
│ [5 Upcoming] [$11,200 Revenue]  │
├─────────────────────────────────┤
│ Revenue: $450 | $2,850 | $11,200│
├─────────────────────────────────┤
│ Upcoming Bookings (5):          │
│ • Hair Cut - 10:00 AM - $45     │
│ • Manicure - 1:00 PM - $35      │
│ • Facial - 3:00 PM - $65        │
│ [And 2 more...]                 │
├─────────────────────────────────┤
│ Quick Actions:                  │
│ [Create Salon] [Add Service]    │
│ [View Calendar] [Manage Staff]  │
└─────────────────────────────────┘
```

### Interactive Elements to Try
1. **Tap on a booking** → See detailed sheet
2. **Pull down** → Refresh dashboard
3. **Tap quick action chips** → See toast notification
4. **Scroll down** → See all content

---

## 📋 Step 4: Explore Bookings Tab

### Navigation
- Dashboard (Tab 1) → **Bookings (Tab 2)** ← Click here

### What You'll See
```
Filter Chips: [All] [Pending] [Confirmed] [Completed] [Cancelled]

Booking List:
├─ Hair Cut • Luxe Salon
│  2024-01-15 • 10:00 AM • $45
│  [✓ CONFIRMED] ← Status badge
│
├─ Manicure • Luxe Salon
│  2024-01-15 • 1:00 PM • $35
│  [⏳ PENDING] ← Status badge
│
└─ ... more bookings
```

### Demo Actions
1. **Click filter chip** "Pending" → Shows only pending bookings
2. **Click filter chip** "Completed" → Shows completed bookings
3. **Tap a booking card** → See full details:
   ```
   Service:      Hair Cut
   Date:         2024-01-15
   Time:         10:00 AM - 11:00 AM
   Price:        $45.00
   Status:       CONFIRMED
   Notes:        Customer wants fade with line design
   [Close] [Take Action]
   ```
4. **Pull down** → Refresh the list
5. **Try all filter combinations** → Notice how list changes

---

## 🛠️ Step 5: Explore Services Tab

### Navigation
- Bookings (Tab 2) → **Services (Tab 3)** ← Click here

### What You'll See
```
ACTIVE SERVICES
├─ Hair Cut
│  Professional haircut and styling
│  Price: $45.00 | Duration: 60 min
│  [Edit] [⋮]
│
├─ Hair Coloring
│  Full color with highlights
│  Price: $85.00 | Duration: 120 min
│  [Edit] [⋮]
│
└─ ... 5 more active services

DISABLED SERVICES
├─ Waxing [DISABLED]
│  Full body waxing services
│  Price: $30.00 | Duration: 30 min
│  [Edit] [⋮]
```

### Demo Actions
1. **Tap [Edit] button** → Opens form:
   ```
   Service Name: Hair Cut
   Description:  Professional haircut...
   Price:        45.00
   Duration:     60
   [Save Changes] [Cancel]
   ```
2. **Modify values** and tap Save → Shows toast
3. **Tap [+] button** (top right) → Add new service form
4. **Scroll down** → See both active and disabled sections

---

## 👥 Step 6: Explore Staff Tab

### Navigation
- Services (Tab 3) → **Staff (Tab 4)** ← Click here

### What You'll See
```
Staff Members:
├─ 👤 Sarah Johnson
│  5 skills        30% Commission
│  [Hair Cut] [Hair Coloring] [Styling]
│
├─ 👤 Emma Wilson
│  3 skills        25% Commission
│  [Manicure] [Pedicure] [Nail Art]
│
├─ 👤 Michael Chen
│  2 skills        35% Commission
│  [Massage Therapy] [Facial Treatment]
│
└─ ... 2 more staff members
```

### Demo Actions
1. **Tap a staff card** → See details:
   ```
   [Avatar]
   Sarah Johnson
   
   Commission Rate
   30%
   
   Skills
   [Hair Cut] [Hair Coloring] [Styling]
   
   [Close] [Edit]
   ```
2. **Tap [Edit]** → Edit form opens:
   ```
   Full Name:        Sarah Johnson
   Commission Rate:  30
   
   Skills (Select):
   [✓ Hair Cut] [✓ Hair Coloring] [✓ Styling]
   [Manicure] [Pedicure] [Nail Art]
   ... more skills
   
   [Save Changes] [Cancel]
   ```
3. **Tap [+] button** → Add new staff member
4. **Select/deselect skills** to see multi-select work

---

## ✨ Step 7: Test All Interactions

### Dashboard
- [ ] Greeting changes based on time
- [ ] All 4 stat cards visible
- [ ] Revenue section shows breakdown
- [ ] Upcoming bookings list shows items
- [ ] Quick action chips present
- [ ] Pull to refresh works
- [ ] Numbers are realistic

### Bookings
- [ ] All filter chips work
- [ ] List updates when filtering
- [ ] Status colors are correct
  - 🟢 Green = Confirmed
  - 🟠 Orange = Pending
  - 🔵 Blue = Completed
  - 🔴 Red = Cancelled
- [ ] Tap booking shows details
- [ ] Details sheet scrollable
- [ ] Modal closes properly

### Services
- [ ] Active services section visible
- [ ] Disabled services section visible
- [ ] Prices and durations shown
- [ ] Edit button works
- [ ] Form modal opens/closes
- [ ] Add button works
- [ ] All 8 services present

### Staff
- [ ] Staff cards show avatars
- [ ] Names visible
- [ ] Commission rates shown
- [ ] Skills displayed as chips
- [ ] Tap card shows details
- [ ] Edit form has all fields
- [ ] Skills selection works
- [ ] All 5 members present

---

## 📊 Step 8: Verify Sample Data

### Dashboard Numbers
```
✓ Today's Bookings:      8
✓ Upcoming:              5
✓ Rating:                4.8/5
✓ Revenue Today:         $450.00
✓ Revenue This Week:     $2,850.50
✓ Revenue This Month:    $11,200.75
```

### Bookings
```
✓ Total Bookings:        13
✓ Confirmed Status:      Multiple items
✓ Pending Status:        Multiple items
✓ Completed Status:      Multiple items
✓ Cancelled Status:      Multiple items
```

### Services
```
✓ Total Services:        8
✓ Active Services:       7
✓ Disabled Services:     1
✓ Price Range:           $15-$85
✓ Duration Range:        15-120 min
```

### Staff
```
✓ Total Members:         5
✓ Avatar URLs:           All working
✓ Skills per Member:     2-5 skills
✓ Commission Range:      25-35%
```

---

## 🎯 Step 9: Test Error Scenarios

### Scenario 1: No Authentication
1. Don't login to the app
2. Navigate to owner dashboard
3. **Expected:** Mock data displays anyway

### Scenario 2: Supabase Unavailable
1. Disconnect internet (airplane mode)
2. Try to refresh dashboard
3. **Expected:** Shows mock data, no error

### Scenario 3: Empty States
- All filters show data (no empty state)
- All sections populated

---

## 💡 Step 10: Customization Demo

### Change Service Price
1. Open `lib/features/owner/data/mock_owner_data.dart`
2. Find: `price: 45.00,` (Hair Cut)
3. Change to: `price: 55.00,`
4. Save and hot-reload (`R` in terminal)
5. Navigate to Services tab
6. **See:** Hair Cut now shows $55.00

### Add New Booking
1. In same file, find `getUpcomingBookings()`
2. Add new Booking object:
```dart
Booking(
  id: 'booking_new',
  serviceType: 'Haircut Special',
  price: 99.99,
  // ... fill other required fields
),
```
3. Hot-reload
4. Navigate to Bookings or Dashboard
5. **See:** New booking appears

### Change Staff Member Name
1. Find staff member in `getStaff()`
2. Change: `name: 'Sarah Johnson',` to `name: 'Sarah Smith',`
3. Hot-reload
4. Navigate to Staff tab
5. **See:** Name updated immediately

---

## 🎬 Demo Talking Points

### For Stakeholders
- "This is how the owner sees their dashboard"
- "All data is realistic and immediately available"
- "No need for database setup - perfect for testing"
- "Easy to customize for different scenarios"

### For Developers
- "All UI is production-ready"
- "Error handling with fallback to mock data"
- "Single source of truth for test data"
- "Easy to integrate with real Supabase later"

### For Designers
- "Color-coded status indicators for clarity"
- "Card-based layout for easy scanning"
- "Modal sheets for detailed views"
- "Responsive spacing and typography"

---

## 📹 Recording Tips

If you want to record a demo:

### Good Angles
1. **Dashboard Overview** - Show all 4 stat cards
2. **Bookings Filtering** - Switch between filters
3. **Service Details** - Tap Edit to show form
4. **Staff Member** - Show avatar and skills
5. **Revenue Breakdown** - Highlight the numbers

### Good Actions
1. Swipe refresh on dashboard
2. Filter bookings by status
3. Open booking details
4. Edit a service
5. View staff member details

### Talk Track
```
"The owner logs in and sees the dashboard with:
- Today's key metrics (bookings, rating, revenue)
- Revenue breakdown for different periods
- Upcoming bookings that need attention
- Quick actions for common tasks

They can view bookings filtered by status,
manage their service offerings,
and see their team members and their rates."
```

---

## ✅ Demo Checklist

- [ ] App launches successfully
- [ ] Owner dashboard displays
- [ ] All 4 tabs visible and clickable
- [ ] Dashboard shows correct metrics
- [ ] Bookings filter works
- [ ] Status colors are correct
- [ ] Services show pricing
- [ ] Staff shows avatars
- [ ] All interactive elements respond
- [ ] No errors in console
- [ ] Mock data is realistic
- [ ] UI looks professional

---

## 🎉 Success Criteria

You've successfully demoed the owner dashboard when:
1. ✅ All screens load without errors
2. ✅ Mock data displays realistically
3. ✅ All interactions work smoothly
4. ✅ Colors and layout look professional
5. ✅ You can customize sample data
6. ✅ Stakeholders understand the feature set

---

## 🔗 Quick Navigation

- **Source Data:** `lib/features/owner/data/mock_owner_data.dart`
- **Dashboard:** `lib/features/owner/dashboard/owner_dashboard_screen_enhanced.dart`
- **Bookings:** `lib/features/owner/bookings/owner_bookings_screen_enhanced.dart`
- **Services:** `lib/features/owner/services/owner_services_screen_enhanced.dart`
- **Staff:** `lib/features/owner/staff/owner_staff_screen_enhanced.dart`

---

## 🎓 What To Mention

When presenting:
- "Built with Flutter and Riverpod"
- "Uses realistic mock data for demonstration"
- "Error handling with graceful fallback"
- "Professional UI with proper color coding"
- "Easy to customize for different scenarios"
- "Ready for integration with Supabase"

---

Happy demoing! The enhanced screens with mock data provide a complete working example of how the salon owner interface functions. 🚀
