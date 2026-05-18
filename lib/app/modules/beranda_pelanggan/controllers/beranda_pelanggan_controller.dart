import 'package:get/get.dart';

class BerandaPelangganController extends GetxController {
  // ─── NAVBAR ─────────────────────────────────────────────────────
  final RxInt navIndex = 0.obs;
  void changeTab(int i) => navIndex.value = i;

  // ─── DATA PELANGGAN ─────────────────────────────────────────────
  final String namaUser = 'Budi Santoso';
  final String idPelanggan = 'PLG-0042';
  final String alamat = 'Jl. Mawar No. 12, Kel. Sukasari, Bandung';
  final String telepon = '0812-3456-7890';
  final String userEmail = 'budi.santoso@email.com';
  final String zonaWilayah = 'Zona A – Sukasari';

  // ─── HOME TAB ────────────────────────────────────────────────────
  final String tagihanBulanIni = 'Rp 87.500';
  final String pemakaianBerjalan = '18 m³';
  final String jatuhTempo = '12 hari';
  final double pemakaianValue = 18;
  final double batasPemakaian = 25;
  final double progressPemakaian = 0.72;
  final String pemakaianBulanLalu = '22 m³';
  final String pemakaianBulanIni = '18 m³';
  final String selisihPemakaian = '−18%';

  // ─── TAGIHAN TAB ─────────────────────────────────────────────────
  final String periodeTagihan = 'Agustus 2025';
  final String statusTagihan = 'Belum Lunas';
  final String nominalTagihan = 'Rp 87.500';
  final String jatuhTempoTagihan = '31 Agt 2025';

  // ─── RIWAYAT TAB ─────────────────────────────────────────────────
  final List<Map<String, dynamic>> riwayatData = [
    {'bulan': 'Agustus 2025', 'awal': 1240, 'akhir': 1258, 'pemakaian': 18, 'tagihan': 'Rp 87.500',  'status': 'Berjalan'},
    {'bulan': 'Juli 2025',    'awal': 1218, 'akhir': 1240, 'pemakaian': 22, 'tagihan': 'Rp 102.000', 'status': 'Lunas'},
    {'bulan': 'Juni 2025',    'awal': 1199, 'akhir': 1218, 'pemakaian': 19, 'tagihan': 'Rp 91.500',  'status': 'Lunas'},
    {'bulan': 'Mei 2025',     'awal': 1178, 'akhir': 1199, 'pemakaian': 21, 'tagihan': 'Rp 99.000',  'status': 'Lunas'},
    {'bulan': 'April 2025',   'awal': 1160, 'akhir': 1178, 'pemakaian': 18, 'tagihan': 'Rp 87.500',  'status': 'Lunas'},
    {'bulan': 'Maret 2025',   'awal': 1143, 'akhir': 1160, 'pemakaian': 17, 'tagihan': 'Rp 83.000',  'status': 'Lunas'},
  ];

  // ─── KOMPLAIN TAB ────────────────────────────────────────────────
  final List<String> kategoriKomplain = [
    'Angka Meteran Tidak Sesuai',
    'Tagihan Terlalu Tinggi',
    'Lainnya',
  ];
  final RxString selectedKategori = 'Angka Meteran Tidak Sesuai'.obs;
  void selectKategori(String k) => selectedKategori.value = k;

  final List<Map<String, dynamic>> riwayatKomplain = [
    {
      'nomor': 'KMP-2025-00089',
      'bulan': 'Juli 2025',
      'kategori': 'Tagihan Terlalu Tinggi',
      'status': 'Diselesaikan',
      'tanggal': '15 Jul 2025',
    },
    {
      'nomor': 'KMP-2025-00042',
      'bulan': 'April 2025',
      'kategori': 'Angka Meteran Tidak Sesuai',
      'status': 'Ditolak',
      'tanggal': '02 Apr 2025',
    },
  ];

  void kirimKomplain() {
    Get.snackbar(
      'Komplain Dikirim',
      'Komplain Anda sedang diproses.',
      snackPosition: SnackPosition.TOP,
    );
  }

  // ─── PROFILE TAB ────────────────────────────────────────────────
  final RxBool notifikasiBatas = true.obs;
  final String batasPemakaianProfil = '25 m³ / bulan';

  void toggleNotifikasi(bool val) => notifikasiBatas.value = val;

  void logout() {
    Get.offAllNamed('/login');
  }

  // ─── LIFECYCLE ──────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
