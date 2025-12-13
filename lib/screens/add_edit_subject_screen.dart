import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subject_model.dart';
import '../providers/subject_provider.dart';
import '../utils/validators.dart';
import '../constants/app_colors.dart';

class AddEditSubjectScreen extends StatefulWidget {
  final Subject? subject;

  const AddEditSubjectScreen({super.key, this.subject});

  @override
  State<AddEditSubjectScreen> createState() => _AddEditSubjectScreenState();
}

class _AddEditSubjectScreenState extends State<AddEditSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _creditsController;
  late TextEditingController _scoreController;
  late TextEditingController
      _semesterController; // [MỚI] Thêm controller học kỳ

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject?.name ?? '');
    _creditsController =
        TextEditingController(text: widget.subject?.credit.toString() ?? '');
    _scoreController =
        TextEditingController(text: widget.subject?.score.toString() ?? '');
    // Lấy dữ liệu học kỳ cũ hoặc để trống
    _semesterController =
        TextEditingController(text: widget.subject?.semester ?? '');
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final credits = int.parse(_creditsController.text);
      final score = double.parse(_scoreController.text.replaceAll(',', '.'));
      final semester = _semesterController.text; // Lấy text học kỳ

      final provider = Provider.of<SubjectProvider>(context, listen: false);

      if (widget.subject == null) {
        final newSubject = Subject(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          credit: credits,
          score: score,
          semester: semester, // Lưu học kỳ
        );
        provider.addSubject(newSubject);
      } else {
        final updatedSubject = widget.subject!.copyWith(
          name: name,
          credit: credits,
          score: score,
          semester: semester, // Lưu học kỳ
        );
        provider.updateSubject(updatedSubject);
      }
      Navigator.pop(context);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: validator,
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subject != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(isEditing ? 'Cập nhật môn học' : 'Thêm môn mới',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)]),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white, // Chữ màu trắng
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Thông tin cơ bản",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _nameController,
                label: 'Tên môn học (VD: Lập trình Java)',
                icon: Icons.book_outlined,
                validator: Validators.validateName,
              ),

              // [MỚI] Ô nhập Học kỳ
              _buildTextField(
                controller: _semesterController,
                label: 'Học kỳ (VD: HK1 2024)',
                icon: Icons.calendar_today_outlined,
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _creditsController,
                      label: 'Tín chỉ',
                      icon: Icons.layers_outlined,
                      type: TextInputType.number,
                      validator: Validators.validateCredits,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _scoreController,
                      label: 'Điểm số',
                      icon: Icons.score_outlined,
                      type:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: Validators.validateScore,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5)),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('LƯU LẠI',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
