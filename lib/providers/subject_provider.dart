import 'dart:async';
import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../services/firestore_service.dart';

class SubjectProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<Subject> _subjects = [];
  bool _isLoading = false;

  // [MỚI] Biến trạng thái sắp xếp: true = Cao xuống Thấp, false = Thấp lên Cao
  bool _isDescending = true;

  StreamSubscription<List<Subject>>? _streamSubscription;

  List<Subject> get subjects => _subjects;
  bool get isLoading => _isLoading;
  set isLoading(bool value) => _isLoading = value;
  bool get isDescending =>
      _isDescending; // Getter để UI biết đang sắp xếp kiểu gì

  double get gpa {
    if (_subjects.isEmpty) return 0.0;
    double totalScore = 0;
    int totalCredits = 0;
    for (var subj in _subjects) {
      totalScore += subj.score * subj.credits;
      totalCredits += subj.credits;
    }
    return totalCredits == 0
        ? 0.0
        : double.parse((totalScore / totalCredits).toStringAsFixed(2));
  }

  // [MỚI] Hàm đảo ngược thứ tự sắp xếp
  void toggleSortOrder() {
    _isDescending = !_isDescending;
    notifyListeners(); // Báo cho UI vẽ lại
  }

  void startListeningToSubjects() {
    _streamSubscription?.cancel();
    isLoading = true;
    notifyListeners();

    _streamSubscription = _service.getSubjectsStream().listen(
      (updatedList) {
        _subjects = updatedList;
        isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        print("Lỗi load stream: $e");
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void clearData() {
    _subjects = [];
    _streamSubscription?.cancel();
    _streamSubscription = null;
    isLoading = false;
    notifyListeners();
  }

  Future<void> addSubject(Subject subject) async {
    await _service.addSubject(subject);
  }

  Future<void> updateSubject(Subject subject) async {
    await _service.updateSubject(subject);
  }

  Future<void> deleteSubject(String id) async {
    await _service.deleteSubject(id);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
