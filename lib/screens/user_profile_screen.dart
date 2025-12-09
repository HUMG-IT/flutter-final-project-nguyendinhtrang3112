import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/subject_provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateName() async {
    if (_nameController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await user?.updateDisplayName(_nameController.text);
      await user?.reload();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Đã cập nhật tên thành công!')));
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // [MỚI] Hàm hiển thị dialog đổi pass có 2 ô nhập
  void _showChangePasswordDialog() {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Đổi mật khẩu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Nhập mật khẩu mới (2 lần):"),
            const SizedBox(height: 15),

            // Ô nhập pass mới
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mật khẩu mới",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 15),

            // Ô xác nhận pass
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Nhập lại mật khẩu mới",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_reset),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () async {
              // 1. Kiểm tra độ dài
              if (passwordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('⚠️ Mật khẩu phải có ít nhất 6 ký tự')));
                return;
              }
              // 2. Kiểm tra khớp nhau
              if (passwordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('⚠️ Hai mật khẩu không khớp nhau!')));
                return;
              }

              // 3. Tiến hành đổi
              try {
                await user?.updatePassword(passwordController.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('✅ Đổi mật khẩu thành công!')));
              } catch (e) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Lỗi: $e (Bạn cần đăng nhập lại để thực hiện)')));
              }
            },
            child: const Text("Lưu thay đổi"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context)),
                ),
                const Positioned(
                    top: 60,
                    child: Text("Hồ sơ cá nhân",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold))),
                Positioned(
                  bottom: -50,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5))
                        ]),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                          user?.email?.substring(0, 1).toUpperCase() ?? 'A',
                          style: const TextStyle(
                              fontSize: 40,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("THÔNG TIN CƠ BẢN",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _emailController,
                          enabled: false,
                          style: TextStyle(color: Colors.grey.shade800),
                          decoration: InputDecoration(
                              labelText: 'Email đăng nhập',
                              prefixIcon: const Icon(Icons.email_outlined,
                                  color: AppColors.primary),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.grey.shade100),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              labelText: 'Tên hiển thị',
                              prefixIcon: const Icon(Icons.badge_outlined,
                                  color: AppColors.primary),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.save_as,
                                      color: AppColors.accent),
                                  onPressed: _updateName,
                                  tooltip: "Lưu tên")),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("BẢO MẬT",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  shape: BoxShape.circle),
                              child:
                                  const Icon(Icons.lock, color: Colors.orange)),
                          title: const Text("Mật khẩu"),
                          subtitle: const Text("*********"),
                          trailing: TextButton(
                              onPressed: _showChangePasswordDialog,
                              child: const Text("Thay đổi")),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Provider.of<SubjectProvider>(context, listen: false)
                            .clearData();
                        AuthService().signOut();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("Đăng xuất tài khoản",
                          style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
