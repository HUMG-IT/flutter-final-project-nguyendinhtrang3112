import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
// Đảm bảo đường dẫn import đúng với tên dự án của bạn
import 'package:student_grade_manager/providers/subject_provider.dart';
import 'package:student_grade_manager/screens/home_screen.dart';
import 'package:student_grade_manager/models/subject_model.dart'; // Import model để Mock hoạt động

// --- 1. TẠO CLASS GIẢ (MOCK) ---
// Class này đóng giả SubjectProvider để Test không cần gọi Firebase thật
class MockSubjectProvider extends SubjectProvider {
  // Ghi đè hàm này để nó KHÔNG gọi lên Firebase thật
  @override
  void startListeningToSubjects() {
    print("Test Mode: Mock Provider đang chạy, không gọi Firebase.");
  }

  // Giả lập dữ liệu rỗng để test giao diện ban đầu
  @override
  List<Subject> get subjects => [];

  @override
  double get gpa => 0.0;

  @override
  bool get isLoading => false;

  // Giả lập biến sắp xếp (để nút Sort không bị lỗi)
  @override
  bool get isDescending => true;
}

void main() {
  // Hàm tạo môi trường test với Mock Provider
  Widget createHomeScreen() {
    return MultiProvider(
      providers: [
        // Thay vì dùng SubjectProvider thật, ta dùng MockSubjectProvider
        ChangeNotifierProvider<SubjectProvider>(
          create: (_) => MockSubjectProvider(),
        ),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  // --- BÀI TEST 1: Kiểm tra giao diện chính (Home) ---
  testWidgets('Hiển thị đúng các thành phần UI trên Home',
      (WidgetTester tester) async {
    // 1. Build app
    await tester.pumpWidget(createHomeScreen());

    // 2. Chờ một chút cho các hàm khởi tạo chạy xong
    await tester.pump();

    // 3. Kiểm tra Header:
    // Vì đang chạy test (không có user thật), HomeScreen sẽ hiện mặc định là "Sinh viên"
    // Ta tìm widget Text có chứa chữ "Xin chào"
    expect(find.textContaining('Xin chào'), findsOneWidget);

    // 4. Kiểm tra xem có hiển thị phần GPA không (Tìm số 0.00 hoặc chữ GPA)
    // Dựa vào code GpaSummaryCard của bạn, nó thường hiện số điểm
    expect(find.textContaining('0.00'), findsOneWidget);

    // 5. Kiểm tra Ô tìm kiếm (Search Bar)
    expect(find.text('Tìm môn học...'), findsOneWidget);

    // 6. Kiểm tra nút Floating Action Button (dấu +)
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  // --- BÀI TEST 2: Kiểm tra nút bấm chuyển trang ---
  testWidgets('Bấm nút + chuyển sang màn hình Thêm mới',
      (WidgetTester tester) async {
    // 1. Build app
    await tester.pumpWidget(createHomeScreen());

    // 2. Tìm nút thêm (+)
    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);

    // 3. Bấm nút
    await tester.tap(addButton);

    // 4. Chờ hiệu ứng chuyển trang (animation) kết thúc
    await tester.pumpAndSettle();

    // 5. Kiểm tra xem đã sang trang mới chưa
    // Vì ta không biết chắc trang "AddEditSubjectScreen" của bạn có chữ gì,
    // nhưng chắc chắn nó sẽ có các ô nhập liệu (TextField hoặc TextFormField).
    // Lệnh này tìm xem có ít nhất 1 ô nhập liệu nào hiện ra không.
    expect(find.byType(TextField), findsAtLeastNWidgets(1));
  });
}
