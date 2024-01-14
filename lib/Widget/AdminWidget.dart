import 'package:absensi/Models/ModelAbsen.dart';
import 'package:flutter/material.dart';
import 'package:absensi/Models/ModelEmployee.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class EmployeeDialog extends StatelessWidget {
  final String title;
  final Function(Employee) onEmployeeAdded;

  const EmployeeDialog({
    Key? key,
    required this.title,
    required this.onEmployeeAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();

    return AlertDialog(
      title: Text(title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              String password = _generateRandomPassword();
              Employee editedEmployee = Employee(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text,
                email: _emailController.text,
                password: password,
                pw: password,
                role: 'Pegawai',
              );
              onEmployeeAdded(editedEmployee);
              _nameController.clear();
              _emailController.clear();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  String _generateRandomPassword() {
    final Random _random = Random.secure();
    const charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(10, (index) {
      final randomIndex = _random.nextInt(charset.length);
      return charset[randomIndex];
    }).join();
  }
}

// ======================================== ABSEN CARD ========================================
// ======================================== ABSEN CARD ========================================
// ======================================== ABSEN CARD ========================================
// ======================================== ABSEN CARD ========================================
// ======================================== ABSEN CARD ========================================
// ======================================== ABSEN CARD ========================================
Widget buildAbsenCard(Absen data, Function(Absen) onTap) {
  Color statusColor = _getStatusColor(data.status ?? '');
  // Format the timestamp to "yyyy-MM-dd HH:mm:ss"
  print(data.idPegawai!.name.toString());
  print(data.timestamp.toString());
  final formattedTimestamp = data.timestamp != null
      ? DateFormat('yyyy-MM-dd  HH:mm:ss')
          .format(DateTime.parse(data.timestamp!))
      : 'Unknown';

  return InkWell(
    onTap: () {
      print('masuk on tap========================================');
      print(data);
      onTap(data);
    },
    child: Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: Image.network(
            'http://192.168.178.135:3000/uploads/' + data.images.toString(),
            fit: BoxFit.cover,
          ).image,
        ),
        title: Text(
          data.idPegawai!.name.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedTimestamp),
            Text('Status: ${data.keterangan}'),
          ],
        ),
        trailing: Text(
          data.status ?? '',
          style: TextStyle(
            color: statusColor,
            fontSize: 14,
          ),
        ),
      ),
    ),
  );
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'Masuk':
      return Colors.green;
    case 'Istirahat':
      return Colors.blue;
    case 'Kembali':
      return Colors.amber; // Ganti dengan warna yang sesuai
    case 'Pulang':
      return Colors.red;
    default:
      return Colors
          .black; // Warna default jika status tidak sesuai dengan yang diharapkan
  }
}

bool _checkIfLate(String timestamp) {
  DateTime currentTime = DateTime.now();
  if (timestamp == '') {
    return false;
  }
  DateTime entryTime = DateTime.parse(timestamp);
  return currentTime.isAfter(entryTime);
}

// ======================================== FILTER DROPDOWN ========================================

Widget buildFilterDropdown(
    String selectedFilter, Function(String) onFilterChanged) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_list, color: Colors.blue),
          SizedBox(width: 8.0),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedFilter,
              hint: Text('Filter by Status'),
              onChanged: (value) {
                onFilterChanged(value!);
              },
              items: [
                'Semua',
                'Masuk',
                'Istirahat',
                'Kembali',
                'Pulang',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}
