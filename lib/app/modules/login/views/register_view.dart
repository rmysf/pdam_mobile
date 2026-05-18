import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              const Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Daftarkan diri Anda sebagai pelanggan PDAM',
                style: TextStyle(fontSize: 14, color: Color(0xFF6b7280)),
              ),
              const SizedBox(height: 28),

              // ── Field Nama Lengkap ───────────────────────────────────────
              _buildLabel('Nama Lengkap'),
              const SizedBox(height: 6),
              _buildTextField(
                textController: controller.namaController,
                hint: 'Contoh: Budi Santoso',
                prefixIcon: Icons.person_outline_rounded,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),

              // ── Field Email ──────────────────────────────────────────────
              _buildLabel('Email'),
              const SizedBox(height: 6),
              _buildTextField(
                textController: controller.emailController,
                hint: 'Contoh: budi@email.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // ── Field Nomor Meter ────────────────────────────────────────
              _buildLabel('Nomor Meter'),
              const SizedBox(height: 6),
              _buildTextField(
                textController: controller.nomorMeterController,
                hint: 'Contoh: PDAM-001234',
                prefixIcon: Icons.speed_outlined,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  'Nomor meter tertera pada tagihan atau meteran air Anda',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9ca3af)),
                ),
              ),
              const SizedBox(height: 16),

              // ── Field Password ───────────────────────────────────────────
              _buildLabel('Password'),
              const SizedBox(height: 6),
              Obx(
                () => _buildPasswordField(
                  textController: controller.passwordController,
                  hint: 'Minimal 6 karakter',
                  isVisible: controller.isPasswordVisible.value,
                  onToggle: controller.togglePassword,
                ),
              ),
              const SizedBox(height: 16),

              // ── Field Konfirmasi Password ────────────────────────────────
              _buildLabel('Konfirmasi Password'),
              const SizedBox(height: 6),
              Obx(
                () => _buildPasswordField(
                  textController: controller.konfirmasiPasswordController,
                  hint: 'Ulangi password Anda',
                  isVisible: controller.isKonfirmasiPasswordVisible.value,
                  onToggle: controller.toggleKonfirmasiPassword,
                ),
              ),
              const SizedBox(height: 28),

              // ── Tombol Daftar ────────────────────────────────────────────
              Obx(() => _buildRegisterButton()),
              const SizedBox(height: 24),

              // ── Link ke Login ────────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Sudah punya akun? ',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6b7280)),
                      children: [
                        TextSpan(
                          text: 'Masuk',
                          style: TextStyle(
                            color: Color(0xFF0a3d5c),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HELPER BUILDER ────────────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController textController,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: textController,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFadb5bd), fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF9ca3af), size: 20),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFd1d5db)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0a3d5c), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController textController,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: textController,
      obscureText: !isVisible,
      style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFadb5bd), fontSize: 14),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: Color(0xFF9ca3af),
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFd1d5db)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0a3d5c), width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFF9ca3af),
            size: 20,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.register,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0a3d5c),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF0a3d5c).withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Daftar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
