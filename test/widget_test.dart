import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import đúng file của dự án cậu
import 'package:student_grade_manager/models/subject_model.dart';
import 'package:student_grade_manager/widgets/subject_card.dart';

void main() {
  testWidgets('Test hiển thị SubjectCard độc lập (Không cần Firebase)',
      (WidgetTester tester) async {
    // 1. TẠO DỮ LIỆU GIẢ (Mock Data)
    // Tạo một môn học mẫu để hiển thị
    final subject = Subject(
      id: 'test_id_123',
      name: 'Lập trình Flutter', // Tên môn sẽ hiển thị
      score: 9.5, // Điểm số
      credit: 3, // Tín chỉ
      // Nếu model của cậu còn trường nào khác (ví dụ kỳ học), hãy điền nốt vào đây
    );

    // 2. BUILD WIDGET
    // Bọc SubjectCard trong MaterialApp -> Scaffold để nó có giao diện chuẩn
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10),
            // Chỉ hiển thị đúng cái Card này thôi, không cần Provider hay Firebase gì cả
            child: SubjectCard(
              subject: subject,
              onTap: () {
                print("Đã bấm vào card!");
              },
            ),
          ),
        ),
      ),
    );

    // 3. KIỂM TRA (ASSERT)
    // Máy tính sẽ soi xem trên màn hình có chữ 'Lập trình Flutter' không
    expect(find.text('Lập trình Flutter'), findsOneWidget);

    // Kiểm tra xem có hiển thị số điểm không (tùy vào cách cậu hiển thị trong SubjectCard)
    // Ví dụ nếu cậu hiển thị "9.5", thì tìm text chứa '9.5'
    expect(find.textContaining('9.5'), findsOneWidget);

    // Tìm xem có Icon nào không (ví dụ icon môn học hoặc nút xóa)
    expect(find.byType(Icon), findsWidgets);
  });
}
