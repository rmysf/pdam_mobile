import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/controllers/beranda_petugas_controller.dart';

// ══════════════════════════════════════════════════════════════════════════════
// TAB 3 — RIWAYAT
// ══════════════════════════════════════════════════════════════════════════════

class RiwayatTab extends StatelessWidget {
  const RiwayatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPetugasController>();
    return Scaffold(
      backgroundColor: const Color(0xFFf5f7fa),
      appBar: AppBar(
        title: const Text('Riwayat Tugas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF0e4a6e),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: c.riwayat.length,
        itemBuilder: (_, i) {
          final r = c.riwayat[i];
          final double pct = r['selesai'] / r['total'];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r['tanggal'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF111827))),
                    Text('${r['selesai']} / ${r['total']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0a3d5c))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(r['zona'], style: const TextStyle(fontSize: 11, color: Color(0xFF6b7280))),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: const Color(0xFFe5e7eb),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      pct >= 1.0 ? const Color(0xFF10b981) : const Color(0xFF00b4d8),
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
