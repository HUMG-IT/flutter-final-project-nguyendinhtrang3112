// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lấy người dùng hiện tại
  User? get currentUser => _auth.currentUser;

  // Luồng theo dõi trạng thái đăng nhập (để tự động chuyển màn hình)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 1. Đăng ký
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Ném lỗi ra để UI hiển thị (VD: Email đã tồn tại, mật khẩu yếu...)
      throw e.message ?? 'Đăng ký thất bại';
    }
  }

  // 2. Đăng nhập
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Đăng nhập thất bại';
    }
  }

  // 3. Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
