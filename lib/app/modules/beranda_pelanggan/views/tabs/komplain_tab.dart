import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/beranda_pelanggan_controller.dart';

class KomplainTab extends StatelessWidget {
  const KomplainTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPelangganController>();
    return Scaffold(
      backgroundColor: const Color(0xFFf5f7fa),
      appBar: AppBar(
        title: const Text('Komplain & Keberatan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF0e4a6e),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form ajukan komplain
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.edit_note_rounded, color: Color(0xFF0e4a6e), size: 22),
                      SizedBox(width: 8),
                      Text('Ajukan Komplain Baru',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Isi formulir di bawah untuk mengajukan keberatan tagihan.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6b7280))),
                  const SizedBox(height: 16),

                  // Periode tagihan
                  const Text('Periode Tagihan',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf9fafb),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFe5e7eb)),
                    ),
                    child: Row(
                      children: [
                        Text(c.periodeTagihan,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
                        const Spacer(),
                        const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF9ca3af), size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Kategori — reaktif dengan Obx
                  const Text('Kategori Komplain',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                  const SizedBox(height: 8),
                  Obx(() => Wrap(
                    spacing: 8, runSpacing: 8,
                    children: c.kategoriKomplain.map((k) {
                      final selected = c.selectedKategori.value == k;
                      return GestureDetector(
                        onTap: () => c.selectKategori(k),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF0e4a6e) : const Color(0xFFf3f4f6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: selected ? const Color(0xFF0e4a6e) : const Color(0xFFe5e7eb)),
                          ),
                          child: Text(k,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : const Color(0xFF6b7280),
                              )),
                        ),
                      );
                    }).toList(),
                  )),
                  const SizedBox(height: 14),

                  // Deskripsi
                  const Text('Deskripsi Masalah',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                  const SizedBox(height: 6),
                  Container(
                    height: 90,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf9fafb),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFe5e7eb)),
                    ),
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Tulis deskripsi masalah Anda di sini (min. 20 karakter)...',
                          style: TextStyle(fontSize: 12, color: Color(0xFFc9cdd4))),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Lampiran foto
                  const Text('Lampiran Foto (Opsional)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _FotoBox(),
                      const SizedBox(width: 10),
                      _FotoBox(),
                      const SizedBox(width: 10),
                      const Text('Maks. 2 foto\n@ 5 MB',
                          style: TextStyle(fontSize: 10, color: Color(0xFF9ca3af))),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: c.kirimKomplain,
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Kirim Komplain', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0e4a6e),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text('Riwayat Komplain',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            const SizedBox(height: 12),
            ...c.riwayatKomplain.map((k) => _KomplainHistoryItem(data: k)),
          ],
        ),
      ),
    );
  }
}

class _FotoBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64, height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFf3f4f6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFe5e7eb)),
      ),
      child: const Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF9ca3af), size: 28),
    );
  }
}

class _KomplainHistoryItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const _KomplainHistoryItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final bool selesai = data['status'] == 'Diselesaikan';
    final bool ditolak = data['status'] == 'Ditolak';
    final statusColor = selesai
        ? const Color(0xFF10b981)
        : ditolak
            ? const Color(0xFFef4444)
            : const Color(0xFFf59e0b);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              selesai
                  ? Icons.check_circle_outline_rounded
                  : ditolak
                      ? Icons.cancel_outlined
                      : Icons.pending_outlined,
              color: statusColor, size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['nomor'],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text('${data['bulan']} · ${data['kategori']}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF6b7280))),
                const SizedBox(height: 2),
                Text(data['tanggal'],
                    style: const TextStyle(fontSize: 10, color: Color(0xFF9ca3af))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(data['status'],
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
          ),
        ],
      ),
    );
  }
}
