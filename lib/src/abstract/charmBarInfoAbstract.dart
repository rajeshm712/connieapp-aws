import 'package:flutter/cupertino.dart';
import 'package:frideos/frideos.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';

abstract class CharmBarInfoAbstract extends ChangeNotifier {
  intializeCharmBarItemsValues();

  setWeather();

  var timeNow = StreamedValue<String>(initialData: '');
  var dateNow = StreamedValue<String>(initialData: '');
  var weatherStream = StreamedValue<Weather>(initialData: null);
  var currentLocationBloc = StreamedValue<LocationData>();

  void startTime();

  void getLocation();

  Future<List<dynamic>> cmsCommands(BuildContext context);
}
