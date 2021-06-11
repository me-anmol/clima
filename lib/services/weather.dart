import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:clima/services/networking.dart';
 import 'package:clima/utilities/constants.dart';

class WeatherModel {

  Future getLocationData(BuildContext context) async {
    bool check = await Geolocator.isLocationServiceEnabled();
    if (!check) {
      showDialog(context: context, builder: (BuildContext context) =>
          AlertDialog(
            title: Text('Error Occurred'),
            actions: <Widget>[
              TextButton(onPressed: () => exit(0), child: Text('Exit'))
            ],
          ),
      );
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);
    double latitude = position.latitude;
    double longitude = position.longitude;
    NetworkHelper helper = NetworkHelper(
        url:
        "https://api.openweathermap.org/data/2.5/find?lat=$latitude&lon=$longitude&cnt=1&units=metric&appid=" +
            kAPIKey);
    var weatherData = await helper.getData();
    return weatherData;


  }
  Future getNamedLocationData(String cityName) async{
    String url = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$kAPIKey';
    NetworkHelper networkHelper = NetworkHelper(url: 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$kAPIKey');
    var weatherNameData = await networkHelper.getData();
    return weatherNameData;

  }
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
