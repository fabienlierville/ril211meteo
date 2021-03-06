import 'package:flutter/material.dart';
import 'package:meteo/api/api_geocoder.dart';
import 'package:meteo/api/api_weather.dart';
import 'package:meteo/models/device_info.dart';
import 'package:meteo/models/weather.dart';
import 'package:meteo/my_flutter_app_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  List<String> villes = [];
  Weather? weather;
  String? villeChoisie;
  @override
  void initState() {
    obtenir();
    getMeteo(DeviceInfo.ville!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Météo"),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue,
          child: Column(
            children: [
              DrawerHeader(
                  child: Column(
                    children: [
                      Text("Villes", textScaleFactor: 3,style: TextStyle(color: Colors.white),),
                      ElevatedButton(
                          onPressed: ajoutVille,
                          child: Text("Ajouter une ville",style: TextStyle(color: Colors.blue),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                      )
                    ],
                  )

              ),
              ListTile(
                onTap: (){
                  getMeteo(DeviceInfo.ville ?? "Paris");
                  Navigator.pop(context);
                },
                title: Text(DeviceInfo.ville ?? "Ville Inconnue"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: villes.length,
                  itemBuilder: (context,index){
                    String ville = villes[index];
                    return ListTile(
                      onTap: (){
                        getMeteo(ville);
                        Navigator.pop(context);
                      },
                      title: Text(ville),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: (){
                          supprimer(ville);
                        },
                      ),
                    );
                  },
                ),
              )
              ,
            ],
          ),
        ),
      ),
      body: (weather == null)
          ? Center(
        child: Text("Pas de météo dispo"),
      )
          : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(weather!.getMainWeatherImage()),
                fit: BoxFit.cover)),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(villeChoisie!, style: TextStyle(fontSize: 30, color: Colors.white),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${weather!.main.temp.toStringAsFixed(1)} °C",style: TextStyle(fontSize: 60, color: Colors.white),),
                Image.asset(weather!.getIconeImage())
              ],
            ),
            Text(weather!.weather[0].main, style: TextStyle(fontSize: 30, color: Colors.white),),
            Text(weather!.weather[0].description, style: TextStyle(fontSize: 25, color: Colors.white),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(MyFlutterApp.temperatire, color: Colors.white,),
                    Text(weather!.main.pressure.toInt().toString(), style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
                Column(
                  children: [
                    Icon(MyFlutterApp.droplet, color: Colors.white),
                    Text(weather!.main.humidity.toInt().toString(), style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
                Column(
                  children: [
                    Icon(MyFlutterApp.arrow_upward, color: Colors.white),
                    Text(weather!.main.temp_max.toStringAsFixed(1), style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
                Column(
                  children: [
                    Icon(MyFlutterApp.arrow_downward, color: Colors.white),
                    Text(weather!.main.temp_min.toStringAsFixed(1), style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
              ],
            )

          ],
        ),

      ),

    );
  }

  Future<void> obtenir() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? villesList = prefs.getStringList("villes");
    if(villesList !=null){
      setState(() {
        villes = villesList;
      });
    }
  }

  Future<void> ajouter(String value) async{
    //AntiDoublon
    if(villes.contains(value)){
      return;
    }
    villes.add(value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("villes", villes);
    obtenir();
  }

  Future<void> supprimer(String value) async{
    villes.remove(value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("villes", villes);
    obtenir();
  }

  Future<void> ajoutVille(){
    String? villeSaisie;

    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            contentPadding: EdgeInsets.all(20),
            title: Text("Ajouter Ville"),
            children: [
              TextField(
                onChanged: (String value){
                  villeSaisie = value;
                },
              ),
              ElevatedButton(
                  onPressed: (){
                    if(villeSaisie!=null){
                      ajouter(villeSaisie!);
                      Navigator.pop(context);
                    }

                  },
                  child: Text("Valider")
              ),
            ],
          );
        }
    );



  }

  Future<void> getMeteo(String ville) async{
    // Récupère Lat/Long
    ApiGeocoder geocoder = ApiGeocoder();
    Map<String,double>? coordinates = await geocoder.getCoordinatesFromAddresse(ville: ville);
    if(coordinates != null){
      ApiWeather apiWeather = ApiWeather();
      Map<String,dynamic>? result = await apiWeather.getCurrentWeather(lat: coordinates["lat"]!, lon: coordinates["lon"]!);
      if(result!=null && result["code"]==200){
        setState(() {
          weather = Weather.fromJson(result["json"]);
          villeChoisie = ville;
        });
        print(weather);

      }

    }
    // Apple API pour avoir le JSON (à créer)
    // weather = Weather.fromJson(json)
    setState(() {
      // Mon objet Weather de ma classe = weather
    });
  }
}
