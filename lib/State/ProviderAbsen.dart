import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:absensi/Models/ModelAbsen.dart';
import 'package:absensi/Services/ServicesAbsen.dart';

class ProviderAbsen extends ChangeNotifier {
  final ServicesAbsen _absenService = ServicesAbsen();
  List<Absen> _listAbsen = [];
  List<Absen> get listAbsen => _listAbsen;

  Future<void> addAbsen(Absen absen) async {
    try {
      print('masuk add absen');
      await _absenService.addAbsen(absen);
      print('berhasil add absen');
      await getAbsen();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getAbsen() async {
    try {
      _listAbsen = await _absenService.getAbsen();
      print('tesssssssssss');
      print(_listAbsen);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
