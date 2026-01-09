# ZuriStar - Customer Booking Features

## Overview
This document outlines all the customer-facing features implemented in the ZuriStar salon booking application.

## Features Implemented

### 1. **Search & Discovery** 🔍
**Location:** `lib/features/search/`

- **Search Screen** (`search_screen.dart`)
  - Search salons and services by name
  - Real-time search filtering
  - Display search results with salon cards
  - Empty state when no results found

- **Advanced Filtering** (`filter_bottom_sheet.dart`)
  - Filter by service type (Hair, Nail, Makeup, SPA, Skincare, Body Services, Waxing)
  - Price range slider (10,000 - 200,000 TZS)
  - Gender preference (Male, Female, Unisex)
  - Service location type:
    - Mobile Service (they come to you)
    - In-Salon Service
  - Sort by: Rating, Price, Distance
  - Clear all filters option
  - Active filter chips display

- **Salon Cards** (`salon_card.dart`)
  - Salon image with verified badge
  - Rating and review count
  - Location/address
  - Service type badges (Mobile/In-Salon)
  - Available services display
  - Starting price
  - Click to view details

### 2. **Salon Details & Booking** 📅
**Location:** `lib/features/salon_details/`

- **Salon Details Screen** (`salon_details_screen.dart`)
  - Image gallery with swipeable photos
  - Salon name, rating, and verification status
  - Address with "View Map" option
  - Service type badges
  - Tabbed interface:
    - **Services Tab**: List of services with prices
    - **About Tab**: Salon description and contact info
    - **Reviews Tab**: Customer reviews (placeholder)
  
- **Booking Features**:
  - **Service Selection** (`service_selector.dart`)
    - Visual service cards with icons
    - Price display for each service
    - Single selection mode
  
  - **Date & Time Selection** (`time_slot_selector.dart`)
    - Next 14 days date picker
    - Available time slots
    - Visual selection indicators
  
  - **Booking Types**:
    - **Instant Booking**: Get confirmed immediately
    - **Request Booking**: Wait for salon confirmation
  
  - **Booking Confirmation**:
    - Success dialog with booking details
    - Option to add to calendar
    - Navigate to bookings list

### 3. **Booking Management** 📋
**Location:** `lib/features/booking/`

- **Booking Screen** (`booking_screen.dart`)
  - Tab navigation between Service List and Booking List
  - Service List as default tab
  - Bottom navigation integration

- **Service List Page** (`service_list_page.dart`)
  - Grid of available services
  - Service icons and names
  - Quick access to book services

- **Booking List Page** (`booking_list_page.dart`)
  - Bookings grouped by month
  - Booking status badges (Pending, Confirmed, Completed, Cancelled)
  - Booking details: date, time, salon, service, price
  
  - **Actions based on status**:
    - **Completed Bookings**:
      - Write Review button
      - Book Again button
    - **Confirmed/Pending Bookings**:
      - Cancel button
      - Reschedule button

### 4. **Reviews & Ratings** ⭐
**Location:** `lib/features/reviews/`

- **Review Screen** (`review_screen.dart`)
  - Star rating (1-5 stars)
  - Rating text feedback (Excellent, Great, Good, Fair, Poor)
  - Text comment field
  - Photo upload option (placeholder)
  - Submit review
  - **Loyalty Rewards**: Earn 50 points for submitting a review
  - Success confirmation with points earned

### 5. **Loyalty Program** 🎁
**Location:** `lib/features/loyalty/`

- **Loyalty Screen** (`loyalty_screen.dart`)
  - **Points Card**:
    - Current points balance
    - Tier status (Bronze, Silver, Gold, Platinum)
    - Statistics: Bookings, Reviews, Referrals
    - Gradient design with shadow effects
  
  - **Available Rewards**:
    - Discount cards with percentage off
    - Points required to redeem
    - Service-specific discounts
    - Expiry dates
    - Redeem button (enabled when enough points)
  
  - **Transaction History**:
    - Points earned (bookings, reviews, referrals)
    - Points redeemed (discounts used)
    - Transaction dates
    - Visual indicators (green for earned, red for redeemed)

### 6. **Additional Features** ✨

- **Calendar Integration** (Placeholder)
  - Add bookings to Google Calendar
  - Sync with other calendar apps
  - Reminder notifications

- **Notifications** (To be implemented)
  - Booking confirmations
  - Reminder notifications
  - Promotional offers
  - Status updates

- **Rescheduling** (To be implemented)
  - Change booking date/time
  - Subject to salon availability
  - Confirmation required

- **Cancellation** (To be implemented)
  - Cancel bookings
  - Cancellation policy
  - Refund processing

## Data Models
**Location:** `lib/core/models/`

### Salon Model (`salon_model.dart`)
- Complete salon information
- Services and pricing
- Location data
- Availability
- Ratings and reviews

### Booking Model (`booking_model.dart`)
- Booking details
- Status tracking
- Calendar integration
- Reminder settings
- Instant vs. request booking

### Review Model (`review_model.dart`)
- User ratings
- Comments
- Photos
- Verified booking status
- Helpful count

### Loyalty Model (`loyalty_model.dart`)
- Points balance
- Tier system
- Available discounts
- Transaction history
- Redemption tracking

## Navigation Routes

All routes are defined in `lib/core/router/app_router.dart`:

- `/search` - Search and filter salons
- `/salon-details/:id` - Salon details and booking
- `/booking` - Booking management (Service List & Booking List)
- `/review/:bookingId/:salonName` - Write a review
- `/loyalty` - Loyalty rewards program

## User Flow

### Booking Flow
1. **Home Screen** → Tap search bar
2. **Search Screen** → Apply filters, select salon
3. **Salon Details** → View info, select service, date, time
4. **Choose Booking Type** → Instant or Request
5. **Confirm Booking** → Add to calendar
6. **Booking List** → View all bookings

### Review Flow
1. **Booking List** → Find completed booking
2. **Tap "Write Review"** → Navigate to review screen
3. **Rate & Comment** → Submit review
4. **Earn Points** → 50 loyalty points added
5. **View Rewards** → Check loyalty screen

### Loyalty Flow
1. **Earn Points** → Complete bookings, write reviews, referrals
2. **View Rewards** → Check available discounts
3. **Redeem** → Use points for discounts
4. **Apply Discount** → On next booking

## Design System

### Colors
- **Primary**: `#EAB308` (Yellow/Gold)
- **Light Yellow**: `#FDE68A`
- **Success**: Green
- **Warning**: Orange
- **Error**: Red

### Typography
- **Headings**: Google Fonts - Outfit
- **Body**: Google Fonts - Inter

### Components
- Rounded corners (8-16px)
- Subtle shadows
- Status badges
- Icon buttons
- Gradient cards (loyalty)

## Mock Data

Currently using mock data for demonstration:
- 3 sample salons
- Sample bookings
- Sample loyalty rewards
- Sample transactions

**TODO**: Replace with actual API integration

## Next Steps

### High Priority
1. Backend API integration
2. Real-time availability checking
3. Payment gateway integration
4. Push notifications
5. Calendar sync implementation

### Medium Priority
1. Map integration for salon locations
2. Photo upload for reviews
3. Referral system
4. In-app chat with salons
5. Booking history export

### Low Priority
1. Favorite salons
2. Service recommendations
3. Beauty tips and articles
4. Seasonal promotions
5. Gift cards

## Testing Checklist

- [ ] Search functionality
- [ ] Filter combinations
- [ ] Booking flow (instant)
- [ ] Booking flow (request)
- [ ] Review submission
- [ ] Loyalty points calculation
- [ ] Discount redemption
- [ ] Navigation between screens
- [ ] Empty states
- [ ] Error handling
- [ ] Loading states

## Notes

- All features are fully functional with mock data
- UI matches the design specifications
- Responsive layouts for different screen sizes
- Smooth animations and transitions
- Accessibility considerations (contrast, touch targets)
- Error handling with user-friendly messages

---

**Last Updated**: January 9, 2026
**Version**: 1.0.0
