import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? selectedServiceType;
  final double? maxPrice;
  final String? genderFilter;
  final bool? isMobileService;
  final bool? isInSalon;
  final String sortBy;
  final Function(Map<String, dynamic>) onApply;

  const FilterBottomSheet({
    super.key,
    this.selectedServiceType,
    this.maxPrice,
    this.genderFilter,
    this.isMobileService,
    this.isInSalon,
    required this.sortBy,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  static const primaryColor = Color(0xFFEAB308);
  
  late String? _selectedServiceType;
  late double _maxPrice;
  late String? _genderFilter;
  late bool _isMobileService;
  late bool _isInSalon;
  late String _sortBy;

  final List<String> _serviceTypes = [
    'Hair',
    'Nail',
    'Makeup',
    'SPA',
    'Skincare',
    'Body Services',
    'Waxing',
  ];

  @override
  void initState() {
    super.initState();
    _selectedServiceType = widget.selectedServiceType;
    _maxPrice = widget.maxPrice ?? 200000;
    _genderFilter = widget.genderFilter;
    _isMobileService = widget.isMobileService ?? false;
    _isInSalon = widget.isInSalon ?? false;
    _sortBy = widget.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedServiceType = null;
                            _maxPrice = 200000;
                            _genderFilter = null;
                            _isMobileService = false;
                            _isInSalon = false;
                            _sortBy = 'rating';
                          });
                        },
                        child: Text(
                          'Clear All',
                          style: GoogleFonts.outfit(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Service Type
                  Text(
                    'Service Type',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _serviceTypes.map((service) {
                      final isSelected = _selectedServiceType == service;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedServiceType = isSelected ? null : service;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? primaryColor : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            service,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Price Range
                  Text(
                    'Maximum Price',
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
                        child: Slider(
                          value: _maxPrice,
                          min: 10000,
                          max: 200000,
                          divisions: 19,
                          activeColor: primaryColor,
                          label: '${_maxPrice.toStringAsFixed(0)} TZS',
                          onChanged: (value) {
                            setState(() {
                              _maxPrice = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        '${_maxPrice.toStringAsFixed(0)} TZS',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Gender Specific
                  Text(
                    'Gender Preference',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildGenderChip('male', 'Male'),
                      const SizedBox(width: 8),
                      _buildGenderChip('female', 'Female'),
                      const SizedBox(width: 8),
                      _buildGenderChip('unisex', 'Unisex'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Service Location
                  Text(
                    'Service Location',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: Text(
                      'Mobile Service (They come to you)',
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    value: _isMobileService,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        _isMobileService = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: Text(
                      'In-Salon Service',
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    value: _isInSalon,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        _isInSalon = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),

                  // Sort By
                  Text(
                    'Sort By',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildSortChip('rating', 'Rating'),
                      const SizedBox(width: 8),
                      _buildSortChip('price', 'Price'),
                      const SizedBox(width: 8),
                      _buildSortChip('distance', 'Distance'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply({
                          'serviceType': _selectedServiceType,
                          'maxPrice': _maxPrice,
                          'gender': _genderFilter,
                          'isMobileService': _isMobileService ? true : null,
                          'isInSalon': _isInSalon ? true : null,
                          'sortBy': _sortBy,
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Apply Filters',
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
          );
        },
      ),
    );
  }

  Widget _buildGenderChip(String value, String label) {
    final isSelected = _genderFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _genderFilter = isSelected ? null : value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip(String value, String label) {
    final isSelected = _sortBy == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _sortBy = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
