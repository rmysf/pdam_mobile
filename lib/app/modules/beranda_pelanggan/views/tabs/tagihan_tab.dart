import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/beranda_pelanggan_controller.dart';

class TagihanTab extends StatelessWidget {
  const TagihanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPelangganController>();
    return Scaffold(
      backgroundColor: const Color(0xFFf5f7fa),
      appBar: AppBar(
        title: const Text('Tagihan Saya',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF0e4a6e),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          children: [
            // Tagihan aktif card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0e4a6e), Color(0xFF1a6fa8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0e4a6e).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Tagihan ${c.periodeTagihan}',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange.withOpacity(0.5)),
                        ),
                        child: Text(c.statusTagihan,
                            style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(c.nominalTagihan,
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _BillDetail('Pemakaian', c.pemakaianBerjalan),
                      const SizedBox(width: 24),
                      _BillDetail('Jatuh Tempo', c.jatuhTempoTagihan),
                      const SizedBox(width: 24),
                      _BillDetail('ID Pelanggan', c.idPelanggan),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0e4a6e),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Bayar Sekarang',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Rincian biaya
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rincian Tagihan',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  SizedBox(height: 14),
                  _BillRow('Biaya Pemakaian Air (18 m³)', 'Rp 63.000'),
                  _BillRow('Biaya Administrasi', 'Rp 5.000'),
                  _BillRow('Biaya Pemeliharaan', 'Rp 7.500'),
                  _BillRow('PPN 10%', 'Rp 7.550'),
                  Divider(height: 20, color: Color(0xFFe5e7eb)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Tagihan',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      Text('Rp 83.050',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0e4a6e))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Verifikasi meter
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFf0f9ff),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF0e4a6e).withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified_outlined, color: Color(0xFF0e4a6e), size: 18),
                      SizedBox(width: 8),
                      Text('Verifikasi Data Meter',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0e4a6e))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _VerifRow('Angka Awal', '1.240'),
                  const _VerifRow('Angka Akhir', '1.258'),
                  const _VerifRow('Tanggal Baca', '5 Agustus 2025'),
                  const _VerifRow('Petugas', 'Ahmad Fauzi'),
                  const _VerifRow('GPS', 'Kec. Sukasari, Bandung'),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFe0f2fe),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.shield_outlined, size: 14, color: Color(0xFF0e4a6e)),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hash SHA-256 Terverifikasi',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0e4a6e))),
                              Text('a3f2...d9e1 · Data tidak dimanipulasi',
                                  style: TextStyle(fontSize: 10, color: Color(0xFF6b7280))),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text('Lihat Foto',
                              style: TextStyle(fontSize: 11, color: Color(0xFF1a6fa8), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Ajukan komplain
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () => c.changeTab(3),
                icon: const Icon(Icons.report_problem_outlined, size: 18),
                label: const Text('Ajukan Komplain / Keberatan'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFef4444),
                  side: const BorderSide(color: Color(0xFFef4444)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillDetail extends StatelessWidget {
  final String label;
  final String value;
  const _BillDetail(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 10)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  const _BillRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6b7280))),
          Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF374151), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _VerifRow extends StatelessWidget {
  final String label;
  final String value;
  const _VerifRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9ca3af))),
          ),
          Text(': $value', style: const TextStyle(fontSize: 11, color: Color(0xFF374151), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
