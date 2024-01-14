import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'package:absensi/State/ProviderAbsen.dart';

import 'package:absensi/Models/ModelAbsen.dart';
import 'package:absensi/Models/ModelEmployee.dart';

class FormAbsen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absensi Pegawai',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('email');
              prefs.remove('pw');
              Navigator.of(context).pushReplacementNamed('/loginPage');
            },
          ),
        ],
      ),
      body: AbsensiForm(),
    );
  }
}

class AbsensiForm extends StatefulWidget {
  @override
  _AbsensiFormState createState() => _AbsensiFormState();
}

class _AbsensiFormState extends State<AbsensiForm> {
  String _selectedStatus = 'Masuk';
  double? _latitude = 0;
  double? _longitude = 0;
  XFile? _image;
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GlobalKey _mapKey = GlobalKey();
  bool _mapCreated = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(_formKey.currentContext);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRichText('Foto'),
              _buildCameraAndImageField(),
              SizedBox(height: 16),
              _buildStatusSelection(),
              _buildLocationFields(),
              SizedBox(height: 16),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRichText(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: Theme.of(context).textTheme.subtitle1,
        children: [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraAndImageField() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _image == null
          ? _buildElevatedButton(
              onPressed: _takePicture,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                  SizedBox(height: 8),
                  Text('Add Photo from Camera'),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_image!.path),
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget _buildElevatedButton(
      {required VoidCallback onPressed, required Widget child}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: child,
    );
  }

  Widget _buildStatusSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Keterangan', style: Theme.of(context).textTheme.subtitle1),
        SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: [
            _buildChoiceChip('Masuk'),
            _buildChoiceChip('Istirahat'),
            _buildChoiceChip('Kembali'),
            _buildChoiceChip('Pulang'),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildChoiceChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedStatus == label,
      onSelected: (selected) => _handleStatusChange(selected, label),
    );
  }

  Widget _buildLocationFields() {
    return Column(
      children: [
        _buildElevatedButton(
          onPressed: _getCurrentLocation,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 8),
              Text('Get Current Location'),
            ],
          ),
        ),
        SizedBox(height: 8),
        _buildLocationTextField('Latitude', _latitude.toString()),
        _buildLocationTextField('Longitude', _longitude.toString()),
        SizedBox(height: 16),
        _buildMap(key: _mapKey),
      ],
    );
  }

  Widget _buildLocationTextField(String label, String value) {
    return TextFormField(
      enabled: false,
      controller: TextEditingController(text: value),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.location_pin),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onSaved: (value) {
        // You may add logic here if needed
      },
    );
  }

  Widget _buildMap({required Key key}) {
    return Container(
      key: key,
      height: 200,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          if (!_mapCreated) {
            _controller.complete(controller);
            setState(() {
              _mapCreated = true;
            });
          }
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(_latitude ?? 0, _longitude ?? 0),
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId("currentLocation"),
            position: LatLng(_latitude ?? 0, _longitude ?? 0),
            infoWindow: InfoWindow(title: "Current Location"),
          ),
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      child: Text('Submit'),
    );
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = pickedImage;
    });
  }

  void _handleStatusChange(bool selected, String value) {
    if (selected) {
      setState(() {
        _selectedStatus = value;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check and request location permissions
      PermissionStatus status = await Permission.locationWhenInUse.status;
      print('Location permission status: $status');

      if (!status.isGranted) {
        await Permission.locationWhenInUse.request();
        // Check again after requesting permissions
        status = await Permission.locationWhenInUse.status;
        print('Location permission status after request: $status');

        if (!status.isGranted) {
          print('Location permissions are not granted.');
          return;
        }
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Only update the state if both latitude and longitude are obtained
      if (position.latitude != null && position.longitude != null) {
        print('Location obtained: ${position.latitude}, ${position.longitude}');
        setState(() {
          _latitude = position.latitude!;
          _longitude = position.longitude!;
        });

        // Update the map key to trigger a rebuild
        setState(() {
          _mapKey = GlobalKey();
        });
      }
    } catch (e) {
      print("Error obtaining current location: $e");
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Check if both latitude and longitude are available
      if (_latitude == null || _longitude == null) {
        // Show an error message or handle the case where location is not available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location is not available. Please try again.'),
          ),
        );
        return;
      }

      // Membuat request multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://192.168.178.135:3000/absen'), // Ganti dengan URL endpoint Anda
      );

      // Menambahkan gambar sebagai file multipart
      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('gambar', _image!.path));
      }

      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('id');
      print(id);
      // Menambahkan data lain sebagai fields
      request.fields['idPegawai'] = id!;
      request.fields['status'] = _selectedStatus;
      request.fields['lat'] = _latitude.toString();
      request.fields['long'] = _longitude.toString();

      try {
        // Mengirim request
        var response = await request.send();
        print(response.statusCode);

        // Menangani respons
        if (response.statusCode == 201) {
          // Reset form setelah berhasil
          _formKey.currentState!.reset();
          setState(() {
            _image = null;
            _buildMap(key: _formKey);
          });

          // Tampilkan pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Form submitted successfully!'),
            ),
          );
        } else {
          // Tampilkan pesan kesalahan jika respons tidak berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting form. Please try again.'),
            ),
          );
        }
      } catch (e) {
        // Tangani kesalahan yang mungkin terjadi saat mengirim request
        print("Error submitting form: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting form. Please try again.'),
          ),
        );
      }
    }
  }

  // Check and request location permissions
  Future<void> checkAndRequestPermissions() async {
    PermissionStatus status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.locationWhenInUse.request();
    }
  }
}
