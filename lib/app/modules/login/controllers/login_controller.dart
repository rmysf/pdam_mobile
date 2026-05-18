import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/dummy_users.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  // Toggle password
  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Login utama
  void login() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final user = DummyUsers.users.firstWhere(
      (element) => element['email'] == email && element['password'] == password,
      orElse: () => {},
    );

    isLoading.value = false;

    if (user.isEmpty) {
      Get.snackbar(
        'Login Gagal',
        'Email atau password salah',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Role otomatis
    if (user['role'] == 'petugas') {
      Get.offAllNamed(Routes.BERANDA_PETUGAS);
    } else {
      Get.offAllNamed(Routes.BERANDA_PELANGGAN);
    }
  }

  // Dummy login google
  void loginGoogle() {
    Get.snackbar(
      'Google Login',
      'Fitur Belum Tersedia',
      snackPosition: SnackPosition.TOP,
    );
  }

  // Ke halaman register
  void goToRegister() {
    Get.snackbar(
      'Register',
      'Halaman register belum tersedia',
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
