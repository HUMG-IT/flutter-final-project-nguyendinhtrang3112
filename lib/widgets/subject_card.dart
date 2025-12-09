import 'package:flutter/material.dart';
import '../models/subject_model.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  // [LƯU Ý] Ta đã xóa 'onDelete' ở đây vì sẽ dùng tính năng "Vuốt để xóa" ở màn hình chính
  const SubjectCard({
    super.key,
    required this.subject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Logic màu sắc: Xanh lá (Qua môn) - Đỏ cam (Học lại)
    final statusColor =
        subject.isPassed ? const Color(0xFF00C853) : const Color(0xFFFF3D00);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Hiệu ứng đổ bóng nhẹ nhàng, hiện đại
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // 1. THANH MÀU TRẠNG THÁI (Vertical Bar)
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),

                // 2. NỘI DUNG CHÍNH
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên môn học
                        Text(
                          subject.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436), // Màu đen xám tech
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),

                        // Hàng thông tin phụ (Tín chỉ + Trạng thái)
                        Row(
                          children: [
                            // Chip Tín chỉ
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.layers_outlined,
                                      size: 14, color: Colors.grey.shade700),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${subject.credits} tín',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // Text trạng thái
                            Text(
                              subject.isPassed ? "ĐẠT" : "HỌC LẠI",
                              style: TextStyle(
                                fontSize: 13,
                                color: statusColor,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. KHỐI ĐIỂM SỐ (Score Box)
                Container(
                  width: 80,
                  decoration: BoxDecoration(
                    border:
                        Border(left: BorderSide(color: Colors.grey.shade100)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subject.score.toString(),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: statusColor,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        "GPA",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
