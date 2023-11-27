import 'package:absensi/Models/ModelAbsen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absensi/State/ProviderAbsen.dart';

import 'package:absensi/Widget/AdminWidget.dart';
import 'package:absensi/Screen/Admin/AdminDetailAbsen.dart';

class ListAbsen extends StatefulWidget {
  @override
  _ListAbsenState createState() => _ListAbsenState();
}

class _ListAbsenState extends State<ListAbsen> {
  List<Absen> absenData = [];
  String _selectedFilter = 'Semua';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Provider.of<ProviderAbsen>(context, listen: false).getAbsen();
    _sortAndFilterAbsen(); // Call this method to sort the data
  }

  @override
  Widget build(BuildContext context) {
    absenData = Provider.of<ProviderAbsen>(context).listAbsen;
    _sortAndFilterAbsen();
    print(absenData);

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: absenData.length,
                itemBuilder: (context, index) {
                  print(absenData[index].timestamp);
                  return buildAbsenCard(
                      absenData[index], _navigateToDetailPage);
                },
              ),
            ),
            buildFilterAndDatePicker(),
          ],
        ),
      ),
    );
  }

  Widget buildFilterAndDatePicker() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Divider(height: 1, color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildFilterDropdown(_selectedFilter, _onFilterChanged),
              buildDatePickerButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDatePickerButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () => _selectDate(context),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _sortAndFilterAbsen();
      });
    }
  }

  void _onFilterChanged(String value) {
    setState(() {
      _selectedFilter = value;
      _sortAndFilterAbsen();
    });
  }

  void _navigateToDetailPage(Absen data) {
    print(data);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailAbsen(absenData: data),
      ),
    );
  }

  void _sortAndFilterAbsen() {
    print('masuk sort and filter absen');
    absenData.sort((a, b) {
      // Urutkan berdasarkan kategori status
      return _categoryOrder(a.status!).compareTo(_categoryOrder(b.status!));
    });
    // Filter absen berdasarkan tanggal dan status
    absenData = absenData.where((data) {
      DateTime entryDate = DateTime.parse(data.timestamp!);
      bool isSameDate = entryDate.year == _selectedDate.year &&
          entryDate.month == _selectedDate.month &&
          entryDate.day == _selectedDate.day;
      bool statusFilter =
          _selectedFilter == 'Semua' || data.status == _selectedFilter;

      return isSameDate && statusFilter;
    }).toList();
  }

  int _categoryOrder(String category) {
    // Memberikan urutan berdasarkan kategori absen
    switch (category) {
      case 'Masuk':
        return 0;
      case 'Istirahat':
        return 1;
      case 'Kembali':
        return 2;
      case 'Pulang':
        return 3;
      default:
        return 4; // Urutan lainnya
    }
  }
}
