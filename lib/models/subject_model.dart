class Subject {
  final String id;
  final String name;
  final int credit; // [ĐÃ SỬA] Dùng số ít (credit) cho thống nhất
  final double score;
  final String semester;

  Subject({
    required this.id,
    required this.name,
    required this.credit, // [ĐÃ SỬA] Chỉ giữ 1 dòng này
    required this.score,
    this.semester = '',
  });

  // Getter: Tính trạng thái Qua môn
  bool get isPassed => score >= 4.0;

  // 1. copyWith: [ĐÃ SỬA] Dùng biến credit
  Subject copyWith({
    String? id,
    String? name,
    int? credit,
    double? score,
    String? semester,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      credit: credit ?? this.credit, // Cập nhật đúng biến
      score: score ?? this.score,
      semester: semester ?? this.semester,
    );
  }

  // 2. toJson: [ĐÃ SỬA] Key là 'credit'
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'credit': credit,
      'score': score,
      'semester': semester,
    };
  }

  // 3. fromJson: [NÂNG CẤP] Xử lý an toàn hơn tránh crash app
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String? ?? '', // Nếu null thì lấy chuỗi rỗng
      name: json['name'] as String? ?? 'Môn học chưa đặt tên',

      // Xử lý credit an toàn: Nếu null thì về 0
      credit: (json['credit'] as num? ?? 0).toInt(),

      // Xử lý score an toàn: Chuyển về double kể cả khi server trả về int
      score: (json['score'] as num? ?? 0.0).toDouble(),

      semester: json['semester'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'Subject(id: $id, name: $name, credit: $credit, score: $score)';
  }
}
