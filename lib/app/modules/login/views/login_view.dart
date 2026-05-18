import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdam_apps/app/modules/login/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
              // Logo
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 32),
                  child: Image.asset(
                    'assets/images/AcuRead.png',
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Judul
              const Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Masuk untuk melanjutkan',
                style: TextStyle(fontSize: 14, color: Color(0xFF6b7280)),
              ),
              const SizedBox(height: 28),

              // Field Email
              _buildTextField(
                controller: controller.emailController,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              // Field Password
              Obx(() => _buildPasswordField()),
              const SizedBox(height: 8),

              // Lupa Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Lupa Password ?',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF0a3d5c),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Masuk
              Obx(() => _buildPrimaryButton()),
              const SizedBox(height: 24),

              // Divider Atau
              _buildOrDivider(),
              const SizedBox(height: 20),

              // Tombol Google
              _buildGoogleButton(),
              const SizedBox(height: 28),

              // Link Daftar
              Center(
                child: GestureDetector(
                  onTap: controller.goToRegister,
                  child: RichText(
                    text: const TextSpan(
                      text: 'Belum Punya Akun? ',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6b7280)),
                      children: [
                        TextSpan(
                          text: 'Daftar Sekarang',
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HELPER BUILDER ───────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFadb5bd), fontSize: 15),
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

  Widget _buildPasswordField() {
    return TextField(
      controller: controller.passwordController,
      obscureText: !controller.isPasswordVisible.value,
      style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(color: Color(0xFFadb5bd), fontSize: 15),
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
            controller.isPasswordVisible.value
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFF9ca3af),
            size: 20,
          ),
          onPressed: controller.togglePassword,
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.login,
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
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Masuk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFe5e7eb))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'Atau',
            style: TextStyle(fontSize: 13, color: Color(0xFF9ca3af)),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFe5e7eb))),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: controller.loginGoogle,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFe5e7eb)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon G Google 4 warna
            SizedBox(
              width: 22,
              height: 22,
              child: CustomPaint(painter: _GoogleIconPainter()),
            ),
            const SizedBox(width: 10),
            const Text(
              'Masuk Dengan Google',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Google Icon Painter ──────────────────────────────────────────────────────
class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Rect.fromCircle(
      center: Offset(w / 2, h / 2),
      radius: w * 0.46,
    );
    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFF34A853),
      const Color(0xFFFBBC05),
      const Color(0xFFEA4335),
    ];
    final angles = [
      [0.0, 1.57],
      [1.57, 1.57],
      [3.14, 0.79],
      [3.93, 1.00],
    ];
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 4; i++) {
      paint.color = colors[i];
      canvas.drawArc(rect, angles[i][0], angles[i][1], false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
