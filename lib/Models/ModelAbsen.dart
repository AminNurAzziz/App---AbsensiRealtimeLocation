import 'package:absensi/Models/ModelEmployee.dart';

class Absen {
  String? id;
  Employee? idPegawai; // Change the type to Pegawai
  String? status;
  String? keterangan;
  String? timestamp;
  String? images;
  String? lat;
  String? long;

  Absen({
    this.id,
    this.idPegawai,
    this.status,
    this.keterangan,
    this.timestamp,
    this.images,
    this.lat,
    this.long,
  });

  factory Absen.fromJson(Map<String, dynamic> json) {
    return Absen(
      id: json['_id'],
      idPegawai: Employee.fromJson(json['idPegawai']),
      status: json['status'],
      keterangan: json['keterangan'],
      timestamp: json['timestamp'],
      images: json['images'],
      lat: json['lat'],
      long: json['long'],
    );
  }
}
