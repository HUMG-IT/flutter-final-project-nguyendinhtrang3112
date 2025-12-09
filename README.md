BÁO CÁO KẾT QUẢ BÀI TẬP LỚN

Họ và tên: Nguyễn Đình Trang 
Mã sinh viên: 2221050306
Lớp: DCCTCLC67B 
Giảng viên hướng dẫn: Trần Trung Chuyên

1. GIỚI THIỆU

Ứng dụng Student Grade Manager là giải pháp quản lý học tập toàn diện trên thiết bị di động, giúp sinh viên lưu trữ điểm số, theo dõi tiến độ học tập và tự động tính toán điểm trung bình (GPA). Ứng dụng được thiết kế theo phong cách hiện đại (Modern UI), sử dụng màu sắc Gradient trẻ trung và bố cục trực quan.

2. CÔNG NGHỆ SỬ DỤNG

Ngôn ngữ: Dart

Framework: Flutter (Hỗ trợ đa nền tảng Android & iOS)

Backend: Firebase (Authentication, Cloud Firestore)

State Management: Provider (Quản lý trạng thái hiệu quả và tách biệt logic)

Giao diện: Material Design 3, Custom Widgets, Animations.

2.1. Quá trình phát triển

Ứng dụng được xây dựng theo mô hình kiến trúc MVVM (Model - View - ViewModel) để đảm bảo mã nguồn rõ ràng, dễ mở rộng và bảo trì:

Models: Định nghĩa cấu trúc dữ liệu (Subject - Môn học).

Providers (ViewModel): Xử lý logic nghiệp vụ, tính toán GPA và gọi xuống Service (SubjectProvider).

Services: Lớp trung gian giao tiếp trực tiếp với Firebase (AuthService, FirestoreService).

Screens (View): Giao diện người dùng (HomeScreen, LoginScreen, UserProfileScreen...).

Widgets: Các thành phần giao diện tái sử dụng (SubjectCard, GpaSummaryCard).

2.2. Các chức năng chính (Features)

Authentication: Đăng ký, Đăng nhập bảo mật, Đổi mật khẩu và Cập nhật thông tin cá nhân.

CRUD Subjects:

Thêm môn học mới (Tên, Số tín chỉ, Điểm số, Học kỳ).

Xem danh sách môn học (Cập nhật thời gian thực - Realtime Updates).

Cập nhật thông tin môn học.

Xóa môn học (Thao tác vuốt sang trái - Swipe to Dismiss).

Smart Features:

Tính GPA tự động: Hệ thống tự động tính điểm trung bình tích lũy ngay khi dữ liệu thay đổi.

Tìm kiếm (Search): Lọc môn học theo tên nhanh chóng với thanh tìm kiếm neo đậu.

Sắp xếp (Sort): Chức năng sắp xếp điểm số (Tăng dần/Giảm dần) giúp dễ dàng theo dõi kết quả.

User Isolation: Dữ liệu được phân quyền chặt chẽ, mỗi tài khoản chỉ xem được điểm số của chính mình.

3. CHI TIẾT CHỨC NĂNG VÀ GIAO DIỆN

Đăng ký / Đăng nhập: Giao diện Gradient bắt mắt, kiểm tra mật khẩu nhập lại (Confirm Password).

Màn hình chính (Dashboard):

Hiển thị GPA tổng quan nổi bật.

Danh sách môn học hiển thị dạng thẻ (Card) với chỉ thị màu sắc (Xanh: Đạt, Đỏ: Học lại).

Quản lý Tài khoản (Profile):

Xem thông tin Email, Tên hiển thị.

Đổi mật khẩu an toàn.

Đăng xuất (Kèm chức năng dọn dẹp bộ nhớ đệm).

Trải nghiệm người dùng (UX):

Hộp thoại xác nhận (Dialog) trước khi xóa hoặc đăng xuất.

Thông báo (SnackBar) phản hồi thao tác người dùng.

4. KIỂM THỬ (TESTING)

Dự án tuân thủ quy trình kiểm thử chất lượng phần mềm, bao gồm các file test trong thư mục test/:

Unit Test (models/subject_model_test.dart): Kiểm tra logic chuyển đổi dữ liệu JSON và tính toán trạng thái Đạt/Trượt.

Unit Test (providers/subject_provider_test.dart): Kiểm tra logic tính toán GPA.

Widget Test (widget_test.dart): Kiểm tra việc hiển thị các Widget cơ bản trên màn hình.

5. CI/CD

Đã thiết lập GitHub Actions tại đường dẫn .github/workflows/ci.yml.

Hệ thống tự động kích hoạt quy trình kiểm thử (Automated Testing) mỗi khi có mã nguồn mới được đẩy lên nhánh main.

Đảm bảo mã nguồn luôn hoạt động ổn định trước khi triển khai.

6. VIDEO DEMO VÀ ẢNH CHỤP MÀN HÌNH

Link Video Demo: [Dán link video của cậu vào đây]

Ảnh chụp màn hình: [Dán ảnh chụp màn hình vào đây trong file Word]

Báo cáo kết thúc.
