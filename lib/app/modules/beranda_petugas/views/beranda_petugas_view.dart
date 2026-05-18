import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/controllers/beranda_petugas_controller.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/views/tabs/home_tab.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/views/tabs/pelanggan_tab.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/views/tabs/scan_tab.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/views/tabs/riwayat_tab.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/views/tabs/profile_tab.dart';

class BerandaPetugasView extends GetView<BerandaPetugasController> {
  const BerandaPetugasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isScanActive = controller.navIndex.value == 2;

      return Scaffold(
        // Saat scan aktif, biarkan konten mengisi sampai bawah (extendBody)
        extendBody: isScanActive,
        body: IndexedStack(
          index: controller.navIndex.value,
          children: const [
            HomeTab(),
            PelangganTab(),
            ScanTab(),
            RiwayatTab(),
            ProfileTab(),
          ],
        ),
        // Sembunyikan navbar sepenuhnya saat tab Scan aktif
        bottomNavigationBar: isScanActive
            ? null
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        _NavItem(0, Icons.home_rounded, Icons.home_outlined,
                            'Beranda', controller),
                        _NavItem(1, Icons.people_rounded,
                            Icons.people_outline_rounded, 'Pelanggan', controller),
                        _ScanButton(controller),
                        _NavItem(3, Icons.history_rounded,
                            Icons.history_outlined, 'Riwayat', controller),
                        _NavItem(4, Icons.person_rounded,
                            Icons.person_outline_rounded, 'Profil', controller),
                      ],
                    ),
                  ),
                ),
              ),
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final BerandaPetugasController controller;

  const _NavItem(this.index, this.activeIcon, this.inactiveIcon, this.label,
      this.controller);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool active = controller.navIndex.value == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => controller.navIndex.value = index,
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(active ? activeIcon : inactiveIcon,
                  color: active
                      ? const Color(0xFF0e4a6e)
                      : const Color(0xFF9ca3af),
                  size: 22),
              const SizedBox(height: 2),
              Text(label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                        active ? FontWeight.bold : FontWeight.normal,
                    color: active
                        ? const Color(0xFF0e4a6e)
                        : const Color(0xFF9ca3af),
                  )),
            ],
          ),
        ),
      );
    });
  }
}

class _ScanButton extends StatelessWidget {
  final BerandaPetugasController controller;
  const _ScanButton(this.controller);

  Future<void> _onTap() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      // Izin sudah ada, langsung buka scan
      controller.navIndex.value = 2;
    } else if (status.isPermanentlyDenied) {
      // User pernah tolak permanen → arahkan ke Settings
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Izin Kamera Diperlukan'),
          content: const Text(
            'Akses kamera diblokir. Buka Pengaturan dan aktifkan izin kamera untuk menggunakan fitur scan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0e4a6e),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Buka Pengaturan'),
            ),
          ],
        ),
      );
    } else {
      // Belum pernah diminta → tampilkan dialog izin sistem
      final result = await Permission.camera.request();
      if (result.isGranted) {
        controller.navIndex.value = 2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: _onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0e4a6e), Color(0xFF1a6fa8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: controller.navIndex.value == 2
                        ? [
                            BoxShadow(
                              color: const Color(0xFF0e4a6e).withOpacity(0.45),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                  ),
                  child: const Icon(Icons.crop_free_rounded,
                      color: Colors.white, size: 24),
                )),
          ],
        ),
      ),
    );
  }
}