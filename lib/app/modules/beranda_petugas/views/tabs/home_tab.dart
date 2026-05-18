import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/controllers/beranda_petugas_controller.dart';
import 'package:pdam_apps/app/modules/notifikasi/controllers/notifikasi_controller.dart';
import 'package:pdam_apps/app/modules/notifikasi/views/notifikasi_view.dart';
import 'package:pdam_apps/app/modules/notifikasi/models/notifikasi_model.dart' as notif_model;

// ══════════════════════════════════════════════════════════════════════════════
// TAB 0 — HOME
// ══════════════════════════════════════════════════════════════════════════════

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPetugasController>();
    return Scaffold(
      backgroundColor: const Color(0xFFf5f7fa),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: HomeHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                const TugasCard(),
                const SizedBox(height: 20),
                const KomplainMasukCard(),
                const SizedBox(height: 20),
                const SectionHeader(title: 'Daftar Tugas Hari Ini'),
                const SizedBox(height: 10),
                ...List.generate(c.tugas.length, (i) => TugasItem(data: c.tugas[i])),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPetugasController>();
    return Container(
      color: const Color(0xFF0e4a6e),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
          child: Row(
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
                    Text(
                      c.greeting,
                      style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(c.officerName,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Stack(children: [
                GestureDetector(
                  onTap: () => Get.to(
                    () => const NotifikasiView(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 280),
                  ),
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                  ),
                ),
                Obx(() {
                  final notif = Get.find<NotifikasiController>();
                  if (!notif.hasUnread) return const SizedBox();
                  return Positioned(
                    top: 6, right: 6,
                    child: Container(
                      width: notif.unreadCount > 9 ? 14 : 9,
                      height: 9,
                      decoration: const BoxDecoration(color: Color(0xFFef4444), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: notif.unreadCount > 1
                          ? Text(
                              notif.unreadCount > 9 ? '9+' : '${notif.unreadCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                  );
                }),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class TugasCard extends StatelessWidget {
  const TugasCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPetugasController>();
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tugas Hari Ini',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6b7280), fontWeight: FontWeight.w500)),
              RichText(text: TextSpan(children: [
                TextSpan(
                  text: '${c.selesai.value}',
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
                TextSpan(
                  text: ' / ${c.totalTugas.value}',
                  style: const TextStyle(fontSize: 20, color: Color(0xFF9ca3af)),
                ),
              ])),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: c.progress,
              backgroundColor: const Color(0xFFe5e7eb),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00b4d8)),
              minHeight: 7,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFf3f4f6)),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              children: [
                StatCol('${c.selesai.value}', 'Selesai'),
                const VerticalDivider(color: Color(0xFFe5e7eb), width: 1),
                StatCol('${c.belum.value}', 'Belum'),
                const VerticalDivider(color: Color(0xFFe5e7eb), width: 1),
                StatCol('${c.anomali.value}', 'Anomali'),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class StatCol extends StatelessWidget {
  final String value;
  final String label;
  const StatCol(this.value, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF9ca3af))),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF111827))),
        const Text('Lihat Semua', style: TextStyle(fontSize: 12, color: Color(0xFF1a6fa8), fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class TugasItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const TugasItem({super.key, required this.data});

  Color get _color {
    switch (data['status']) {
      case 'selesai': return const Color(0xFF10b981);
      case 'anomali': return const Color(0xFFef4444);
      default:        return const Color(0xFF9ca3af);
    }
  }

  IconData get _icon {
    switch (data['status']) {
      case 'selesai': return Icons.check_circle_rounded;
      case 'anomali': return Icons.warning_rounded;
      default:        return Icons.radio_button_unchecked_rounded;
    }
  }

  String get _label {
    switch (data['status']) {
      case 'selesai': return 'Selesai';
      case 'anomali': return 'Anomali';
      default:        return 'Belum';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: _color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(_icon, color: _color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['nama'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text(data['alamat'], style: const TextStyle(fontSize: 11, color: Color(0xFF6b7280)), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('No. Meter: ${data['meter']}', style: const TextStyle(fontSize: 10, color: Color(0xFF9ca3af))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: _color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(_label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _color)),
              ),
              const SizedBox(height: 4),
              Text(data['jam'] == '-' ? '--:--' : data['jam'], style: const TextStyle(fontSize: 10, color: Color(0xFF9ca3af))),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// WIDGET — KomplainMasukCard (preview notifikasi komplain terbaru di Home)
// ══════════════════════════════════════════════════════════════════════════════

// ignore: library_prefixes

class KomplainMasukCard extends StatelessWidget {
  const KomplainMasukCard({super.key});

  @override
  Widget build(BuildContext context) {
    final notif = Get.find<NotifikasiController>();
    return Obx(() {
      final komplainBaru = notif.items
          .where((n) => n.tipe == notif_model.NotifikasiTipe.komplainMasuk && !n.sudahDibaca)
          .toList();
      if (komplainBaru.isEmpty) return const SizedBox();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFef4444),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${komplainBaru.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'Komplain Baru',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF111827)),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Get.to(
                  () => const NotifikasiView(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 280),
                ),
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(fontSize: 12, color: Color(0xFF1a6fa8), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...komplainBaru.take(2).map((item) => _KomplainPreviewTile(item: item, notif: notif)),
        ],
      );
    });
  }
}

class _KomplainPreviewTile extends StatelessWidget {
  final notif_model.NotifikasiItem item;
  final NotifikasiController notif;
  const _KomplainPreviewTile({required this.item, required this.notif});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        notif.tandaiDibaca(item.id);
        Get.to(
          () => const NotifikasiView(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 280),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFef4444).withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFef4444).withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFef4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.report_problem_rounded, color: Color(0xFFef4444), size: 20),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Komplain Baru Masuk',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.isi,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF6b7280), height: 1.35),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(item.waktu, style: const TextStyle(fontSize: 9, color: Color(0xFF9ca3af))),
                const SizedBox(height: 6),
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: Color(0xFFef4444), shape: BoxShape.circle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
