import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController =
      TextEditingController(); // [MỚI] Controller xác nhận
  final _authService = AuthService();

  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    try {
      if (_isLogin) {
        // --- ĐĂNG NHẬP ---
        await _authService.signIn(email: email, password: password);
      } else {
        // --- ĐĂNG KÝ ---
        // 1. Kiểm tra mật khẩu nhập lại có khớp không
        if (password != confirmPassword) {
          throw 'Mật khẩu xác nhận không khớp!';
        }
        if (password.length < 6) {
          throw 'Mật khẩu phải có ít nhất 6 ký tự';
        }

        await _authService.signUp(email: email, password: password);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school_rounded, size: 80, color: Colors.white),
              const SizedBox(height: 10),
              const Text(
                "Grade Manager",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isLogin ? 'Welcome Back!' : 'Create Account',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333)),
                    ),
                    const SizedBox(height: 20),

                    // Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.primary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Mật khẩu
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.primary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      obscureText: true,
                    ),

                    // [MỚI] Ô Xác nhận mật khẩu (Chỉ hiện khi Đăng ký)
                    if (!_isLogin) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Nhập lại mật khẩu',
                          prefixIcon: const Icon(Icons.lock_reset,
                              color: AppColors.accent),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        obscureText: true,
                      ),
                    ],

                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(colors: [
                                  AppColors.primary,
                                  AppColors.accent
                                ]),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.primary.withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5))
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(_isLogin ? 'ĐĂNG NHẬP' : 'ĐĂNG KÝ',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                    ),

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          _errorMessage = null;
                          _confirmPasswordController
                              .clear(); // Xóa ô xác nhận khi chuyển tab
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          text: _isLogin
                              ? 'Chưa có tài khoản? '
                              : 'Đã có tài khoản? ',
                          style: const TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: _isLogin ? 'Đăng ký ngay' : 'Đăng nhập',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
