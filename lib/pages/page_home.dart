import 'package:flutter/material.dart';
import 'package:meteo/api/api_geocoder.dart';
import 'package:meteo/models/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  List<String> villes = [];

  @override
  void initState() {
    obtenir();
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
                          onPressed: null,
                          child: Text("Ajouter une ville",style: TextStyle(color: Colors.blue),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
                        ),
                      )
                    ],
                  )

              ),
              ListTile(
                title: Text(DeviceInfo.ville ?? "Ville Inconnue"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: villes.length,
                  itemBuilder: (context,index){
                    String ville = villes[index];
                    return ListTile(
                      title: Text(ville),
                    );
                  },
                ),
              )
              ,
            ],
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Ajouter Ville"),
          onPressed: () async{
            print(DeviceInfo.ville);
            print(villes);
            ajouter("Paris");
            ajouter("Lyon");
            supprimer("Rouen");
            print(villes);
            ApiGeocoder geocoder = ApiGeocoder();
            Map<String,double>? coordinates = await geocoder.getCoordinatesFromAddresse(ville: "bangkok");
            print(coordinates);

          },
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
}
