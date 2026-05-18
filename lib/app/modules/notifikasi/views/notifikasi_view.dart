import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifikasi_controller.dart';
import '../models/notifikasi_model.dart';

// HALAMAN NOTIFIKASI — NotifikasiView

class NotifikasiView extends StatelessWidget {
  const NotifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NotifikasiController>();
    return Scaffold(
      backgroundColor: const Color(0xFFf5f7fa),
      body: Column(
        children: [
          const _NotifikasiHeader(),
          const _FilterChips(),
          Expanded(child: _NotifikasiList(c: c)),
        ],
      ),
    );
  }
}

// ─── HEADER ──────────────────────────────────────────────────────────────────

class _NotifikasiHeader extends StatelessWidget {
  const _NotifikasiHeader();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NotifikasiController>();
    return Container(
      color: const Color(0xFF0e4a6e),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Notifikasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Obx(
                () => c.hasUnread
                    ? GestureDetector(
                        onTap: c.tandaiSemuaDibaca,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Text(
                            'Tandai dibaca',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── FILTER CHIPS ─────────────────────────────────────────────────────────────

class _FilterChips extends StatefulWidget {
  const _FilterChips();

  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  int _selected = 0;
  static const labels = ['Semua', 'Komplain', 'Status', 'Info'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = _selected == i;
          return GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFF0e4a6e)
                    : const Color(0xFFf3f4f6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                  color: active ? Colors.white : const Color(0xFF6b7280),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── LIST NOTIFIKASI ──────────────────────────────────────────────────────────

class _NotifikasiList extends StatelessWidget {
  final NotifikasiController c;
  const _NotifikasiList({required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (c.items.isEmpty) {
        return const _EmptyState();
      }

      // Pisah hari ini & sebelumnya (dummy: unread = hari ini)
      final belumDibaca = c.items.where((n) => !n.sudahDibaca).toList();
      final sudahDibaca = c.items.where((n) => n.sudahDibaca).toList();

      return ListView(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 100),
        children: [
          if (belumDibaca.isNotEmpty) ...[
            _SectionLabel(label: 'Baru (${belumDibaca.length})'),
            ...belumDibaca.map((n) => _NotifTile(item: n, c: c)),
          ],
          if (sudahDibaca.isNotEmpty) ...[
            const _SectionLabel(label: 'Sebelumnya'),
            ...sudahDibaca.map((n) => _NotifTile(item: n, c: c)),
          ],
        ],
      );
    });
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9ca3af),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─── TILE NOTIFIKASI ──────────────────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  final NotifikasiItem item;
  final NotifikasiController c;
  const _NotifTile({required this.item, required this.c});

  @override
  Widget build(BuildContext context) {
    final badgeColor = NotifikasiController.tipeBadgeColor(item.tipe);
    final icon = NotifikasiController.tipeIcon(item.tipe);
    final label = NotifikasiController.tipeLabel(item.tipe);
    final unread = !item.sudahDibaca;

    return GestureDetector(
      onTap: () => c.tandaiDibaca(item.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        decoration: BoxDecoration(
          color: unread ? Colors.white : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: unread ? badgeColor.withOpacity(0.25) : Colors.transparent,
            width: 1.2,
          ),
          boxShadow: unread
              ? [
                  BoxShadow(
                    color: badgeColor.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: badgeColor, size: 22),
                  ),
                  if (unread)
                    Positioned(
                      top: -3,
                      right: -3,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Konten
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: badgeColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.waktu,
                          style: TextStyle(
                            fontSize: 10,
                            color: unread
                                ? const Color(0xFF6b7280)
                                : const Color(0xFFa8b0bd),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.judul,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: unread ? FontWeight.bold : FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.isi,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: unread
                            ? const Color(0xFF374151)
                            : const Color(0xFF9ca3af),
                        height: 1.45,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── EMPTY STATE ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFe5e7eb),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.notifications_off_rounded,
              size: 38,
              color: Color(0xFF9ca3af),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada notifikasi',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Notifikasi komplain dan pembaruan\nstatus akan muncul di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9ca3af),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
