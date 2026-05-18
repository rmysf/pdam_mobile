import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/beranda_pelanggan_controller.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BerandaPelangganController>();
    return Scaffold(
      backgroundColor: const Color(0xFFf5f7fa),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0e4a6e), Color(0xFF1a6fa8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
                  child: Column(
                    children: [
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(color: Colors.white54, width: 2),
                        ),
                        child: const Icon(Icons.person_rounded, color: Colors.white, size: 38),
                      ),
                      const SizedBox(height: 12),
                      Text(c.namaUser,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('ID Pelanggan: ${c.idPelanggan}',
                          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Pelanggan Aktif',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Info akun
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Informasi Akun',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9ca3af))),
                      const SizedBox(height: 10),
                      _InfoRow(Icons.home_outlined, 'Alamat', c.alamat),
                      _InfoRow(Icons.phone_outlined, 'Telepon', c.telepon),
                      _InfoRow(Icons.email_outlined, 'Email', c.userEmail),
                      _InfoRow(Icons.location_on_outlined, 'Zona Wilayah', c.zonaWilayah),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Pengaturan batas
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pengaturan Batas Pemakaian',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9ca3af))),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Batas Pemakaian',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF374151))),
                                const SizedBox(height: 2),
                                Text(c.batasPemakaianProfil,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0e4a6e))),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0e4a6e).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Ubah',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0e4a6e))),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20, color: Color(0xFFf3f4f6)),
                      // Switch reaktif dengan Obx
                      Obx(() => Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Notifikasi 80% Batas',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF374151))),
                                Text('Aktif', style: TextStyle(fontSize: 11, color: Color(0xFF10b981))),
                              ],
                            ),
                          ),
                          Switch(
                            value: c.notifikasiBatas.value,
                            onChanged: c.toggleNotifikasi,
                            activeColor: const Color(0xFF0e4a6e),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Menu lainnya
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                  ),
                  child: const Column(
                    children: [
                      _ProfileMenuItem(Icons.lock_outline_rounded, 'Ubah Password'),
                      _ProfileMenuItem(Icons.notifications_outlined, 'Pengaturan Notifikasi'),
                      _ProfileMenuItem(Icons.help_outline_rounded, 'Bantuan & FAQ'),
                      _ProfileMenuItem(Icons.info_outline_rounded, 'Tentang AcuRead', showDivider: false),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => Get.find<BerandaPelangganController>().logout(),
                    icon: const Icon(Icons.logout_rounded, color: Color(0xFFef4444)),
                    label: const Text('Keluar',
                        style: TextStyle(color: Color(0xFFef4444), fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFef4444)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0e4a6e)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF9ca3af))),
                Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF374151))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showDivider;
  const _ProfileMenuItem(this.icon, this.label, {this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        if (showDivider) const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFf3f4f6)),
      ],
    );
  }
}
