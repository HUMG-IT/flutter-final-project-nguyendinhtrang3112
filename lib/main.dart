import 'package:firebase_auth/firebase_auth.dart'; // [MỚI] Thư viện Auth
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Import các file thành phần
import 'providers/subject_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart'; // [MỚI] Màn hình đăng nhập
import 'services/auth_service.dart'; // [MỚI] Service xử lý đăng nhập
import 'constants/app_colors.dart';

// [QUAN TRỌNG] File cấu hình Firebase
import 'firebase_options.dart';

void main() async {
  // 1. Đảm bảo Flutter binding đã sẵn sàng
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Kết nối Firebase thành công!");
  } catch (e) {
    print("⚠️ Lỗi khởi tạo Firebase: $e");
    print(
        "👉 Nếu chưa cấu hình Firebase, hãy chạy lệnh: flutterfire configure");
  }

  // 3. Chạy ứng dụng
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
      ],
      child: MaterialApp(
        title: 'Quản lý Điểm số',
        debugShowCheckedModeBanner: false,

        // 5. Cấu hình giao diện (Theme)
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            secondary: AppColors.accent,
            background: AppColors.background,
          ),

          // Style mặc định cho AppBar
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),

          // Style mặc định cho nút bấm
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          // Style mặc định cho Card
          // Tớ giữ nguyên CardThemeData như code cũ cậu bảo chạy được nha
          cardTheme: CardThemeData(
            color: AppColors.cardColor,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // [QUAN TRỌNG NHẤT] Auth Gate: Kiểm tra trạng thái đăng nhập
        home: StreamBuilder<User?>(
          stream: AuthService().authStateChanges,
          builder: (context, snapshot) {
            // 1. Đang chờ kiểm tra (Load app)
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // 2. Nếu có dữ liệu User -> Vào Trang chủ
            if (snapshot.hasData) {
              return const HomeScreen();
            }

            // 3. Nếu chưa đăng nhập -> Vào Trang Login
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
