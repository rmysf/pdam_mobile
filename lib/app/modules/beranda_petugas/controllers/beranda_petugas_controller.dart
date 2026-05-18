import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdam_apps/app/routes/app_pages.dart';
import 'package:pdam_apps/app/modules/notifikasi/controllers/notifikasi_controller.dart';

class BerandaPetugasController extends GetxController {
  // ─── NOTIFIKASI ─────────────────────────────────────────────────
  late final NotifikasiController notifController;

  @override
  void onInit() {
    super.onInit();
    notifController = Get.put(NotifikasiController());
  }

  // ─── NAVBAR ─────────────────────────────────────────────────────
  final RxInt navIndex = 0.obs;
  void changeTab(int i) => navIndex.value = i;

  // ─── DATA PETUGAS ───────────────────────────────────────────────
  final String officerName = 'Budi Santoso';

  final RxInt totalTugas = 20.obs;
  final RxInt selesai    = 16.obs;
  final RxInt belum      = 1.obs;
  final RxInt anomali    = 2.obs;

  double get progress => selesai.value / totalTugas.value;

  String get greeting {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat Pagi';
    if (h < 15) return 'Selamat Siang';
    if (h < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  // ─── DATA DUMMY ─────────────────────────────────────────────────
  final List<Map<String, dynamic>> tugas = [
    {'nama': 'Ahmad Fauzi',    'alamat': 'Jl. Melati No. 12',     'meter': '1234567890', 'status': 'selesai', 'jam': '08:15'},
    {'nama': 'Dewi Lestari',   'alamat': 'Jl. Mawar No. 5',       'meter': '0987654321', 'status': 'selesai', 'jam': '09:02'},
    {'nama': 'Hendra Wijaya',  'alamat': 'Jl. Kenanga Blok C/8',  'meter': '1122334455', 'status': 'anomali', 'jam': '09:45'},
    {'nama': 'Siti Nurhaliza', 'alamat': 'Perum. Griya Indah 22', 'meter': '5566778899', 'status': 'belum',   'jam': '-'},
    {'nama': 'Rudi Hartono',   'alamat': 'Jl. Flamboyan No. 3',   'meter': '9988776655', 'status': 'selesai', 'jam': '10:20'},
  ];

  final List<Map<String, dynamic>> pelanggan = [
    {'nama': 'Ahmad Fauzi',    'meter': '1234567890', 'tagihan': '145.000', 'lunas': true},
    {'nama': 'Dewi Lestari',   'meter': '0987654321', 'tagihan': '87.500',  'lunas': false},
    {'nama': 'Hendra Wijaya',  'meter': '1122334455', 'tagihan': '210.000', 'lunas': true},
    {'nama': 'Siti Nurhaliza', 'meter': '5566778899', 'tagihan': '67.000',  'lunas': false},
    {'nama': 'Rudi Hartono',   'meter': '9988776655', 'tagihan': '198.000', 'lunas': true},
  ];

  final List<Map<String, dynamic>> riwayat = [
    {'tanggal': '10 Mei 2025', 'selesai': 18, 'total': 20, 'zona': 'Zona A – Tangerang Selatan'},
    {'tanggal': '09 Mei 2025', 'selesai': 20, 'total': 20, 'zona': 'Zona B – Ciputat'},
    {'tanggal': '08 Mei 2025', 'selesai': 15, 'total': 20, 'zona': 'Zona C – Pamulang'},
  ];

  void onScan() {
    Get.snackbar(
      'Fitur Scan', 'Kamera AI akan aktif di versi produksi.',
      backgroundColor: const Color(0xFF0a3d5c),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 10,
      icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
    );
  }

  // ─── LOGOUT ─────────────────────────────────────────────────────
  void logout() => Get.offAllNamed(Routes.LOGIN);
}
