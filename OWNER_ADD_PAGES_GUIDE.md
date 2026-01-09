# Owner Add Pages - Navigation Guide

## New Pages Created

### 1. Add Service Page (`owner_add_service_page.dart`)
Complete full-page screen for adding new salon services.

**Location:** `lib/features/owner/pages/owner_add_service_page.dart`

**Features:**
- Form with validation
- Service name input (3+ characters required)
- Category dropdown (Hair, Nails, Skincare, Massage, Other)
- Description textarea
- Price input (decimal validation)
- Duration input in minutes (1-480 min, max 8 hours)
- Real-time submission to Supabase
- Success/error feedback with SnackBar
- Cancel/Save buttons
- Loading state during submission

**Form Fields:**
```
✓ Service Name (required, min 3 chars)
✓ Category (required, dropdown)
✓ Description (optional, textarea)
✓ Price (required, decimal, positive)
✓ Duration (required, integer, 1-480 minutes)
```

### 2. Add Staff Page (`owner_add_staff_page.dart`)
Complete full-page screen for adding new staff members.

**Location:** `lib/features/owner/pages/owner_add_staff_page.dart`

**Features:**
- Form with validation
- Staff name input (3+ characters required)
- Email input (optional, validates format)
- Phone input (optional)
- Commission rate input (0-100%, default 30%)
- Multi-select skills from 11 pre-defined options
- Selected skills displayed as chips
- Real-time submission to Supabase
- Success/error feedback with SnackBar
- Cancel/Save buttons
- Loading state during submission

**Form Fields:**
```
✓ Full Name (required, min 3 chars)
✓ Email (optional, validates email format)
✓ Phone (optional)
✓ Commission Rate (required, 0-100%)
✓ Skills (required, at least 1, multi-select)
```

**Available Skills:**
- Hair Cut
- Hair Coloring
- Styling
- Manicure
- Pedicure
- Nail Art
- Facial Treatment
- Waxing
- Eyebrow Threading
- Massage Therapy
- Beard Grooming

---

## How to Use

### Navigate to Add Service Page
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const OwnerAddServicePage(),
  ),
);
```

### Navigate to Add Staff Page
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const OwnerAddStaffPage(),
  ),
);
```

---

## Integration with Existing Screens

### In Services Screen
To add navigation button in `owner_services_screen_enhanced.dart`:

```dart
// In AppBar
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
      icon: const Icon(Icons.add),
      label: const Text('Add Service'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEAB308),
      ),
    ),
  ),
],
```

### In Staff Screen
To add navigation button in `owner_staff_screen_enhanced.dart`:

```dart
// In AppBar or FAB
floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OwnerAddStaffPage(),
      ),
    );
  },
  backgroundColor: const Color(0xFFEAB308),
  child: const Icon(Icons.add),
),
```

---

## Form Validation

### Service Page Validation
| Field | Rules | Example |
|-------|-------|---------|
| Name | 3-255 chars, required | "Hair Cut" |
| Category | Dropdown, required | "Hair" |
| Description | Optional, any length | "Professional haircut" |
| Price | Positive decimal, required | "45.00" |
| Duration | 1-480 minutes, required | "60" |

### Staff Page Validation
| Field | Rules | Example |
|-------|-------|---------|
| Name | 3-255 chars, required | "John Stylist" |
| Email | Valid email format, optional | "john@salon.com" |
| Phone | Any format, optional | "555-0123" |
| Commission | 0-100%, required | "30" |
| Skills | At least 1, required | ["Hair Cut", "Styling"] |

---

## Error Handling

Both pages include comprehensive error handling:

```dart
try {
  // Submit to Supabase
  await supabaseService.createService(...);
  // Success feedback
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Service added successfully!'),
      backgroundColor: Colors.green,
    ),
  );
  // Navigate back
  Navigator.of(context).pop();
} catch (e) {
  // Error feedback
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error: ${e.toString()}'),
      backgroundColor: Colors.red,
    ),
  );
}
```

---

## Design & Styling

### Colors Used
- Primary Yellow: `#EAB308` (buttons, highlights)
- White: Background
- Grey: Text, borders
- Green: Success messages
- Red: Error messages

### Typography
- Headings: Google Fonts Outfit (bold, 20px)
- Labels: Google Fonts Outfit (600 weight, 14px)
- Body Text: Google Fonts Inter (14px)

### Layout
- Standard padding: 16px
- Field spacing: 20px
- Border radius: 12px
- Button height: 56px (with padding)

---

## Database Integration

### Service Creation Flow
```
Form Data
  ↓
Validation
  ↓
OwnerSupabaseService.createService()
  ↓
Supabase Insert Query
  ↓
PostgreSQL Insert with RLS
  ↓
Return created service
  ↓
Show success message
  ↓
Navigate back to services list
  ↓
Services StreamProvider invalidates
  ↓
Services list auto-updates with new service
```

### Staff Creation Flow
```
Form Data
  ↓
Validation (including skills check)
  ↓
OwnerSupabaseService.createStaff()
  ↓
Supabase Insert Query
  ↓
PostgreSQL Insert with RLS
  ↓
Return created staff
  ↓
Show success message
  ↓
Navigate back to staff list
  ↓
Staff StreamProvider invalidates
  ↓
Staff list auto-updates with new member
```

---

## State Management

Both pages use:
- `ConsumerStatefulWidget` for Riverpod integration
- Local `_formKey` for form validation
- `TextEditingController` for form input management
- `_isLoading` boolean for loading state
- `_selectedSkills` list for multi-select (staff only)

---

## Loading States

During submission:
- Submit buttons show loading spinner
- Buttons become disabled
- User cannot interact with form
- Prevents duplicate submissions

```dart
_isLoading
    ? const CircularProgressIndicator(strokeWidth: 2)
    : Text('Add Service')
```

---

## User Feedback

### Success Feedback
```
✓ Green SnackBar
✓ Message: "Service/Staff added successfully!"
✓ 2-second duration
✓ Auto-dismiss
✓ Navigate back to previous screen
```

### Error Feedback
```
✗ Red SnackBar
✗ Message: "Error adding service/staff: [error details]"
✗ Dismissible by tapping
✗ Stay on form to retry
```

### Validation Feedback
```
! Red error text below field
! Message: specific validation error
! Form won't submit until fixed
! Automatic when user blurs field
```

---

## Testing Checklist

### Add Service Page
- [ ] Open page from services screen
- [ ] Test name validation (empty, too short)
- [ ] Test category dropdown (required)
- [ ] Test price validation (negative, invalid)
- [ ] Test duration validation (0, >480)
- [ ] Submit valid form
- [ ] Check Supabase for new service
- [ ] Verify services list updates
- [ ] Test error scenario (network off)
- [ ] Test cancel button
- [ ] Verify form labels and styling

### Add Staff Page
- [ ] Open page from staff screen
- [ ] Test name validation (empty, too short)
- [ ] Test email validation (optional but validate if entered)
- [ ] Test commission validation (>100%, negative)
- [ ] Test skills selection (require at least 1)
- [ ] Test skill chips display and removal
- [ ] Submit valid form
- [ ] Check Supabase for new staff
- [ ] Verify staff list updates
- [ ] Test error scenario (network off)
- [ ] Test cancel button
- [ ] Verify form labels and styling

---

## Performance Notes

- Pages are lightweight (single form)
- No heavy widgets or animations
- Efficient form validation
- Immediate database submission
- Minimal dependencies

---

## Future Enhancements

- [ ] Image upload for service preview
- [ ] Availability schedule for staff
- [ ] Skill experience level (beginner/intermediate/expert)
- [ ] Service package creation
- [ ] Batch staff import from CSV
- [ ] Service template library
- [ ] Staff certification tracking
- [ ] Floating action buttons with quick shortcuts

---

## Summary

Two comprehensive full-page forms for:
1. **Adding Services** - Service name, category, description, price, duration
2. **Adding Staff** - Staff name, contact info, commission rate, skills

Both pages:
✅ Include full form validation
✅ Submit directly to Supabase
✅ Provide user feedback (success/error)
✅ Auto-update related screens
✅ Follow design system
✅ Are production-ready

---

**Created:** January 2026
**Status:** Ready to Use
**Version:** 1.0
