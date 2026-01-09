import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/salon_model.dart';

class ServiceSelector extends StatelessWidget {
  final Salon salon;
  final String? selectedService;
  final Function(String) onServiceSelected;

  const ServiceSelector({
    super.key,
    required this.salon,
    required this.selectedService,
    required this.onServiceSelected,
  });

  static const primaryColor = Color(0xFFEAB308);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: salon.services.length,
      itemBuilder: (context, index) {
        final service = salon.services[index];
        final price = salon.servicePrices[service] ?? 0;
        final isSelected = selectedService == service;

        return GestureDetector(
          onTap: () => onServiceSelected(service),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Service Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getServiceIcon(service),
                    color: isSelected ? Colors.white : Colors.black,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Service Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${price.toStringAsFixed(0)} TZS',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection Indicator
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: primaryColor,
                    size: 24,
                  )
                else
                  Icon(
                    Icons.circle_outlined,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getServiceIcon(String service) {
    switch (service.toLowerCase()) {
      case 'hair':
        return Icons.cut_outlined;
      case 'nail':
        return Icons.brush_outlined;
      case 'makeup':
        return Icons.palette_outlined;
      case 'spa':
        return Icons.spa_outlined;
      case 'skincare':
        return Icons.face_retouching_natural;
      case 'body services':
        return Icons.self_improvement;
      case 'waxing':
        return Icons.content_cut;
      default:
        return Icons.star_outline;
    }
  }
}
