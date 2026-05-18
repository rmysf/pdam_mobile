import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/notifikasi_model.dart';

// ══════════════════════════════════════════════════════════════════════════════
// CONTROLLER — NotifikasiController
// ══════════════════════════════════════════════════════════════════════════════

class NotifikasiController extends GetxController {
  // Daftar notifikasi reaktif
  final RxList<NotifikasiItem> items = <NotifikasiItem>[].obs;

  // Jumlah notifikasi belum dibaca
  int get unreadCount => items.where((n) => !n.sudahDibaca).length;

  // Apakah ada notifikasi baru (untuk badge)
  bool get hasUnread => unreadCount > 0;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  // ─── DUMMY DATA ─────────────────────────────────────────────────────────────
  void _loadDummyData() {
    items.assignAll([
      const NotifikasiItem(
        id: 'n001',
        tipe: NotifikasiTipe.komplainMasuk,
        judul: 'Komplain Baru Masuk',
        isi: 'Pelanggan Dewi Lestari (No. Meter: 0987654321) melaporkan air tidak mengalir sejak pagi.',
        waktu: '5 menit lalu',
        sudahDibaca: false,
      ),
      const NotifikasiItem(
        id: 'n002',
        tipe: NotifikasiTipe.komplainMasuk,
        judul: 'Komplain Baru Masuk',
        isi: 'Pelanggan Rudi Hartono (No. Meter: 9988776655) melaporkan tagihan tidak sesuai.',
        waktu: '23 menit lalu',
        sudahDibaca: false,
      ),
      const NotifikasiItem(
        id: 'n003',
        tipe: NotifikasiTipe.updateStatus,
        judul: 'Status Komplain Diperbarui',
        isi: 'Komplain Ahmad Fauzi telah ditandai selesai oleh Petugas Area Zona A.',
        waktu: '1 jam lalu',
        sudahDibaca: false,
      ),
      const NotifikasiItem(
        id: 'n004',
        tipe: NotifikasiTipe.infoSistem,
        judul: 'Pemeliharaan Sistem',
        isi: 'Sistem akan menjalani pemeliharaan rutin pada 12 Mei 2026 pukul 00.00–02.00 WIB.',
        waktu: '3 jam lalu',
        sudahDibaca: true,
      ),
      const NotifikasiItem(
        id: 'n005',
        tipe: NotifikasiTipe.komplainMasuk,
        judul: 'Komplain Baru Masuk',
        isi: 'Pelanggan Siti Nurhaliza (No. Meter: 5566778899) melaporkan tekanan air lemah.',
        waktu: 'Kemarin, 15:42',
        sudahDibaca: true,
      ),
      const NotifikasiItem(
        id: 'n006',
        tipe: NotifikasiTipe.updateStatus,
        judul: 'Status Komplain Diperbarui',
        isi: 'Komplain Hendra Wijaya (anomali meter) telah diteruskan ke tim teknis.',
        waktu: 'Kemarin, 10:15',
        sudahDibaca: true,
      ),
    ]);
  }

  // ─── ACTIONS ────────────────────────────────────────────────────────────────

  /// Tandai satu notifikasi sudah dibaca
  void tandaiDibaca(String id) {
    final idx = items.indexWhere((n) => n.id == id);
    if (idx != -1 && !items[idx].sudahDibaca) {
      items[idx] = items[idx].copyWith(sudahDibaca: true);
      items.refresh();
    }
  }

  /// Tandai semua sudah dibaca
  void tandaiSemuaDibaca() {
    items.value = items.map((n) => n.copyWith(sudahDibaca: true)).toList();
  }

  /// Simulasi notifikasi baru masuk (misalnya dari push)
  void tambahNotifikasiKomplain({
    required String namaPelanggan,
    required String nomorMeter,
    required String pesan,
  }) {
    final now = DateTime.now();
    final newItem = NotifikasiItem(
      id: 'n${now.millisecondsSinceEpoch}',
      tipe: NotifikasiTipe.komplainMasuk,
      judul: 'Komplain Baru Masuk',
      isi: 'Pelanggan $namaPelanggan (No. Meter: $nomorMeter) $pesan',
      waktu: 'Baru saja',
      sudahDibaca: false,
    );
    items.insert(0, newItem);
    _showInAppBanner(newItem);
  }

  /// In-app banner / snackbar saat notifikasi masuk
  void _showInAppBanner(NotifikasiItem item) {
    Get.snackbar(
      item.judul,
      item.isi,
      backgroundColor: const Color(0xFF0a3d5c),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.fromLTRB(14, 50, 14, 0),
      borderRadius: 14,
      duration: const Duration(seconds: 4),
      icon: Icon(
        _tipeIcon(item.tipe),
        color: _tipeBadgeColor(item.tipe),
        size: 22,
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.back();
          tandaiDibaca(item.id);
        },
        child: const Text('Lihat', style: TextStyle(color: Color(0xFF5bc8f5), fontWeight: FontWeight.bold)),
      ),
    );
  }

  // ─── HELPERS ────────────────────────────────────────────────────────────────
  static IconData tipeIcon(NotifikasiTipe t) => _tipeIcon(t);
  static Color tipeBadgeColor(NotifikasiTipe t) => _tipeBadgeColor(t);
  static String tipeLabel(NotifikasiTipe t) => _tipeLabel(t);

  static IconData _tipeIcon(NotifikasiTipe t) {
    switch (t) {
      case NotifikasiTipe.komplainMasuk: return Icons.report_problem_rounded;
      case NotifikasiTipe.updateStatus:  return Icons.sync_rounded;
      case NotifikasiTipe.infoSistem:    return Icons.info_rounded;
    }
  }

  static Color _tipeBadgeColor(NotifikasiTipe t) {
    switch (t) {
      case NotifikasiTipe.komplainMasuk: return const Color(0xFFef4444);
      case NotifikasiTipe.updateStatus:  return const Color(0xFF3b82f6);
      case NotifikasiTipe.infoSistem:    return const Color(0xFFf59e0b);
    }
  }

  static String _tipeLabel(NotifikasiTipe t) {
    switch (t) {
      case NotifikasiTipe.komplainMasuk: return 'Komplain';
      case NotifikasiTipe.updateStatus:  return 'Status';
      case NotifikasiTipe.infoSistem:    return 'Info';
    }
  }
}
