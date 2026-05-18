import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/controllers/beranda_petugas_controller.dart';

// ══════════════════════════════════════════════════════════════════════════════
// CONTROLLER — SCAN TAB
// ══════════════════════════════════════════════════════════════════════════════

class ScanTabController extends GetxController {
  // ── Kamera ──────────────────────────────────────────────────────────────────
  CameraController? cameraController;
  final RxBool cameraReady = false.obs;
  final RxString cameraError = ''.obs;

  // ── State scan ───────────────────────────────────────────────────────────────
  /// null = belum scan, true = kualitas OK, false = kurang jelas
  final RxnBool imageQuality = RxnBool();
  final RxBool flashOn = false.obs;
  final RxBool isProcessing = false.obs;
  final RxString meterResult = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  // ── Inisialisasi kamera ──────────────────────────────────────────────────────
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        cameraError.value = 'Tidak ada kamera yang tersedia';
        return;
      }

      // Ambil kamera belakang
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await cameraController!.initialize();
      cameraReady.value = true;
    } catch (e) {
      cameraError.value = 'Gagal membuka kamera: $e';
    }
  }

  // ── Toggle flash ─────────────────────────────────────────────────────────────
  Future<void> toggleFlash() async {
    if (cameraController == null || !cameraReady.value) return;
    flashOn.toggle();
    await cameraController!.setFlashMode(
      flashOn.value ? FlashMode.torch : FlashMode.off,
    );
  }

  // ── Ambil foto & proses ──────────────────────────────────────────────────────
  Future<void> captureAndScan() async {
    if (isProcessing.value) return;
    if (cameraController == null || !cameraReady.value) return;

    imageQuality.value = null;
    meterResult.value = '';
    isProcessing.value = true;

    try {
      // Ambil foto
      final XFile photo = await cameraController!.takePicture();

      // Simulasi response AI (hapus saat sudah ada API nyata)
      await Future.delayed(const Duration(milliseconds: 1500));
      final bool qualityOk = DateTime.now().second % 2 == 0;
      imageQuality.value = qualityOk;
      if (qualityOk) meterResult.value = '00007';
      // Akhir simulasi

    } catch (e) {
      imageQuality.value = false;
    } finally {
      isProcessing.value = false;
    }

    if (imageQuality.value == true) {
      _showResultSheet();
    }
  }

  void retake() {
    imageQuality.value = null;
    meterResult.value = '';
  }

  void _showResultSheet() {
    Get.bottomSheet(
      _MeterResultSheet(result: meterResult.value),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TAB 2 — SCAN  (full-screen kamera, tanpa navbar)
// ══════════════════════════════════════════════════════════════════════════════

class ScanTab extends StatelessWidget {
  const ScanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScanTabController(), tag: 'scan_tab');

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Obx(() {
        // ── Kamera belum siap ─────────────────────────────────────────────────
        if (!controller.cameraReady.value) {
          return _CameraLoadingView(error: controller.cameraError.value);
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            // 1. Preview kamera asli — full screen
            _FullScreenCamera(controller: controller),

            // 2. Masker gelap di luar area scan frame (punch-hole)
            _ScanMask(),

            // 3. Bounding box + scan line animasi
            _ScanFrame(controller: controller),

            // 4. Top bar (flash + judul)
            _TopBar(controller: controller),

            // 5. Warning banner (muncul jika kualitas buruk)
            Obx(() {
              final q = controller.imageQuality.value;
              if (q == null || q == true) return const SizedBox.shrink();
              return const _WarningBanner();
            }),

            // 6. Hint teks
            const _HintText(),

            // 7. Tombol capture
            _CaptureButton(controller: controller),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. CameraPreview full screen
// ─────────────────────────────────────────────────────────────────────────────

class _FullScreenCamera extends StatelessWidget {
  final ScanTabController controller;
  const _FullScreenCamera({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cam = controller.cameraController!;
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: cam.value.previewSize!.height,
          height: cam.value.previewSize!.width,
          child: CameraPreview(cam),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Masker gelap di luar area scan frame (CustomPainter punch-hole)
// ─────────────────────────────────────────────────────────────────────────────

class _ScanMask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _MaskPainter(),
    );
  }
}

class _MaskPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double frameW = size.width * 0.78;
    final double frameH = frameW * 1.25;
    final double left = (size.width - frameW) / 2;
    final double top = (size.height - frameH) / 2;

    final RRect frameRRect = RRect.fromLTRBR(
      left, top, left + frameW, top + frameH,
      const Radius.circular(12),
    );

    final Paint maskPaint = Paint()..color = Colors.black.withOpacity(0.55);
    final Path outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path holePath = Path()..addRRect(frameRRect);
    final Path combined =
        Path.combine(PathOperation.difference, outerPath, holePath);

    canvas.drawPath(combined, maskPaint);
  }

  @override
  bool shouldRepaint(_MaskPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Bounding box + scan line animasi
// ─────────────────────────────────────────────────────────────────────────────

class _ScanFrame extends StatefulWidget {
  final ScanTabController controller;
  const _ScanFrame({required this.controller});

  @override
  State<_ScanFrame> createState() => _ScanFrameState();
}

class _ScanFrameState extends State<_ScanFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scan;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scan = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double frameW = MediaQuery.of(context).size.width * 0.78;
    final double frameH = frameW * 1.25;

    return Center(
      child: Obx(() {
        final q = widget.controller.imageQuality.value;
        final Color borderColor =
            q == false ? const Color(0xFFFF4444) : const Color(0xFF4DA8FF);

        return SizedBox(
          width: frameW,
          height: frameH,
          child: Stack(
            children: [
              // Border frame
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              // Scan line
              AnimatedBuilder(
                animation: _scan,
                builder: (_, __) => Positioned(
                  top: _scan.value * (frameH - 2),
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          borderColor.withOpacity(0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Sudut dekoratif
              ..._buildCorners(borderColor),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildCorners(Color color) {
    const double sz = 22;
    const double th = 3.0;
    const double rad = 12.0;

    Widget corner({
      required AlignmentGeometry alignment,
      required BorderRadius radius,
      required Border border,
    }) =>
        Align(
          alignment: alignment,
          child: Container(
            width: sz,
            height: sz,
            decoration: BoxDecoration(border: border, borderRadius: radius),
          ),
        );

    final BorderSide s = BorderSide(color: color, width: th);
    const BorderSide n = BorderSide.none;

    return [
      corner(
        alignment: Alignment.topLeft,
        radius: const BorderRadius.only(topLeft: Radius.circular(rad)),
        border: Border(top: s, left: s, right: n, bottom: n),
      ),
      corner(
        alignment: Alignment.topRight,
        radius: const BorderRadius.only(topRight: Radius.circular(rad)),
        border: Border(top: s, right: s, left: n, bottom: n),
      ),
      corner(
        alignment: Alignment.bottomLeft,
        radius: const BorderRadius.only(bottomLeft: Radius.circular(rad)),
        border: Border(bottom: s, left: s, top: n, right: n),
      ),
      corner(
        alignment: Alignment.bottomRight,
        radius: const BorderRadius.only(bottomRight: Radius.circular(rad)),
        border: Border(bottom: s, right: s, top: n, left: n),
      ),
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Top bar
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final ScanTabController controller;
  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Obx(() => _IconBtn(
                    icon: controller.flashOn.value
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    onTap: controller.toggleFlash,
                    active: controller.flashOn.value,
                  )),
              const Spacer(),
              const Text(
                'Scan Meter',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.3,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                ),
              ),
              const Spacer(),
              _IconBtn(
                icon: Icons.close_rounded,
                onTap: () {
                  Get.find<BerandaPetugasController>().navIndex.value = 0;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _IconBtn({required this.icon, required this.onTap, this.active = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFFFD700).withOpacity(0.25)
              : Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Icon(
          icon,
          color: active ? const Color(0xFFFFD700) : Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. Warning banner
// ─────────────────────────────────────────────────────────────────────────────

class _WarningBanner extends StatelessWidget {
  const _WarningBanner();

  @override
  Widget build(BuildContext context) {
    final double frameH = MediaQuery.of(context).size.width * 0.78 * 1.25;
    final double frameTop = (MediaQuery.of(context).size.height - frameH) / 2;

    return Positioned(
      top: frameTop - 48,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFFB800).withOpacity(0.4)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Color(0xFFFFB800), size: 18),
            SizedBox(width: 8),
            Text(
              'Gambar kurang jelas, foto ulang',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. Hint teks
// ─────────────────────────────────────────────────────────────────────────────

class _HintText extends StatelessWidget {
  const _HintText();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            'Arahkan kamera ke angka meteran',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            'Pastikan angka terlihat jelas & tidak silau',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. Tombol capture
// ─────────────────────────────────────────────────────────────────────────────

class _CaptureButton extends StatelessWidget {
  final ScanTabController controller;
  const _CaptureButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Obx(() {
        final processing = controller.isProcessing.value;
        return GestureDetector(
          onTap: controller.captureAndScan,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(processing ? 0.5 : 1.0),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: processing
                  ? const Padding(
                      padding: EdgeInsets.all(18),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Color(0xFF0e4a6e),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading / Error view kamera
// ─────────────────────────────────────────────────────────────────────────────

class _CameraLoadingView extends StatelessWidget {
  final String error;
  const _CameraLoadingView({required this.error});

  @override
  Widget build(BuildContext context) {
    final bool hasError = error.isNotEmpty;
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasError ? Icons.no_photography_rounded : Icons.camera_rounded,
              color: Colors.white38,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              hasError ? error : 'Membuka kamera...',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            if (!hasError) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF4DA8FF),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BOTTOM SHEET — HASIL PEMBACAAN METER
// ══════════════════════════════════════════════════════════════════════════════

class _MeterResultSheet extends StatelessWidget {
  final String result;
  const _MeterResultSheet({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFe8f5e9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: Color(0xFF2e7d32), size: 36),
          ),
          const SizedBox(height: 12),
          const Text(
            'Meteran Berhasil Terbaca',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pastikan angka sesuai sebelum menyimpan',
            style: TextStyle(fontSize: 12, color: Color(0xFF6b7280)),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFf0f4f8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Angka Meter (m³)',
                    style:
                        TextStyle(fontSize: 12, color: Color(0xFF6b7280))),
                const SizedBox(height: 6),
                Text(
                  result,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0e4a6e),
                    letterSpacing: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.back();
                    Get.find<ScanTabController>(tag: 'scan_tab').retake();
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Foto Ulang'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0e4a6e),
                    side: const BorderSide(color: Color(0xFF0e4a6e)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                      'Berhasil',
                      'Data meter $result m³ tersimpan',
                      backgroundColor: const Color(0xFF0e4a6e),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: const Duration(seconds: 3),
                    );
                  },
                  icon: const Icon(Icons.save_rounded, size: 16),
                  label: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0e4a6e),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}