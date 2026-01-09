# Zuristar - Supabase Setup Guide

## 1. Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Create a new project
3. Note down your:
   - Project URL
   - Anon/Public Key

## 2. Update Flutter App

In `lib/main.dart`, replace the placeholder values:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

## 3. Run SQL Schema

In your Supabase Dashboard:
1. Go to SQL Editor
2. Copy and paste the contents of `supabase_schema.sql`
3. Run the query

This will:
- Create the `profiles` table
- Set up Row Level Security (RLS)
- Create a trigger to auto-create profiles on signup

## 4. Test the App

### Register as Customer:
1. Open the app
2. Navigate to Register
3. Fill in details
4. Select "Customer" as role
5. Register
6. You'll be redirected to Customer Home Page

### Register as Salon Owner:
1. Open the app
2. Navigate to Register
3. Fill in details
4. Select "Salon Owner" as role
5. Register
6. You'll be redirected to Salon Owner Dashboard

### Login:
1. Enter your email and password
2. The app will automatically redirect you based on your role:
   - **Customer** → Customer Home Page (with services, salons, etc.)
   - **Salon Owner** → Salon Owner Dashboard (with stats, bookings, etc.)

## 5. Role-Based Navigation

The app uses the `role` field from the `profiles` table to determine which screen to show after login:

- `customer` → `/role` → Customer Home Screen (via RoleRouter)
- `salon_owner` → `/role` → Salon Owner Dashboard (via RoleRouter)

The `/role` route uses `RoleRouter` to automatically determine which dashboard to show based on the user's role. The old `/salon-owner-home` route is automatically redirected to `/role` for backward compatibility.

## 6. Database Structure

```sql
profiles
├── id (uuid, references auth.users)
├── full_name (text)
├── email (text)
├── role (text: 'customer' | 'salon_owner')
└── created_at (timestamptz)
```

## 7. Security

- RLS is enabled on all tables
- Users can only read/update their own profile
- Auth is handled by Supabase Auth
- Passwords are securely hashed

## 8. Next Steps

- Add more salon-specific features
- Implement booking system
- Add real-time notifications
- Integrate payment gateway
