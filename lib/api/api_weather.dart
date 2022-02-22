import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiWeather{
  String baseURl = "http://api.openweathermap.org/data/2.5/";
  String apiKey = "959d1296a89c3365a20b001a440c4eb3";

  // {"code": 200, "json": json}
  Future<Map<String,dynamic>?> getCurrentWeather({required double lat, required double lon}) async{
    http.Request request = http.Request(
        'GET',
        Uri.parse("${baseURl}weather?lat=${lat}&lon=${lon}&appid=${apiKey}&lang=fr&units=metric")
    );
    print("${baseURl}weather?lat=${lat}&lon=${lon}&appid=${apiKey}&lang=fr&units=metric");

    http.StreamedResponse streamedResponse = await request.send();

    if(streamedResponse.statusCode == 200){
      String data = await streamedResponse.stream.bytesToString();
      Map json = jsonDecode(data);
      return {
        "code": 200,
        "json": json,
      };
    }
    return null;
  }



}