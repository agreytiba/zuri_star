import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceListPage extends StatelessWidget {
  const ServiceListPage({super.key});

  static const primaryColor = Color(0xFFEAB308);
  static const lightYellow = Color(0xFFFDE68A);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Services Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.85,
              children: [
                _buildServiceItem(Icons.cut_outlined, 'Hair'),
                _buildServiceItem(Icons.brush_outlined, 'Nail'),
                _buildServiceItem(Icons.palette_outlined, 'Makeup'),
                _buildServiceItem(Icons.spa_outlined, 'SPA'),
                _buildServiceItem(Icons.face_retouching_natural, 'Skincare'),
                _buildServiceItem(Icons.self_improvement, 'Body Services'),
                _buildServiceItem(Icons.content_cut, 'Waxing'),
                _buildServiceItem(Icons.face_retouching_natural, 'Skincare'),
                _buildServiceItem(Icons.self_improvement, 'Body Services'),
              ],
            ),
            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: lightYellow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
