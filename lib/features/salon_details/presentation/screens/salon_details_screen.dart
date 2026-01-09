import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/salon_model.dart';
import '../../../../core/models/booking_model.dart';
import '../widgets/time_slot_selector.dart';
import '../widgets/service_selector.dart';

class SalonDetailsScreen extends StatefulWidget {
  final String salonId;

  const SalonDetailsScreen({
    super.key,
    required this.salonId,
  });

  @override
  State<SalonDetailsScreen> createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen>
    with SingleTickerProviderStateMixin {
  static const primaryColor = Color(0xFFEAB308);
  late TabController _tabController;
  
  // Mock salon data - Replace with actual API call
  late Salon _salon;
  String? _selectedService;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  bool _isInstantBooking = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSalonData();
  }

  void _loadSalonData() {
    // Mock data - Replace with actual API call
    _salon = Salon(
      id: widget.salonId,
      name: 'Zuristar Saloon',
      description:
          'Premium beauty and hair salon offering top-notch services with experienced professionals. We specialize in modern haircuts, coloring, makeup, and skincare treatments.',
      address: 'Masaki, Dar es Salaam',
      latitude: -6.7924,
      longitude: 39.2083,
      rating: 4.8,
      reviewCount: 124,
      images: [
        'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&q=80&w=600&h=400',
        'https://images.unsplash.com/photo-1521590832896-7ea591d9b35b?auto=format&fit=crop&q=80&w=600&h=400',
        'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?auto=format&fit=crop&q=80&w=600&h=400',
      ],
      services: ['Hair', 'Nail', 'Makeup', 'Skincare'],
      isMobileService: true,
      isInSalon: true,
      genderSpecific: 'unisex',
      servicePrices: {
        'Hair': 50000,
        'Nail': 30000,
        'Makeup': 80000,
        'Skincare': 60000,
      },
      availableTimeSlots: ['09:00', '11:00', '14:00', '16:00', '18:00'],
      isVerified: true,
      phoneNumber: '+255 123 456 789',
      email: 'info@zuristar.com',
    );
  }

  void _bookNow() {
    if (_selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a service',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a date',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a time slot',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create booking
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user_id', // Replace with actual user ID
      salonId: _salon.id,
      salonName: _salon.name,
      serviceType: _selectedService!,
      serviceDescription: '$_selectedService service',
      bookingDate: _selectedDate!,
      timeSlot: _selectedTimeSlot!,
      price: _salon.servicePrices[_selectedService] ?? 0,
      status: _isInstantBooking ? 'confirmed' : 'pending',
      isInstantBooking: _isInstantBooking,
      createdAt: DateTime.now(),
      reminderSet: false,
    );

    // Show confirmation dialog
    _showBookingConfirmation(booking);
  }

  void _showBookingConfirmation(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: primaryColor, size: 28),
            const SizedBox(width: 12),
            Text(
              'Booking ${booking.isInstantBooking ? 'Confirmed' : 'Requested'}!',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.isInstantBooking
                  ? 'Your booking has been confirmed.'
                  : 'Your booking request has been sent to the salon.',
              style: GoogleFonts.inter(fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildConfirmationRow('Service', booking.serviceType),
            _buildConfirmationRow('Date',
                '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}'),
            _buildConfirmationRow('Time', booking.timeSlot),
            _buildConfirmationRow('Price', '${booking.price.toStringAsFixed(0)} TZS'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/booking');
            },
            child: Text(
              'View Bookings',
              style: GoogleFonts.outfit(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add to calendar
              _addToCalendar(booking);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Add to Calendar',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _addToCalendar(Booking booking) {
    // TODO: Implement calendar integration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Calendar integration coming soon!',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.favorite_border, color: Colors.black, size: 20),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                itemCount: _salon.images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    _salon.images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _salon.name,
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (_salon.isVerified)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.verified,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: primaryColor, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            _salon.rating.toString(),
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            ' (${_salon.reviewCount} reviews)',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              _tabController.animateTo(2);
                            },
                            icon: const Icon(Icons.rate_review, size: 16),
                            label: Text(
                              'See Reviews',
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Address
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _salon.address,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Open map
                            },
                            child: Text(
                              'View Map',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Service Type Badges
                      Row(
                        children: [
                          if (_salon.isMobileService)
                            _buildBadge(Icons.directions_car, 'Mobile Service'),
                          if (_salon.isMobileService && _salon.isInSalon)
                            const SizedBox(width: 8),
                          if (_salon.isInSalon)
                            _buildBadge(Icons.store, 'In-Salon'),
                          const SizedBox(width: 8),
                          _buildBadge(
                            Icons.people,
                            _salon.genderSpecific.toUpperCase(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tabs
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey.shade600,
                  labelStyle: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  indicatorColor: primaryColor,
                  tabs: const [
                    Tab(text: 'Services'),
                    Tab(text: 'About'),
                    Tab(text: 'Reviews'),
                  ],
                ),

                // Tab Content
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Services Tab
                      ServiceSelector(
                        salon: _salon,
                        selectedService: _selectedService,
                        onServiceSelected: (service) {
                          setState(() {
                            _selectedService = service;
                          });
                        },
                      ),

                      // About Tab
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _salon.description,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Contact Information',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildContactRow(Icons.phone, _salon.phoneNumber),
                            const SizedBox(height: 8),
                            _buildContactRow(Icons.email, _salon.email),
                          ],
                        ),
                      ),

                      // Reviews Tab
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            'Reviews coming soon!',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Time Slot Selector
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TimeSlotSelector(
                    availableSlots: _salon.availableTimeSlots,
                    selectedDate: _selectedDate,
                    selectedTimeSlot: _selectedTimeSlot,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    onTimeSlotSelected: (slot) {
                      setState(() {
                        _selectedTimeSlot = slot;
                      });
                    },
                  ),
                ),

                // Booking Type
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Type',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildBookingTypeCard(
                              'Instant Booking',
                              'Get confirmed immediately',
                              Icons.flash_on,
                              _isInstantBooking,
                              () {
                                setState(() {
                                  _isInstantBooking = true;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildBookingTypeCard(
                              'Request Booking',
                              'Wait for confirmation',
                              Icons.schedule,
                              !_isInstantBooking,
                              () {
                                setState(() {
                                  _isInstantBooking = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    _selectedService != null
                        ? '${_salon.servicePrices[_selectedService]?.toStringAsFixed(0) ?? '0'} TZS'
                        : '0 TZS',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: _bookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Book Now',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.black),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingTypeCard(
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey.shade600,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? primaryColor : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
