import 'package:get/get.dart';

import '../controllers/beranda_pelanggan_controller.dart';

class BerandaPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaPelangganController>(
      () => BerandaPelangganController(),
    );
  }
}
