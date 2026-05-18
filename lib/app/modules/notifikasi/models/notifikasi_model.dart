// ══════════════════════════════════════════════════════════════════════════════
// MODEL — NotifikasiItem
// ══════════════════════════════════════════════════════════════════════════════

enum NotifikasiTipe { komplainMasuk, updateStatus, infoSistem }

class NotifikasiItem {
  final String id;
  final NotifikasiTipe tipe;
  final String judul;
  final String isi;
  final String waktu;
  final bool sudahDibaca;

  const NotifikasiItem({
    required this.id,
    required this.tipe,
    required this.judul,
    required this.isi,
    required this.waktu,
    this.sudahDibaca = false,
  });

  NotifikasiItem copyWith({bool? sudahDibaca}) => NotifikasiItem(
        id: id,
        tipe: tipe,
        judul: judul,
        isi: isi,
        waktu: waktu,
        sudahDibaca: sudahDibaca ?? this.sudahDibaca,
      );
}
