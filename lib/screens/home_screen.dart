import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/subject_provider.dart';
import '../widgets/subject_card.dart';
import '../widgets/gpa_summary_card.dart';
import '../constants/app_colors.dart';
import 'add_edit_subject_screen.dart';
import 'user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubjectProvider>(context, listen: false)
          .startListeningToSubjects();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Sinh viên';
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<SubjectProvider>(
        builder: (context, provider, child) {
          // 1. Tạo bản sao danh sách để xử lý
          var displayList = List.of(provider.subjects);

          // 2. Lọc theo tìm kiếm
          if (_searchQuery.isNotEmpty) {
            displayList = displayList.where((subject) {
              return subject.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
            }).toList();
          }

          // 3. [MỚI] Sắp xếp danh sách dựa trên biến isDescending trong Provider
          displayList.sort((a, b) {
            if (provider.isDescending) {
              return b.score.compareTo(a.score); // Cao -> Thấp
            } else {
              return a.score.compareTo(b.score); // Thấp -> Cao
            }
          });

          return Column(
            children: [
              // --- HEADER MÀU XANH ---
              Container(
                // Tự động giãn chiều cao theo nội dung
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 25),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    // Hàng 1: Info User
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Text(
                              displayName.isNotEmpty
                                  ? displayName.substring(0, 1).toUpperCase()
                                  : 'S',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Xin chào, $displayName 👋",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const UserProfileScreen()))
                                .then((_) => setState(() {}));
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Hàng 2: GPA Card
                    GpaSummaryCard(gpa: provider.gpa),

                    const SizedBox(height: 20),

                    // Hàng 3: THANH TÌM KIẾM + NÚT SẮP XẾP
                    Row(
                      children: [
                        // Ô tìm kiếm (Chiếm phần lớn diện tích)
                        Expanded(
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10)
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) =>
                                  setState(() => _searchQuery = value),
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                hintText: "Tìm môn học...",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                prefixIcon: const Icon(Icons.search,
                                    color: AppColors.primary, size: 20),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.grey, size: 18),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() => _searchQuery = '');
                                        })
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // [MỚI] Nút Sắp xếp (Sort Button)
                        GestureDetector(
                          onTap: () {
                            provider.toggleSortOrder();
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10)
                              ],
                            ),
                            child: Icon(
                              // Đổi icon dựa theo trạng thái
                              provider.isDescending
                                  ? Icons.arrow_downward_rounded // Cao -> Thấp
                                  : Icons.arrow_upward_rounded, // Thấp -> Cao
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- PHẦN DANH SÁCH (LIST) ---
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : displayList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off,
                                    size: 60, color: Colors.grey[300]),
                                const SizedBox(height: 10),
                                Text(
                                  _searchQuery.isEmpty
                                      ? "Chưa có môn học nào"
                                      : "Không tìm thấy kết quả",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            itemCount: displayList.length,
                            itemBuilder: (context, index) {
                              final subject = displayList[index];
                              return Dismissible(
                                key: Key(subject.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(16)),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Icon(Icons.delete_outline,
                                      color: Colors.red.shade700, size: 28),
                                ),
                                confirmDismiss: (direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Xác nhận"),
                                      content: Text(
                                          "Bạn có chắc muốn xóa môn '${subject.name}' không?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(false),
                                            child: const Text("Hủy")),
                                        ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(true),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white),
                                            child: const Text("Xóa")),
                                      ],
                                    ),
                                  );
                                },
                                onDismissed: (direction) =>
                                    provider.deleteSubject(subject.id),
                                child: SubjectCard(
                                  subject: subject,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AddEditSubjectScreen(
                                              subject: subject))),
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddEditSubjectScreen())),
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),
    );
  }
}
