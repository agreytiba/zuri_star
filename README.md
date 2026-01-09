## Zuri Star

Zuri Star is a Flutter app for salon discovery and booking, built with Riverpod, Supabase, and a clean architecture-style feature structure.

### Role-based Experience

The app now supports **two primary roles**, backed by the `role` field in the Supabase `profiles` table:

- `customer` – standard customer booking experience
- `salon_owner` – dedicated owner module with management tools

On login / register:

1. Supabase Auth authenticates the user.
2. The app loads the profile from `public.profiles` (see `supabase_schema.sql`).
3. The `role` is stored on `UserEntity.role` and exposed via `authProvider`.
4. `RoleRouter` (in `lib/core/role/role_router.dart`) decides which shell to show:
   - `customer` → customer app (`HomeScreen`, existing customer flows)
   - `salon_owner` → owner shell (`OwnerShell` with dashboard, bookings, services, staff, more)
   - any other / missing role → Unauthorized role screen

### Navigation

- The global router is defined in `lib/core/router/app_router.dart` using `go_router`.
- After authentication, the router redirects to `/role`, which renders `RoleRouter`.
- Customer routes (e.g. `/home`, `/booking`, `/search`) are **unchanged**.
- Salon owners get a separate bottom-navigation based shell implemented in `lib/features/owner/presentation/owner_shell.dart` with tabs:
  - Dashboard
  - Bookings
  - Services
  - Staff
  - More (earnings, reviews, business settings, logout)

### Salon Owner Module

The owner module lives under `lib/features/owner` and is split into feature areas:

- `dashboard` – high-level KPIs (today bookings, upcoming bookings, revenue summary, average rating) powered by Supabase queries filtered by `owner_id`.
- `bookings` – real-time bookings list, with actions to confirm, reschedule (placeholder), and cancel bookings.
- `services` – CRUD for services (add / edit / delete, price, duration, enable / disable).
- `staff` – basic staff management (add staff, assign skills, commission rate).
- `settings` – “More” tab: owner profile summary, entry points to earnings, reviews, business settings, plus logout.

All Supabase access for the owner module respects row-level security (RLS) by always filtering using the authenticated owner’s id (e.g. `eq('owner_id', user.id)`), so owners only see and update their own salons, services, staff, bookings, and related data.

### Tech Stack

- Flutter (latest stable)
- `flutter_riverpod` for state management
- `go_router` for navigation
- `supabase_flutter` for backend (auth, database, real-time)
- `dio` for HTTP where needed
- `hive` / `flutter_secure_storage` for local storage
- `google_fonts` and custom widgets for consistent UI

