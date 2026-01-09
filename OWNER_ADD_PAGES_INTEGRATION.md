# How to Add Navigation Buttons to Services & Staff Screens

## Quick Integration Guide

### 1. Update Services Screen

In `lib/features/owner/services/owner_services_screen_enhanced.dart`, add import at top:

```dart
import '../pages/owner_add_service_page.dart';
```

Then update the AppBar to include an add button:

```dart
AppBar(
  title: Text(
    'Services',
    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
  ),
  elevation: 0,
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  actions: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const OwnerAddServicePage(),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.black),
        label: Text(
          'Add',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEAB308),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    ),
  ],
),
```

---

### 2. Update Staff Screen

In `lib/features/owner/staff/owner_staff_screen_enhanced.dart`, add import at top:

```dart
import '../pages/owner_add_staff_page.dart';
```

Then add a floating action button to the Scaffold:

```dart
Scaffold(
  appBar: AppBar(
    title: Text(
      'Staff',
      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
    ),
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  floatingActionButton: FloatingActionButton.extended(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const OwnerAddStaffPage(),
        ),
      );
    },
    backgroundColor: const Color(0xFFEAB308),
    icon: const Icon(Icons.add, color: Colors.black),
    label: Text(
      'Add Staff',
      style: GoogleFonts.outfit(
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
  ),
  body: // ... rest of body
)
```

---

## Alternative: Using FloatingActionButton for Services

If you prefer a floating button instead of AppBar button for services:

```dart
Scaffold(
  appBar: AppBar(
    title: Text(
      'Services',
      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
    ),
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const OwnerAddServicePage(),
        ),
      );
    },
    backgroundColor: const Color(0xFFEAB308),
    child: const Icon(Icons.add, color: Colors.black),
  ),
  body: // ... rest of body
)
```

---

## Using Router (If App Uses GoRouter)

If your app uses GoRouter for navigation:

**Add to router configuration:**
```dart
GoRoute(
  path: '/owner/services/add',
  builder: (context, state) => const OwnerAddServicePage(),
),
GoRoute(
  path: '/owner/staff/add',
  builder: (context, state) => const OwnerAddStaffPage(),
),
```

**Navigate using:**
```dart
// Add Service
context.go('/owner/services/add');

// Add Staff
context.go('/owner/staff/add');
```

---

## File Structure After Updates

```
lib/features/owner/
├── pages/                                    # ✨ NEW FOLDER
│   ├── owner_add_service_page.dart          # ✨ NEW
│   └── owner_add_staff_page.dart            # ✨ NEW
│
├── services/
│   └── owner_services_screen_enhanced.dart  # ✏️ ADD IMPORT + BUTTON
│
├── staff/
│   └── owner_staff_screen_enhanced.dart     # ✏️ ADD IMPORT + FAB
│
└── ... (other existing files)
```

---

## Testing the Integration

### Test Add Service Flow:
1. Open app and navigate to Services screen
2. Click "Add" button in AppBar
3. Fill in service details:
   - Name: "Pedicure"
   - Category: "Nails"
   - Price: "35.00"
   - Duration: "45"
4. Click "Add Service"
5. See success message
6. Verify new service appears in services list
7. Check Supabase table to confirm data saved

### Test Add Staff Flow:
1. Open app and navigate to Staff screen
2. Click floating action button
3. Fill in staff details:
   - Name: "Sarah"
   - Email: "sarah@salon.com"
   - Commission: "25"
   - Select skills: "Manicure", "Pedicure", "Nail Art"
4. Click "Add Staff Member"
5. See success message
6. Verify new staff appears in staff list
7. Check Supabase table to confirm data saved

---

## UI/UX Considerations

### Services Screen Add Button
✓ Located in AppBar for discoverability
✓ Yellow primary color matches brand
✓ Icon + text for clarity
✓ Always visible (not scrolled away)
✓ Easy one-tap access

### Staff Screen Add Button
✓ Floating action button (FAB)
✓ Prominent placement in corner
✓ Extended FAB with label for clarity
✓ Yellow primary color matches brand
✓ Standard Material Design pattern

---

## Response to User Actions

### After Successful Submit
```
1. Loading spinner shows during submission
2. Success SnackBar appears (green, 2 seconds)
3. User auto-navigates back to list
4. List updates with new item
5. No manual refresh needed (real-time streams)
```

### After Cancel
```
1. User goes back to previous screen
2. Form data is discarded
3. No database changes made
4. List unchanged
```

### After Error
```
1. Loading stops
2. Red SnackBar shows error message
3. User stays on form
4. Can retry after fixing issue
5. All form data preserved
```

---

## Mobile Responsiveness

Both pages are mobile-friendly:
- Form fields expand full width (with padding)
- Text inputs have adequate size for mobile keyboards
- Buttons are 56px height (standard touch target)
- Form scrolls if content exceeds screen
- Responsive padding for different screen sizes

---

## Accessibility

Both pages include:
- Form labels for all inputs
- Input validation with error messages
- Adequate color contrast
- Touch targets ≥48x48dp
- Clear success/error feedback
- Keyboard navigation support

---

## Performance Notes

- Pages load instantly (no heavy async operations)
- Minimal dependencies (Supabase client + Riverpod)
- Form submission is fast (<1s typical)
- No image processing (can be added later)
- Efficient validation on input

---

## Customization Options

### Change Button Text
```dart
// Services
label: Text('New Service'), // Instead of 'Add'

// Staff
label: Text('Hire Staff'), // Instead of 'Add Staff'
```

### Change Button Color
```dart
backgroundColor: Colors.blue, // Or any color
icon: const Icon(Icons.person_add), // Different icon
```

### Add to Different Location
```dart
// Bottom app bar
bottomNavigationBar: BottomAppBar(
  child: ElevatedButton(
    onPressed: () => Navigator.push(...),
    child: const Text('Add Service'),
  ),
)
```

---

## Common Issues & Solutions

### Issue: "Page not found" error
**Solution:** Ensure pages are in correct path:
- `lib/features/owner/pages/owner_add_service_page.dart`
- `lib/features/owner/pages/owner_add_staff_page.dart`

### Issue: Import error
**Solution:** Add correct import:
```dart
import '../pages/owner_add_service_page.dart';
// NOT
import 'owner_add_service_page.dart'; // Wrong path
```

### Issue: Button not showing
**Solution:** Check if AppBar `actions` or `floatingActionButton` is defined correctly

### Issue: Form not submitting
**Solution:** Check:
1. Supabase is connected
2. User is authenticated
3. Network connection is available
4. Form validation passes (no red errors)

---

## Complete Code Example (Services Screen Update)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/owner_add_service_page.dart'; // ✨ ADD THIS
import '../providers/owner_providers.dart';

class OwnerServicesScreen extends ConsumerWidget {
  const OwnerServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(ownerServicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Services',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OwnerAddServicePage(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.black),
              label: Text(
                'Add',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAB308),
              ),
            ),
          ),
        ],
      ),
      body: servicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Text('No services yet. Tap Add to create one!'),
            );
          }
          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return ListTile(
                title: Text(service.name),
                subtitle: Text('\$${service.price}'),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

## Summary

✅ Two new dedicated pages created
✅ Easy navigation integration
✅ Multiple button placement options
✅ Full form validation
✅ Supabase integration
✅ Real-time list updates
✅ Mobile responsive
✅ Production ready

---

**Last Updated:** January 2026
**Status:** Ready for Integration
