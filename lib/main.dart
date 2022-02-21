import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:meteo/api/api_geocoder.dart';
import 'package:meteo/models/device_info.dart';
import 'package:meteo/pages/page_home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();
  if(_locationData.latitude != null && _locationData.longitude != null){
    print("Location = ${_locationData.latitude},${_locationData.longitude}");
    ApiGeocoder geocoder = ApiGeocoder();
    DeviceInfo.ville = await geocoder.getAddressFromCoordinates(latitude: _locationData.latitude!, longitude: _locationData.longitude!);
    DeviceInfo.locationData = _locationData;

    runApp(const MyApp());
  }




}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const PageHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

