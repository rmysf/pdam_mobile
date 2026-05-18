import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/beranda_pelanggan_controller.dart';
import 'tabs/home_tab.dart';
import 'tabs/tagihan_tab.dart';
import 'tabs/riwayat_tab.dart';
import 'tabs/komplain_tab.dart';
import 'tabs/profile_tab.dart';

class BerandaPelangganView extends GetView<BerandaPelangganController> {
  const BerandaPelangganView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: IndexedStack(
        index: controller.navIndex.value,
        children: const [
          HomeTab(),
          TagihanTab(),
          RiwayatTab(),
          KomplainTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _NavItem(0, Icons.home_rounded, Icons.home_outlined, 'Beranda', controller),
                _NavItem(1, Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Tagihan', controller),
                _NavItem(2, Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Riwayat', controller),
                _NavItem(3, Icons.report_problem_rounded, Icons.report_problem_outlined, 'Komplain', controller),
                _NavItem(4, Icons.person_rounded, Icons.person_outline_rounded, 'Profil', controller),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final BerandaPelangganController controller;

  const _NavItem(this.index, this.activeIcon, this.inactiveIcon, this.label, this.controller);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool active = controller.navIndex.value == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => controller.changeTab(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                active ? activeIcon : inactiveIcon,
                color: active ? const Color(0xFF0e4a6e) : const Color(0xFF9ca3af),
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  color: active ? const Color(0xFF0e4a6e) : const Color(0xFF9ca3af),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
