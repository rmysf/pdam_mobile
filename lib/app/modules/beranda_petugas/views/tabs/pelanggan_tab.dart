import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/controllers/beranda_petugas_controller.dart';

// ══════════════════════════════════════════════════════════════════════════════
// TAB 1 — PELANGGAN
// ══════════════════════════════════════════════════════════════════════════════

class PelangganTab extends StatelessWidget {
  const PelangganTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPetugasController>();
    return Scaffold(
      backgroundColor: const Color(0xFFf5f7fa),
      appBar: AppBar(
        title: const Text('Data Pelanggan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF0e4a6e),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [IconButton(icon: const Icon(Icons.search_rounded, color: Colors.white), onPressed: () {})],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: c.pelanggan.length,
        itemBuilder: (_, i) {
          final p = c.pelanggan[i];
          final bool lunas = p['lunas'];
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
                  width: 42, height: 42,
                  decoration: BoxDecoration(color: const Color(0xFF0a3d5c).withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(p['nama'][0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0a3d5c)))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['nama'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF111827))),
                      Text('No. Meter: ${p['meter']}', style: const TextStyle(fontSize: 11, color: Color(0xFF9ca3af))),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Rp ${p['tagihan']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF111827))),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: lunas ? const Color(0xFF10b981).withOpacity(0.1) : const Color(0xFFf59e0b).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        lunas ? 'Lunas' : 'Belum Bayar',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: lunas ? const Color(0xFF10b981) : const Color(0xFFf59e0b)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
