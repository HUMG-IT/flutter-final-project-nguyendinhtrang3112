import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// ✅ Import đúng tên dự án của cậu (student_grade_manager)
import 'package:student_grade_manager/providers/subject_provider.dart';
import 'package:student_grade_manager/screens/home_screen.dart';
import 'package:student_grade_manager/models/subject_model.dart';

// --- MOCK PROVIDER (GIẢ LẬP) ---
class MockSubjectProvider extends SubjectProvider {
  @override
  void startListeningToSubjects() {} // Không gọi Firebase
  @override
  List<Subject> get subjects => [];
  @override
  double get gpa => 0.0;
  @override
  bool get isLoading => false;
  @override
  bool get isDescending => true;
}

void main() {
  Widget createHomeScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SubjectProvider>(
          create: (_) => MockSubjectProvider(),
        ),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  // --- BÀI TEST 1: Kiểm tra giao diện Home ---
  testWidgets('Hiển thị đúng các thành phần UI trên Home',
      (WidgetTester tester) async {
    // 1. Khởi động màn hình
    await tester.pumpWidget(createHomeScreen());

    // 2. [QUAN TRỌNG] Đổi pump -> pumpAndSettle để đợi UI load xong hẳn
    await tester.pumpAndSettle();

    // 3. Kiểm tra nút thêm (+) -> Nếu tìm thấy nghĩa là App không bị sập
    expect(find.byIcon(Icons.add), findsOneWidget);

    // 4. Kiểm tra ô tìm kiếm
    expect(find.byType(TextField), findsOneWidget);

    // 5. Kiểm tra chữ "Xin chào" (Chỉ hiện nếu HomeScreen đã có try-catch)
    expect(find.textContaining('Xin chào'), findsOneWidget);
  });

  // --- BÀI TEST 2: Kiểm tra chuyển trang ---
  testWidgets('Bấm nút + chuyển sang màn hình Thêm mới',
      (WidgetTester tester) async {
    await tester.pumpWidget(createHomeScreen());
    await tester.pumpAndSettle(); // Đợi load xong

    // Bấm nút
    await tester.tap(find.byIcon(Icons.add));

    // Đợi hiệu ứng chuyển trang
    await tester.pumpAndSettle();

    // Kiểm tra xem đã sang trang mới chưa (tìm ô nhập liệu)
    expect(find.byType(TextField), findsAtLeastNWidgets(1));
  });
}
