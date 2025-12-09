import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // [MỚI] Thư viện để lấy ID người dùng
import '../models/subject_model.dart';

class FirestoreService {
  // Khởi tạo instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // [QUAN TRỌNG] Hàm lấy đường dẫn đến kho dữ liệu RIÊNG của user hiện tại
  // Cấu trúc mới: users/{userID}/subjects/{subjectID}
  CollectionReference get _subjectRef {
    final user = _auth.currentUser;

    // Nếu chưa đăng nhập mà gọi hàm này thì báo lỗi ngay
    if (user == null) {
      throw Exception("Chưa đăng nhập! Không thể truy cập dữ liệu.");
    }

    // Trỏ vào đúng folder của người dùng đó
    return _db.collection('users').doc(user.uid).collection('subjects');
  }

  // --- 1. CREATE (Thêm mới) ---
  Future<void> addSubject(Subject subject) async {
    try {
      // _subjectRef bây giờ đã trỏ đúng vào kho của user rồi
      await _subjectRef.doc(subject.id).set(subject.toJson());
    } catch (e) {
      print("Lỗi khi thêm môn học: $e");
      rethrow;
    }
  }

  // --- 2. READ (Đọc dữ liệu Realtime) ---
  Stream<List<Subject>> getSubjectsStream() {
    try {
      // Tự động lắng nghe đúng kho của user hiện tại
      return _subjectRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return Subject.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      // Trường hợp văng app hoặc chưa kịp đăng nhập thì trả về list rỗng cho an toàn
      print("Lỗi Stream (có thể do chưa login): $e");
      return Stream.value([]);
    }
  }

  // --- 3. UPDATE (Cập nhật) ---
  Future<void> updateSubject(Subject subject) async {
    try {
      await _subjectRef.doc(subject.id).update(subject.toJson());
    } catch (e) {
      print("Lỗi khi cập nhật: $e");
      rethrow;
    }
  }

  // --- 4. DELETE (Xóa) ---
  Future<void> deleteSubject(String id) async {
    try {
      await _subjectRef.doc(id).delete();
    } catch (e) {
      print("Lỗi khi xóa: $e");
      rethrow;
    }
  }
}
