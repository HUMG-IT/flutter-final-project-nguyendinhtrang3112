import 'package:flutter_test/flutter_test.dart';
import 'package:student_grade_manager/models/subject_model.dart';

void main() {
  group('Subject Model Test', () {
    // 1. Test logic Qua môn / Trượt
    test('isPassed trả về true nếu điểm >= 4.0', () {
      final subject = Subject(id: '1', name: 'Test', credits: 3, score: 4.0);
      expect(subject.isPassed, true);
    });

    test('isPassed trả về false nếu điểm < 4.0', () {
      final subject = Subject(id: '1', name: 'Test', credits: 3, score: 3.9);
      expect(subject.isPassed, false);
    });

    // 2. Test chuyển đổi JSON (Quan trọng cho Firebase)
    test('fromJson chuyển đổi đúng dữ liệu', () {
      final json = {
        'id': '123',
        'name': 'Dart',
        'credits': 3,
        'score': 9.5,
        'semester': 'HK1'
      };

      final subject = Subject.fromJson(json);

      expect(subject.id, '123');
      expect(subject.name, 'Dart');
      expect(subject.score, 9.5);
    });

    test('toJson xuất ra đúng cấu trúc Map', () {
      final subject =
          Subject(id: '1', name: 'Flutter', credits: 4, score: 10.0);
      final json = subject.toJson();

      expect(json['name'], 'Flutter');
      expect(json['credits'], 4);
    });
  });
}
