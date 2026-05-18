import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/beranda_pelanggan_controller.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f7fa),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _HomeHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                const _UsageSummaryCard(),
                const SizedBox(height: 16),
                const _PrediksiCard(),
                const SizedBox(height: 16),
                const _UsageLimitCard(),
                const SizedBox(height: 20),
                const _InsightSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── HEADER ──────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPelangganController>();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0e4a6e), Color(0xFF1a6fa8)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white30, width: 1.5),
                    ),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selamat Pagi,',
                            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12)),
                        Text(c.namaUser,
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  _HeaderStat(c.tagihanBulanIni, 'Tagihan Bulan Ini'),
                  Container(width: 1, height: 36, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 16)),
                  _HeaderStat(c.pemakaianBerjalan, 'Pemakaian Berjalan'),
                  Container(width: 1, height: 36, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 16)),
                  _HeaderStat(c.jatuhTempo, 'Jatuh Tempo'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeaderStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
        ],
      ),
    );
  }
}

// ─── USAGE SUMMARY ───────────────────────────────────────────────────────────

class _UsageSummaryCard extends StatelessWidget {
  const _UsageSummaryCard();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPelangganController>();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pemakaian Bulan Ini',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Normal', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10b981))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${c.pemakaianValue.toInt()}',
                  style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF0e4a6e))),
              const Text(' m³', style: TextStyle(fontSize: 18, color: Color(0xFF6b7280), fontWeight: FontWeight.w500)),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Batas: ${c.batasPemakaian.toInt()} m³',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF9ca3af))),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      text: '${(c.progressPemakaian * 100).toInt()}%',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0e4a6e)),
                      children: const [
                        TextSpan(text: ' digunakan', style: TextStyle(fontSize: 12, color: Color(0xFF9ca3af), fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: c.progressPemakaian,
              backgroundColor: const Color(0xFFe5e7eb),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0e4a6e)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('0 m³', style: TextStyle(fontSize: 10, color: Color(0xFF9ca3af))),
              Text(
                'Sisa ${(c.batasPemakaian - c.pemakaianValue).toInt()} m³ dari batas',
                style: TextStyle(fontSize: 10, color: Colors.orange.shade700, fontWeight: FontWeight.w500),
              ),
              Text('${c.batasPemakaian.toInt()} m³', style: const TextStyle(fontSize: 10, color: Color(0xFF9ca3af))),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFf3f4f6)),
          Row(
            children: [
              _SmallStat('Juli 2025', c.pemakaianBulanLalu, 'Bulan Lalu', const Color(0xFF9ca3af)),
              Container(width: 1, height: 28, color: const Color(0xFFe5e7eb), margin: const EdgeInsets.symmetric(horizontal: 12)),
              _SmallStat('Agustus 2025', c.pemakaianBulanIni, 'Bulan Ini', const Color(0xFF0e4a6e)),
              Container(width: 1, height: 28, color: const Color(0xFFe5e7eb), margin: const EdgeInsets.symmetric(horizontal: 12)),
              _SmallStat('Selisih', c.selisihPemakaian, 'vs Bulan Lalu', const Color(0xFF10b981)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;
  const _SmallStat(this.label, this.value, this.sub, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 10, color: Color(0xFF9ca3af)), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─── PREDIKSI CARD ───────────────────────────────────────────────────────────

class _PrediksiCard extends StatelessWidget {
  const _PrediksiCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0e4a6e), Color(0xFF1d8abf)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0e4a6e).withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Prediksi Bulan Depan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: const Text('AI Forecast', style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimasi Pemakaian', style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11)),
                    const SizedBox(height: 4),
                    const Text('20–22 m³',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimasi Tagihan', style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11)),
                    const SizedBox(height: 4),
                    const Text('Rp 92.000',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.trending_up_rounded, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('Pemakaian Cenderung Naik ↑ +11%',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text('*Estimasi berdasarkan tren historis, bukan nilai pasti tagihan.',
              style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 10)),
        ],
      ),
    );
  }
}

// ─── USAGE LIMIT ─────────────────────────────────────────────────────────────

class _UsageLimitCard extends StatelessWidget {
  const _UsageLimitCard();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPelangganController>();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFf59e0b).withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFfef3c7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.notifications_active_rounded, color: Color(0xFFf59e0b), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Peringatan Batas Pemakaian',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text(
                  'Pemakaian sudah mencapai ${(c.progressPemakaian * 100).toInt()}% dari batas ${c.batasPemakaian.toInt()} m³. Segera pantau konsumsi Anda.',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF6b7280), height: 1.4),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF9ca3af), size: 18),
        ],
      ),
    );
  }
}

// ─── INSIGHT SECTION ─────────────────────────────────────────────────────────

class _InsightSection extends StatelessWidget {
  const _InsightSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Insight & Tips Hemat Air',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
        const SizedBox(height: 12),
        _InsightCard(
          icon: Icons.compare_arrows_rounded,
          title: 'Perbandingan Komunitas',
          desc: 'Pemakaian Anda 18 m³ berada di bawah rata-rata wilayah Kelurahan Sukasari (21 m³). Bagus!',
          badge: 'Di Bawah Rata-rata',
          badgeColor: const Color(0xFF10b981),
          bgColor: const Color(0xFFf0fdf4),
          iconColor: const Color(0xFF10b981),
        ),
        const SizedBox(height: 10),
        _InsightCard(
          icon: Icons.lightbulb_outline_rounded,
          title: 'Tips Hemat Air',
          desc: 'Cek kondisi pipa dan kran di rumah secara berkala. Kebocoran kecil bisa membuang hingga 20 liter/hari.',
          badge: 'Rekomendasi',
          badgeColor: const Color(0xFF1a6fa8),
          bgColor: const Color(0xFFf0f9ff),
          iconColor: const Color(0xFF1a6fa8),
        ),
        const SizedBox(height: 10),
        _InsightCard(
          icon: Icons.water_drop_outlined,
          title: 'Gunakan Shower',
          desc: 'Beralih dari bak mandi ke shower dapat menghemat hingga 60 liter per mandi.',
          badge: 'Tips Efisiensi',
          badgeColor: const Color(0xFF8b5cf6),
          bgColor: const Color(0xFFfaf5ff),
          iconColor: const Color(0xFF8b5cf6),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final String badge;
  final Color badgeColor;
  final Color bgColor;
  final Color iconColor;

  const _InsightCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.badge,
    required this.badgeColor,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(badge, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: badgeColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFF6b7280), height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
