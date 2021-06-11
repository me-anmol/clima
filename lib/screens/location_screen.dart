import 'dart:io';
import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';


class LocationScreen extends StatefulWidget {
  LocationScreen({@required this.locationData});
  final locationData;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  int temperature;
  var condition;
  var cityName;
  String weatherIcon;
  String message;
  WeatherModel weather = WeatherModel();

  void updateUI(dynamic weatherData){
    if (weatherData == null){
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        title: Text('Error Occurred'),
        actions: <Widget>[
          TextButton(onPressed: () => exit(0), child: Text('Exit'))
        ],
      ),
      );
      temperature =0;
      message = "Some Error Occurred";
      cityName = '';
      return;
    }
    setState(() {
      cityName = weatherData['list'][0]['name'];
      weatherIcon = weather.getWeatherIcon(weatherData['list'][0]['weather'][0]['id']);
      var temp =weatherData ['list'][0]['main']['temp'];
      temperature = temp.toInt();
      message = weather.getMessage(temperature);
    });


  }
  void updateNameUI(dynamic weatherData){
    if (weatherData == null){
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        title: Text('Error Occurred'),
        actions: <Widget>[
          TextButton(onPressed: () => exit(0), child: Text('Exit'))
        ],
      ),
      );
      temperature =0;
      message = "Some Error Occurred";
      cityName = '';
      return;
    }
    setState(() {
      cityName = weatherData ['name'];
      weatherIcon = weather.getWeatherIcon(weatherData['weather'][0]['id']);
      var temp =weatherData ['main']['temp'];
      temperature = temp.toInt();
      message = weather.getMessage(temperature);
    });


  }
  @override
  void initState() {
    super.initState();
    updateUI(widget.locationData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationData(context);
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                     var typedName = await Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CityScreen();
                      }),);
                      if (typedName != null){
                          var weatherData = await weather.getNamedLocationData(typedName);
                         //print(weatherData);
                          updateNameUI(weatherData);
                      }
                    },
                    icon: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      temperature.toString() +'°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$weatherIcon ',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$message in $cityName",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
