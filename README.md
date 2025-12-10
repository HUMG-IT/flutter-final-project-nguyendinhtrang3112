# Student Grade Manager


## Báo cáo kết quả Bài tập lớn
* Họ và tên: **Nguyễn Đình Trang**
* Mã sinh viên: **2221050306**
* Lớp: **DCCTCLC67B**
* Giảng viên hướng dẫn: **Trần Trung Chuyên**

### 1. Giới thiệu
Ứng dụng **Student Grade Manager** là giải pháp quản lý học tập trên thiết bị di động, giúp sinh viên lưu trữ điểm số các môn học và tự động tính toán điểm trung bình (GPA). Ứng dụng được thiết kế theo phong cách hiện đại (Modern UI), sử dụng màu sắc Gradient trẻ trung.

### 2. Công nghệ sử dụng
* **Ngôn ngữ:** Dart
* **Framework:** Flutter (Android & iOS)
* **Backend:** Firebase (Authentication, Firestore Database)
* **State Management:** Provider (Tách biệt Logic và UI)
* **Giao diện:** Material Design 3, Custom Widgets, Animations.

#### 2.1. Quá trình phát triển
Ứng dụng được xây dựng theo mô hình kiến trúc MVVM (Model - View - ViewModel) để đảm bảo mã nguồn rõ ràng và dễ bảo trì:
* **Models:** Định nghĩa cấu trúc dữ liệu (`Subject`).
* **Providers:** Xử lý logic nghiệp vụ, tính toán GPA và gọi xuống Service (`SubjectProvider`).
* **Services:** Giao tiếp trực tiếp với Backend (`AuthService`, `FirestoreService`).
* **Screens:** Giao diện người dùng (`HomeScreen`, `LoginScreen`...).
* **Widgets:** Các thành phần giao diện tái sử dụng (`SubjectCard`, `GpaSummaryCard`).

#### 2.2. Các chức năng chính (Features)
1. **Authentication:** Đăng ký, Đăng nhập bảo mật, Đổi mật khẩu an toàn.
2. **CRUD Subjects:**
    * Thêm môn học mới (Tên, Số tín chỉ, Điểm số, Học kỳ).
    * Xem danh sách môn học (Tự động cập nhật Realtime).
    * Cập nhật thông tin môn học.
    * Xóa môn học (Thao tác vuốt `Dismissible`).
3. **Smart Features:**
    * **Tính GPA:** Tự động tính điểm trung bình tích lũy.
    * **Tìm kiếm:** Lọc môn học nhanh chóng.
    * **Sắp xếp:** Sắp xếp điểm số Tăng/Giảm dần.
4. **UI/UX:** Giao diện Gradient hiện đại, bố cục Control Panel chuyên nghiệp.

### 3. Các chức năng chính
1. **Đăng ký / Đăng nhập:** Giao diện Gradient bắt mắt, kiểm tra mật khẩu nhập lại (Confirm Password).
2. **Quản lý môn học (CRUD):**
    * Xem danh sách môn học (Realtime).
    * Thêm mới môn học (Nhập đầy đủ thông tin tín chỉ, điểm số).
    * Cập nhật môn học đã có.
    * Xóa môn học (Vuốt sang trái để xóa).
3. **Tiện ích nâng cao:** Tính GPA tự động, Tìm kiếm và Sắp xếp danh sách.
4. **Giao diện:** Thiết kế hiện đại, sử dụng hiệu ứng đổ bóng và bo góc mềm mại.

### 4. Kiểm thử (Testing)
Dự án bao gồm các bài kiểm thử trong thư mục `test/`:
* **Unit Test (`models/subject_model_test.dart`):** Kiểm tra logic chuyển đổi dữ liệu JSON và tính toán trạng thái Đạt/Trượt.
* **Unit Test (`utils/validators_test.dart`):** Kiểm tra các hàm logic xác thực dữ liệu đầu vào (Validate tên môn, điểm số, tín chỉ).
* **Widget Test (`widget_test.dart`):** Kiểm tra hiển thị của các Widget cơ bản.

### 5. CI/CD
Đã thiết lập **GitHub Actions** tại `.github/workflows/ci.yml`. Hệ thống tự động chạy lệnh `flutter test` mỗi khi có code mới được đẩy lên nhánh `main`.

### 6. Video Demo
Video trình bày các chức năng chính: [Bấm vào đây để xem Video](LINK_VIDEO_CUA_CAU)