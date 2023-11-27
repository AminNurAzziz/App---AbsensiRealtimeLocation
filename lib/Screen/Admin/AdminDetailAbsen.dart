import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:absensi/Models/ModelAbsen.dart';

class DetailAbsen extends StatefulWidget {
  final Absen absenData;

  DetailAbsen({required this.absenData});

  @override
  State<DetailAbsen> createState() => _DetailAbsenState();
}

class _DetailAbsenState extends State<DetailAbsen> {
  double _latitude = -6.200000;
  double _longitude = 106.816666;
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GlobalKey _mapKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(widget.absenData.idPegawai!.email);
    // Format the timestamp to "yyyy-MM-dd HH:mm:ss"
    final formattedTimestamp = widget.absenData.timestamp != null
        ? DateFormat('yyyy-MM-dd  HH:mm:ss')
            .format(DateTime.parse(widget.absenData.timestamp!))
        : 'Unknown';

    _latitude = double.parse(widget.absenData.lat ?? '-6.200000');
    _longitude = double.parse(widget.absenData.long ?? '106.816666');

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Absen'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                'http://192.168.178.135:3000/uploads/' +
                        widget.absenData.images.toString() ??
                    'https://picsum.photos/250?image=9',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          _buildDetailItem('Email', widget.absenData.idPegawai!.email),
          _buildDetailItem('Nama', widget.absenData.idPegawai!.name),
          _buildDetailItem('Tanggal Absen', formattedTimestamp),
          _buildDetailItem('Keterangan', widget.absenData.keterangan),
          _buildDetailItem('Status', widget.absenData.status),
          SizedBox(height: 16.0),
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lokasi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _buildMap(key: _mapKey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8.0),
            Text(value ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildMap({required Key key}) {
    return Container(
      key: key,
      height: 200,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(_latitude, _longitude),
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId("currentLocation"),
            position: LatLng(_latitude, _longitude),
            infoWindow: InfoWindow(title: "Current Location"),
          ),
        },
      ),
    );
  }
}
