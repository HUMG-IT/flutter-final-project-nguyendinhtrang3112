class Subject {
  final String id; // ID định danh (do Firebase sinh ra hoặc UUID)
  final String name; // Tên môn học (VD: Lập trình Mobile)
  final int credits; // Số tín chỉ (VD: 3)
  final double score; // Điểm tổng kết (VD: 8.5)
  final String semester; // Học kỳ (VD: HK1_2024)

  Subject({
    required this.id,
    required this.name,
    required this.credits,
    required this.score,
    this.semester = '',
  });

  // Getter: Tính trạng thái Qua môn hay Trượt (giả sử < 4.0 là trượt)
  // Logic này đặt ở đây giúp UI chỉ cần gọi .isPassed là xong
  bool get isPassed => score >= 4.0;

  // 1. copyWith: Tạo ra một bản sao mới của object với một vài thay đổi
  // Cực kỳ quan trọng khi làm chức năng "Sửa" (Update)
  Subject copyWith({
    String? id,
    String? name,
    int? credits,
    double? score,
    String? semester,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      credits: credits ?? this.credits,
      score: score ?? this.score,
      semester: semester ?? this.semester,
    );
  }

  // 2. toJson: Chuyển Object thành Map để lưu lên Firebase/Localstore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'credits': credits,
      'score': score,
      'semester': semester,
    };
  }

  // 3. fromJson: Đọc Map từ Firebase/Localstore chuyển thành Object
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String,
      name: json['name'] as String,
      credits: json['credits'] as int,
      // Dùng (as num).toDouble() an toàn hơn vì đôi khi server trả về int
      score: (json['score'] as num).toDouble(),
      semester: json['semester'] as String? ?? '',
    );
  }

  // Override toString để khi print ra log dễ đọc lỗi hơn
  @override
  String toString() {
    return 'Subject(id: $id, name: $name, credits: $credits, score: $score)';
  }
}
