class Validators {
  // Kiểm tra tên môn học
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên môn học';
    }
    if (value.length < 3) {
      return 'Tên môn học phải dài hơn 3 ký tự';
    }
    return null;
  }

  // Kiểm tra số tín chỉ (Phải là số nguyên > 0)
  static String? validateCredits(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nhập số tín chỉ';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'Phải là số nguyên';
    }
    if (number <= 0) {
      return 'Tín chỉ phải > 0';
    }
    return null;
  }

  // Kiểm tra điểm số (Phải từ 0 đến 10)
  static String? validateScore(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nhập điểm số';
    }
    final number =
        double.tryParse(value.replaceAll(',', '.')); // Hỗ trợ cả dấu phẩy
    if (number == null) {
      return 'Phải là số';
    }
    if (number < 0 || number > 10) {
      return 'Điểm phải từ 0 đến 10';
    }
    return null;
  }
}
