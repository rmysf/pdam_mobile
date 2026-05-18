import 'package:get/get.dart';
import 'package:pdam_apps/app/modules/beranda_petugas/controllers/beranda_petugas_controller.dart';

class BerandaPetugasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaPetugasController>(() => BerandaPetugasController());
  }
}
