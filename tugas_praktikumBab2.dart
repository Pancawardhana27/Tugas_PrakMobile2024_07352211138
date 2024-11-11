class TongIT {
  String nama;

  TongIT(this.nama);
}

class ProdukDigital extends TongIT {
  double harga;
  String kategori;

  ProdukDigital(String namaProduk, this.harga, this.kategori)
      : super(namaProduk);

  double terapkanDiskon(int jumlahTerjual) {
    if (kategori == 'NetworkAutomation' && jumlahTerjual > 50) {
      double diskon = 0.15;
      double hargaDiskon = harga * (1 - diskon);
      if (hargaDiskon < 200000) {
        harga = 200000;
      } else {
        harga = hargaDiskon;
      }
    }
    return harga;
  }
}

abstract class Karyawan extends TongIT {
  int umur;
  String peran;

  Karyawan(String nama, this.umur, this.peran) : super(nama);

  void bekerja();
}

class KaryawanTetap extends Karyawan {
  KaryawanTetap(String nama, int umur, String peran) : super(nama, umur, peran);

  @override
  void bekerja() {
    print('$nama bekerja selama hari kerja reguler.');
  }
}

class KaryawanKontrak extends Karyawan {
  KaryawanKontrak(String nama, int umur, String peran)
      : super(nama, umur, peran);

  @override
  void bekerja() {
    print('$nama bekerja pada proyek dengan periode spesifik.');
  }
}

mixin Kinerja {
  int produktivitas = 0;

  void updateProduktivitas(int nilai) {
    if (nilai >= 0 && nilai <= 100) {
      produktivitas = nilai;
    } else {
      print("Nilai produktivitas harus antara 0 dan 100.");
    }
  }

  void cekProduktivitas() {
    print("Produktivitas: $produktivitas");
  }
}

class KaryawanDenganKinerja extends Karyawan with Kinerja {
  KaryawanDenganKinerja(String nama, int umur, String peran)
      : super(nama, umur, peran);

  @override
  void bekerja() {
    if (peran == "Manager" && produktivitas < 85) {
      print("Produktivitas Manager harus lebih dari atau sama dengan 85.");
    } else {
      print('$nama bekerja dengan produktivitas $produktivitas.');
    }
  }
}

enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

class Proyek {
  String namaProyek;
  FaseProyek fase;
  List<Karyawan> karyawan;
  int hariBerjalan;

  Proyek(this.namaProyek)
      : fase = FaseProyek.Perencanaan,
        karyawan = [],
        hariBerjalan = 0;

  void tambahKaryawan(Karyawan karyawan) {
    this.karyawan.add(karyawan);
  }

  void tambahHari() {
    hariBerjalan++;
  }

  void beralihFase() {
    if (fase == FaseProyek.Perencanaan && karyawan.length >= 5) {
      fase = FaseProyek.Pengembangan;
    } else if (fase == FaseProyek.Pengembangan && hariBerjalan > 45) {
      fase = FaseProyek.Evaluasi;
    }
  }

  void statusProyek() {
    print(
        "Proyek $namaProyek saat ini berada di fase ${fase.toString().split('.').last}.");
  }
}

class Perusahaan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];
  final int maxKaryawanAktif = 20;

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length < maxKaryawanAktif) {
      karyawanAktif.add(karyawan);
      print("${karyawan.nama} berhasil ditambahkan ke karyawan aktif.");
    } else {
      print("Batas jumlah karyawan aktif tercapai.");
    }
  }

  void resign(Karyawan karyawan) {
    if (karyawanAktif.contains(karyawan)) {
      karyawanAktif.remove(karyawan);
      karyawanNonAktif.add(karyawan);
      print("${karyawan.nama} resign dan dipindahkan ke non-aktif.");
    } else {
      print("Karyawan tidak ditemukan dalam daftar karyawan aktif.");
    }
  }
}

void main() {
  var produk1 =
      ProdukDigital("Network Automation Tool", 250000, "NetworkAutomation");
  var produk2 =
      ProdukDigital("Data Management Suite", 150000, "DataManagement");

  print("Harga produk 1 setelah diskon: ${produk1.terapkanDiskon(60)}");

  var karyawan1 = KaryawanDenganKinerja("Taken", 30, "Developer");
  karyawan1.updateProduktivitas(90);

  var karyawan2 = KaryawanDenganKinerja("halid", 28, "Manager");
  karyawan2.updateProduktivitas(88);

  var proyek = Proyek("Proyek Pengembangan Aplikasi Absensi Online");
  proyek.tambahKaryawan(karyawan1);
  proyek.tambahKaryawan(karyawan2);

  var perusahaan = Perusahaan();
  perusahaan.tambahKaryawan(karyawan1);
  perusahaan.tambahKaryawan(karyawan2);

  proyek.statusProyek();
  proyek.tambahHari();
  proyek.beralihFase();
  proyek.statusProyek();

  perusahaan.resign(karyawan1);
  perusahaan.resign(karyawan2);

  var karyawan3 = KaryawanTetap("aji", 35, "Manager");
  perusahaan.tambahKaryawan(karyawan3);

  print("Jumlah karyawan aktif: ${perusahaan.karyawanAktif.length}");
  print("Jumlah karyawan non-aktif: ${perusahaan.karyawanNonAktif.length}");
}
