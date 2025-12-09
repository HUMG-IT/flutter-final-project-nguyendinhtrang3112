import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:student_grade_manager/providers/subject_provider.dart';
import 'package:student_grade_manager/screens/home_screen.dart';

void main() {
  // Hàm trợ giúp để build UI có chứa Provider
  Widget createHomeScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  testWidgets('Hiển thị màn hình Home và GPA ban đầu',
      (WidgetTester tester) async {
    // 1. Build app và trigger frame đầu tiên
    await tester.pumpWidget(createHomeScreen());

    // 2. Kiểm tra xem có chữ "Quản lý Điểm số" trên AppBar không
    expect(find.text('Quản lý Điểm số'), findsOneWidget);

    // 3. Kiểm tra xem có hiển thị phần GPA không
    expect(find.text('Điểm Trung Bình (GPA)'), findsOneWidget);

    // 4. Kiểm tra nút bấm dấu + (Floating Action Button) có tồn tại không
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Bấm nút + chuyển sang màn hình Thêm mới',
      (WidgetTester tester) async {
    await tester.pumpWidget(createHomeScreen());

    // Bấm nút +
    await tester.tap(find.byIcon(Icons.add));

    // Chờ animation chuyển trang
    await tester.pumpAndSettle();

    // Kiểm tra xem đã sang trang "Thêm môn mới" chưa
    expect(find.text('Thêm môn mới'), findsOneWidget);

    // Kiểm tra có ô nhập liệu không
    expect(find.byType(TextFormField),
        findsAtLeastNWidgets(3)); // Tên, Tín chỉ, Điểm
  });
}
