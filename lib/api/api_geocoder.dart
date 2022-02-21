import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiGeocoder{
  String baseURl = "http://api.openweathermap.org/geo/1.0/";
  String apiKey = "959d1296a89c3365a20b001a440c4eb3";

  Future<String?> getAddressFromCoordinates({required double latitude, required double longitude}) async{
    http.Request request = http.Request(
      'GET',
      Uri.parse("${baseURl}reverse?lat=${latitude}&lon=${longitude}&limit=1&appid=${apiKey}")
    );

    http.StreamedResponse streamedResponse = await request.send();

    if(streamedResponse.statusCode == 200){
      String data = await streamedResponse.stream.bytesToString();
      List<dynamic> json = jsonDecode(data);
      return json.first["name"];
    }
    return null;


  }

}