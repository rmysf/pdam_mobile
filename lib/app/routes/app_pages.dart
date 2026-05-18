import 'package:get/get.dart';

import '../modules/beranda_pelanggan/bindings/beranda_pelanggan_binding.dart';
import '../modules/beranda_pelanggan/views/beranda_pelanggan_view.dart';
import '../modules/beranda_petugas/bindings/beranda_petugas_binding.dart';
import '../modules/beranda_petugas/views/beranda_petugas_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/login/bindings/register_binding.dart';   // ← tambahan
import '../modules/login/views/register_view.dart';         // ← tambahan

part 'app_routes.dart';

abstract class AppPages {
  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // ── REGISTER ──────────────────────────────────────────────────────────
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // ── PETUGAS ───────────────────────────────────────────────────────────
    GetPage(
      name: Routes.BERANDA_PETUGAS,
      page: () => const BerandaPetugasView(),
      binding: BerandaPetugasBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // ── PELANGGAN ─────────────────────────────────────────────────────────
    GetPage(
      name: Routes.BERANDA_PELANGGAN,
      page: () => const BerandaPelangganView(),
      binding: BerandaPelangganBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}