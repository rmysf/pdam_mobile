import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/controllers/beranda_petugas_controller.dart';

// ══════════════════════════════════════════════════════════════════════════════
// TAB 4 — PROFILE
// ══════════════════════════════════════════════════════════════════════════════

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPetugasController>();
    return Scaffold(
      backgroundColor: const Color(0xFFf5f7fa),
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF0e4a6e),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: const BoxDecoration(color: Color(0xFF0e4a6e), shape: BoxShape.circle),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.officerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF111827))),
                      const Text('PTG-2025-001', style: TextStyle(fontSize: 12, color: Color(0xFF9ca3af))),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFF10b981).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: const Text('Petugas Aktif', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF10b981))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
              ),
              child: const Column(
                children: [
                  ProfileMenuItem(Icons.lock_outline_rounded, 'Ubah Password'),
                  ProfileMenuItem(Icons.notifications_outlined, 'Notifikasi'),
                  ProfileMenuItem(Icons.help_outline_rounded, 'Bantuan & FAQ'),
                  ProfileMenuItem(Icons.info_outline_rounded, 'Tentang AcuRead', showDivider: false),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 48,
              child: OutlinedButton.icon(
                onPressed: c.logout,
                icon: const Icon(Icons.logout_rounded, color: Color(0xFFef4444)),
                label: const Text('Keluar', style: TextStyle(color: Color(0xFFef4444), fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
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

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showDivider;
  const ProfileMenuItem(this.icon, this.label, {super.key, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: const Color(0xFF0a3d5c)),
                const SizedBox(width: 14),
                Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF374151)))),
                const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF9ca3af)),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xFFf3f4f6)),
      ],
    );
  }
}
