import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GpaSummaryCard extends StatelessWidget {
  final double gpa;

  const GpaSummaryCard({super.key, required this.gpa});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Điểm Trung Bình (GPA)',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            gpa.toStringAsFixed(2), // Hiển thị 2 số thập phân
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getRank(gpa),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm xếp loại vui vẻ
  String _getRank(double gpa) {
    if (gpa >= 9.0) return 'Xuất sắc 🏆';
    if (gpa >= 8.0) return 'Giỏi 🥇';
    if (gpa >= 7.0) return 'Khá 👍';
    if (gpa >= 5.0) return 'Trung bình 😐';
    return 'Cố gắng lên! 💪';
  }
}
