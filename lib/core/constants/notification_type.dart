enum NotificationType {
  changeStatus('ganti_status', 'Pergantian Status'),
  newReport('laporan_baru', 'Ada Laporan Baru'),
  assignment('penugasan', 'Panggilan Tugas'),
  fieldResult('hasil_lapangan', 'Surat Cinta dari Petugas'),
  nearbyReport('laporan_terdekat', 'Ada Laporan Di Sekitarmu');

  final String dbValue;
  final String label;

  const NotificationType(this.dbValue, this.label);

  static NotificationType fromString(String type) =>
      NotificationType.values.firstWhere(
        (e) => e.dbValue == type,
        orElse: () => NotificationType.newReport,
      );
}
