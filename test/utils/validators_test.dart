import 'package:flutter_test/flutter_test.dart';
import 'package:student_grade_manager/utils/validators.dart';

void main() {
  group('Validators Test', () {
    // 1. Test validate tên môn học
    test('validateName trả về lỗi nếu tên trống', () {
      expect(Validators.validateName(''), 'Vui lòng nhập tên môn học');
    });

    test('validateName trả về lỗi nếu tên quá ngắn', () {
      expect(Validators.validateName('AB'), 'Tên môn học phải dài hơn 3 ký tự');
    });

    test('validateName trả về null nếu tên hợp lệ', () {
      expect(Validators.validateName('Lập trình Mobile'), null);
    });

    // 2. Test validate điểm số
    test('validateScore trả về lỗi nếu nhập chữ', () {
      expect(Validators.validateScore('abc'), 'Phải là số');
    });

    test('validateScore trả về lỗi nếu điểm < 0 hoặc > 10', () {
      expect(Validators.validateScore('-1'), 'Điểm phải từ 0 đến 10');
      expect(Validators.validateScore('11'), 'Điểm phải từ 0 đến 10');
    });

    test('validateScore chấp nhận số thập phân dấu phẩy', () {
      expect(Validators.validateScore('8,5'), null); // Hỗ trợ kiểu nhập VN
    });
  });
}
