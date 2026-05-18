import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/beranda_pelanggan_controller.dart';

class RiwayatTab extends StatelessWidget {
  const RiwayatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPelangganController>();

    final int maxPemakaian = c.riwayatData.isEmpty
        ? 1
        : c.riwayatData
              .map((d) => d['pemakaian'] as int)
              .reduce((a, b) => a > b ? a : b);

    const double chartHeight = 100.0; // tinggi area bar saja
    const double labelHeight = 20.0; // tinggi label angka atas
    const double monthHeight = 20.0; // tinggi label bulan bawah

    return Scaffold(
      backgroundColor: const Color(0xFFf5f7fa),
      appBar: AppBar(
        title: const Text(
          'Riwayat Pemakaian',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color(0xFF0e4a6e),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tren 6 Bulan Terakhir',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Pemakaian air (m³) per bulan',
                    style: TextStyle(fontSize: 11, color: Color(0xFF9ca3af)),
                  ),
                  const SizedBox(height: 20),
                  // FIX: tinggi SizedBox = label atas + bar + label bawah
                  SizedBox(
                    height: labelHeight + chartHeight + monthHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: c.riwayatData.reversed.map((d) {
                        final isLatest = d['status'] == 'Berjalan';
                        final double ratio =
                            (d['pemakaian'] as int) / maxPemakaian.toDouble();
                        final double clampedRatio = ratio.clamp(0.25, 1.0);
                        final double barHeight = chartHeight * clampedRatio;

                        return SizedBox(
                          width: 36,
                          height: labelHeight + chartHeight + monthHeight,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Label angka — fixed height agar tidak overflow
                              SizedBox(
                                height: labelHeight,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    '${d['pemakaian']}',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: isLatest
                                          ? const Color(0xFF0e4a6e)
                                          : const Color(0xFF9ca3af),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Area bar — expand sisa ruang
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: 28,
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      color: isLatest
                                          ? const Color(0xFF0e4a6e)
                                          : const Color(
                                              0xFF00b4d8,
                                            ).withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Label bulan — fixed height
                              SizedBox(
                                height: monthHeight,
                                child: Text(
                                  (d['bulan'] as String).substring(0, 3),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF9ca3af),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Riwayat',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            ...c.riwayatData.map((d) => _RiwayatItem(data: d)),
          ],
        ),
      ),
    );
  }
}

class _RiwayatItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const _RiwayatItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isBerjalan = data['status'] == 'Berjalan';
    final statusColor = isBerjalan
        ? const Color(0xFF1a6fa8)
        : const Color(0xFF10b981);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.water_drop_rounded,
                    color: statusColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['bulan'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${data['pemakaian']} m³ pemakaian',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6b7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data['tagihan'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data['status'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFf9fafb),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                _MeterDetail('Stand Awal', '${data['awal']}'),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: Color(0xFF9ca3af),
                ),
                const SizedBox(width: 8),
                _MeterDetail('Stand Akhir', '${data['akhir']}'),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Icon(
                        Icons.photo_camera_outlined,
                        size: 13,
                        color: Color(0xFF1a6fa8),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Lihat Bukti Foto',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF1a6fa8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MeterDetail extends StatelessWidget {
  final String label;
  final String value;
  const _MeterDetail(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Color(0xFF9ca3af)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}
