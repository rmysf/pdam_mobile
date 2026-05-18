import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/dummy_users.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  // ─── Text Controllers ───────────────────────────────────────────────────────
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final nomorMeterController = TextEditingController();
  final passwordController = TextEditingController();
  final konfirmasiPasswordController = TextEditingController();

  // ─── Observable State ───────────────────────────────────────────────────────
  var isPasswordVisible = false.obs;
  var isKonfirmasiPasswordVisible = false.obs;
  var isLoading = false.obs;

  // ─── Toggle Visibility ──────────────────────────────────────────────────────
  void togglePassword() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleKonfirmasiPassword() =>
      isKonfirmasiPasswordVisible.value = !isKonfirmasiPasswordVisible.value;

  // ─── Register ───────────────────────────────────────────────────────────────
  Future<void> register() async {
    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    final nomorMeter = nomorMeterController.text.trim();
    final password = passwordController.text.trim();
    final konfirmasi = konfirmasiPasswordController.text.trim();

    // Validasi field kosong
    if (nama.isEmpty ||
        email.isEmpty ||
        nomorMeter.isEmpty ||
        password.isEmpty ||
        konfirmasi.isEmpty) {
      _showError('Gagal', 'Semua field harus diisi');
      return;
    }

    // Validasi email
    if (!GetUtils.isEmail(email)) {
      _showError('Gagal', 'Format email tidak valid');
      return;
    }

    // Validasi panjang password
    if (password.length < 6) {
      _showError('Gagal', 'Password minimal 6 karakter');
      return;
    }

    // Validasi kecocokan password
    if (password != konfirmasi) {
      _showError('Gagal', 'Password dan konfirmasi tidak cocok');
      return;
    }

    // Cek email sudah terdaftar
    final sudahAda = DummyUsers.users.any((u) => u['email'] == email);
    if (sudahAda) {
      _showError('Gagal', 'Email sudah terdaftar');
      return;
    }

    // Simulasi proses simpan
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    // Tambah ke data dummy
    DummyUsers.users.add({
      'email': email,
      'password': password,
      'role': 'pelanggan',
      'nama': nama,
      'nomorMeter': nomorMeter,
    });

    isLoading.value = false;

    // Tampilkan dialog sukses
    _showSuccessDialog(nama);
  }

  // ─── Dialog Sukses ──────────────────────────────────────────────────────────
  void _showSuccessDialog(String nama) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ikon centang animasi
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF0a3d5c).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF0a3d5c),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Akun Berhasil Dibuat!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Selamat, $nama! Akun pelanggan Anda telah berhasil didaftarkan. Silakan masuk untuk melanjutkan.',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6b7280),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // tutup dialog
                    Get.offNamed(Routes.LOGIN);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0a3d5c),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Masuk Sekarang',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helper ─────────────────────────────────────────────────────────────────
  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 10,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    nomorMeterController.dispose();
    passwordController.dispose();
    konfirmasiPasswordController.dispose();
    super.onClose();
  }
}