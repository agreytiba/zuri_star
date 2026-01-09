import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/salon_model.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/salon_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const primaryColor = Color(0xFFEAB308);
  final TextEditingController _searchController = TextEditingController();
  
  // Filter states
  String? selectedServiceType;
  double? maxPrice;
  String? genderFilter; // 'male', 'female', 'unisex'
  bool? isMobileService;
  bool? isInSalon;
  String sortBy = 'rating'; // 'rating', 'price', 'distance'

  // Mock data - Replace with actual API call
  List<Salon> _salons = [];
  List<Salon> _filteredSalons = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
    _filteredSalons = _salons;
  }

  void _loadMockData() {
    _salons = [
      Salon(
        id: '1',
        name: 'Zuristar Saloon',
        description: 'Premium beauty and hair salon',
        address: 'Masaki, Dar es Salaam',
        latitude: -6.7924,
        longitude: 39.2083,
        rating: 4.8,
        reviewCount: 124,
        images: [
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&q=80&w=300&h=200',
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
        availableTimeSlots: ['09:00', '11:00', '14:00', '16:00'],
        isVerified: true,
        phoneNumber: '+255 123 456 789',
        email: 'info@zuristar.com',
      ),
      Salon(
        id: '2',
        name: 'Glamour Studio',
        description: 'Exclusive women\'s beauty parlor',
        address: 'Mikocheni, Dar es Salaam',
        latitude: -6.7746,
        longitude: 39.2619,
        rating: 4.5,
        reviewCount: 89,
        images: [
          'https://images.unsplash.com/photo-1521590832896-7ea591d9b35b?auto=format&fit=crop&q=80&w=300&h=200',
        ],
        services: ['Makeup', 'Nail', 'SPA', 'Skincare'],
        isMobileService: false,
        isInSalon: true,
        genderSpecific: 'female',
        servicePrices: {
          'Makeup': 70000,
          'Nail': 25000,
          'SPA': 100000,
          'Skincare': 55000,
        },
        availableTimeSlots: ['10:00', '12:00', '15:00', '17:00'],
        isVerified: true,
        phoneNumber: '+255 987 654 321',
        email: 'contact@glamour.com',
      ),
      Salon(
        id: '3',
        name: 'Gents Grooming',
        description: 'Modern barbershop for men',
        address: 'Kariakoo, Dar es Salaam',
        latitude: -6.8160,
        longitude: 39.2803,
        rating: 4.9,
        reviewCount: 156,
        images: [
          'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?auto=format&fit=crop&q=80&w=300&h=200',
        ],
        services: ['Hair', 'Waxing'],
        isMobileService: true,
        isInSalon: true,
        genderSpecific: 'male',
        servicePrices: {
          'Hair': 20000,
          'Waxing': 15000,
        },
        availableTimeSlots: ['08:00', '10:00', '13:00', '15:00', '18:00'],
        isVerified: true,
        phoneNumber: '+255 456 789 123',
        email: 'info@gentsgrooming.com',
      ),
    ];
  }

  void _applyFilters() {
    setState(() {
      _filteredSalons = _salons.where((salon) {
        // Service type filter
        if (selectedServiceType != null && 
            !salon.services.contains(selectedServiceType)) {
          return false;
        }

        // Price filter
        if (maxPrice != null) {
          bool hasAffordableService = salon.servicePrices.values.any(
            (price) => price <= maxPrice!,
          );
          if (!hasAffordableService) return false;
        }

        // Gender filter
        if (genderFilter != null && 
            salon.genderSpecific != 'unisex' &&
            salon.genderSpecific != genderFilter) {
          return false;
        }

        // Mobile service filter
        if (isMobileService != null && salon.isMobileService != isMobileService) {
          return false;
        }

        // In-salon filter
        if (isInSalon != null && salon.isInSalon != isInSalon) {
          return false;
        }

        return true;
      }).toList();

      // Sort results
      if (sortBy == 'rating') {
        _filteredSalons.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (sortBy == 'price') {
        _filteredSalons.sort((a, b) {
          double avgPriceA = a.servicePrices.values.reduce((a, b) => a + b) / 
                             a.servicePrices.length;
          double avgPriceB = b.servicePrices.values.reduce((a, b) => a + b) / 
                             b.servicePrices.length;
          return avgPriceA.compareTo(avgPriceB);
        });
      }
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        selectedServiceType: selectedServiceType,
        maxPrice: maxPrice,
        genderFilter: genderFilter,
        isMobileService: isMobileService,
        isInSalon: isInSalon,
        sortBy: sortBy,
        onApply: (filters) {
          setState(() {
            selectedServiceType = filters['serviceType'];
            maxPrice = filters['maxPrice'];
            genderFilter = filters['gender'];
            isMobileService = filters['isMobileService'];
            isInSalon = filters['isInSalon'];
            sortBy = filters['sortBy'] ?? 'rating';
          });
          _applyFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Search Salons',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search salons or services...',
                      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: (value) {
                      // Implement search logic
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Filter Button
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: _showFilterSheet,
                  ),
                ),
              ],
            ),
          ),

          // Active Filters
          if (selectedServiceType != null || 
              maxPrice != null || 
              genderFilter != null ||
              isMobileService != null ||
              isInSalon != null)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (selectedServiceType != null)
                    _buildFilterChip(
                      selectedServiceType!,
                      () {
                        setState(() {
                          selectedServiceType = null;
                          _applyFilters();
                        });
                      },
                    ),
                  if (maxPrice != null)
                    _buildFilterChip(
                      'Under ${maxPrice!.toStringAsFixed(0)} TZS',
                      () {
                        setState(() {
                          maxPrice = null;
                          _applyFilters();
                        });
                      },
                    ),
                  if (genderFilter != null)
                    _buildFilterChip(
                      genderFilter!,
                      () {
                        setState(() {
                          genderFilter = null;
                          _applyFilters();
                        });
                      },
                    ),
                  if (isMobileService == true)
                    _buildFilterChip(
                      'Mobile Service',
                      () {
                        setState(() {
                          isMobileService = null;
                          _applyFilters();
                        });
                      },
                    ),
                  if (isInSalon == true)
                    _buildFilterChip(
                      'In-Salon',
                      () {
                        setState(() {
                          isInSalon = null;
                          _applyFilters();
                        });
                      },
                    ),
                ],
              ),
            ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredSalons.length} salons found',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Sorted by: ${sortBy.toUpperCase()}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Salon List
          Expanded(
            child: _filteredSalons.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No salons found',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredSalons.length,
                    itemBuilder: (context, index) {
                      return SalonCard(
                        salon: _filteredSalons[index],
                        onTap: () {
                          context.push('/salon-details/${_filteredSalons[index].id}');
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: primaryColor.withOpacity(0.2),
        deleteIconColor: Colors.black,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
