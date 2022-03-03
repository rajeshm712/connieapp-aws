import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:connie/src/abstract/charmBarInfoAbstract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

class CharmBarInfoProvider extends CharmBarInfoAbstract {
  //Weather-----
  final String openWeatherApiKey = '856822fd8e22db5e1ba48c0e7d69844a';
  bool infoPressed = false;
  int wifi;
  String date;
  String time;
  Weather weather = null;
  int networkType;
  var wifiConnected = 1;
  var mobileNetworkConnected = 2;
  var networkState = -1;
  bool weatherInfo = false;

  double lat = 28.4595;
  double lon = 77.0266;
  LocationData currentLocation;

  TextStyle style = TextStyle(
      color: Colors.white60, fontSize: 18.0, fontFamily: 'Montserrat');
  double widgetHeight = 25.0;
  double widgetWidth = 25.0;

  WiFiHunterResult wiFiHunterResult;

  //wifi
  var wifi_5 = 'assets/images/icon_feather_wifi_level5.png';
  var wifi_4 = 'assets/images/icon_feather_wifi_level4.png';
  var wifi_3 = 'assets/images/icon_feather_wifi_level3.png';
  var wifi_2 = 'assets/images/icon_feather_wifi_level2.png';
  var wifiFinal;

  @override
  intializeCharmBarItemsValues() {
    wiFiHunterResult = WiFiHunterResult();
    // TODO: implement intializeCharmBarItemsValues
    getCharm();
    // TODO: implement initState
    wifiFinal = wifi_5;
    getLocation();
    startTime();
    currentLocationBloc.onChange((data) {
      //Uncomment this code if you are running on Android.
      print('LONG : ${data.longitude}');
      currentLocation = data;
      // setWeather();
      getCharm();
    });
  }

  getCharm() async {
    getNetworkType();
  }

  void getNetworkType() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setNetworkState(mobileNetworkConnected);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      setNetworkState(wifiConnected);
    }
  }

  Future<int> getWifiConnectionLevel() async {
    //Signal strength， 1-3，The bigger the number, the stronger the signal
    var results = await wiFiHunterResult?.results;
    if (results == null || results.length == 0) return 1;
    return results[0].level;
  }

  void setNetworkState(int state) {
    networkState = state;
    getWifiConnectionLevel().then((value) {
      wifi = value;
      wifiFinal = wifi != null
          ? (wifi == 1 || wifi == 2 ? wifi_2 : (wifi == 3 ? wifi_3 : wifi_4))
          : wifi_5;
      // notifyListeners();
    });
  }

  @override
  setWeather() async {
// Here you can write your code
    if (!weatherInfo) {
      // intializeCharmBarItemsValues();
      currentLocation =
          currentLocationBloc.value; //await location.getLocation();
      WeatherFactory wf = new WeatherFactory("856822fd8e22db5e1ba48c0e7d69844a",
          language: Language.ENGLISH);
      await wf
          .currentWeatherByLocation(
              currentLocation.latitude, currentLocation.longitude)
          .then((value) {
        weather = value;
        weatherInfo = true;
        print("weatherCall" + " xzfdf " + weather.toString());
        notifyListeners();
      });
    }

    print("weatherCall");
  }

  String get getWifiFinalVal => wifiFinal;

  Weather get getCurWeatherInfo => weather;

  bool get getWaetherStatus => weatherInfo;

  @override
  Future<List<dynamic>> cmsCommands(BuildContext context) async {
    // TODO: implement cmsCommands
    List<dynamic> commands = await fetchCMSFromServer();
    return commands;
  }

  @override
  Future<void> getLocation() async {
    // TODO: implement getLocation
    // TODO: implement getLocation
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
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
    print('Bloc Loc : 123456');
    currentLocationBloc.value = await location.getLocation();
    print('Bloc Location 1: ${currentLocationBloc.value.latitude}');
    print('Bloc Location 2: ${currentLocationBloc.value.longitude}');
  }

  @override
  void startTime() {
    int i = 1;
    // TODO: implement startTime
    Timer.periodic(Duration(seconds: i), (Timer t) {
      timeNow.value = formatDateTime(DateTime.now());
      dateNow.value = formatDate(DateTime.now());
    });
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm').format(dateTime);
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  Future<List<dynamic>> fetchCMSFromServer() async {
    const region = "eu-west-2";
    const bucketId = "connie-speech-responses-v";
    final AwsS3Client s3client = AwsS3Client(
        region: region,
        host: "s3.$region.amazonaws.com",
        bucketId: bucketId,
        accessKey: "AKIAZLWS77EPICPMMREK",
        secretKey: "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");
    final listBucketResult =
        await s3client.listObjects(prefix: "dir/dir2/", delimiter: "/");
    final response = await s3client.getObject('speech_responses.json');
    List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
    return responseJson;
  }
}
