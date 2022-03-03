import 'package:connie/src/providers/charmBarInfoProvider.dart';
import 'package:connie/src/providers/infoButtonProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

class TopGroup extends StatelessWidget {
  bool infoPressed = false;
  Weather weather;
  TextStyle style = TextStyle(
      color: Colors.white60, fontSize: 18.0, fontFamily: 'Montserrat');
  double widgetHeight = 25.0;
  double widgetWidth = 25.0;

  //wifi information widget//
  Widget wifiInfo(CharmBarInfoProvider charmBarInfoProvider) {
    return Container(
      padding: EdgeInsets.only(left: 7.0, right: 7.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 7, right: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Image.asset(
                      charmBarInfoProvider.getWifiFinalVal,
                      height: widgetHeight,
                      width: widgetWidth,
                    ),
                    Text(
                      '  EE',
                      style: style,
                    ),
                  ],
                ),
                if (infoPressed)
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: 25.6,
                      height: 16.8,
                      child: Image.asset("assets/images/group_21.png"),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //time clock information widget//
  Widget timeClockInfo(CharmBarInfoProvider charmBarInfoProvider) {
    return Container(
      padding: EdgeInsets.only(left: 7.0, right: 7.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 7, right: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Image.asset(
                      "assets/images/icon_feather_clock.png",
                      height: widgetHeight * .9,
                      width: widgetWidth,
                    ),
                    StreamBuilder<String>(
                        stream: charmBarInfoProvider.timeNow.outStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          return Text(
                              snapshot.data != null
                                  ? '  ' + snapshot.data
                                  : "  ",
                              style: style);
                        }),
                  ],
                ),
                if (infoPressed)
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: 28.8,
                      height: 16.8,
                      child: Image.asset("assets/images/group_22.png"),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //calender information widget//
  Widget calenderInfo(CharmBarInfoProvider charmBarInfoProvider) {
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 7, right: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Image.asset(
                      "assets/images/icon_feather_calendar.png",
                      height: widgetHeight * .9,
                      width: widgetWidth,
                    ),
                    StreamBuilder<String>(
                        stream: charmBarInfoProvider.dateNow.outStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
//                      return Text(snapshot.data, style: style);
                          return Text(
                              snapshot.data != null
                                  ? '  ' + snapshot.data
                                  : "  ",
                              style: style);
                        }),
                  ],
                ),
                if (infoPressed)
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: 27.2,
                      height: 16.8,
                      child: Image.asset("assets/images/group_23.png"),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //weather information widget//
  Widget weatherInfo(CharmBarInfoProvider charmBarInfoProvider) {
    return Container(
      padding: EdgeInsets.only(left: 7.0, bottom: 4, right: 7.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 7, right: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
//                Icon(Icons.event)
                    BoxedIcon(
                      WeatherIcons.fromString(
                          '0xf' +
                              charmBarInfoProvider
                                  .getCurWeatherInfo.weatherIcon,
                          // Fallback is optional, throws if not found, and not supplied.
                          fallback: charmBarInfoProvider
                                      .getCurWeatherInfo.temperature.celsius <
                                  10
                              ? WeatherIcons.snow
                              : (charmBarInfoProvider.getCurWeatherInfo.temperature.celsius <= 15
                                  ? WeatherIcons.snow_wind
                                  : (charmBarInfoProvider.getCurWeatherInfo
                                                  .temperature.celsius <
                                              20 &&
                                          charmBarInfoProvider.getCurWeatherInfo
                                                  .temperature.celsius >
                                              15
                                      ? WeatherIcons.cloudy
                                      : (charmBarInfoProvider.getCurWeatherInfo
                                                      .temperature.celsius >
                                                  20 &&
                                              charmBarInfoProvider
                                                      .getCurWeatherInfo
                                                      .temperature
                                                      .celsius >
                                                  25
                                          ? WeatherIcons.day_sunny
                                          : WeatherIcons.day_sunny_overcast)))),
                      color: Colors.white60,
                      size: 25.0,
                    ),
                    Text(
                      charmBarInfoProvider.getCurWeatherInfo != null
                          ? '  ' +
                              charmBarInfoProvider
                                  .getCurWeatherInfo.temperature.celsius
                                  .toString()
                                  .substring(0, 2) +
                              '°' +
                              'c'
                          : '0.0',
                      style: style,
                    )
                  ],
                ),
                if (infoPressed)
                  Padding(
                    padding: EdgeInsets.only(bottom: 2),
                    child: SizedBox(
                      width: 48,
                      height: 16.8,
                      child: Image.asset("assets/images/group_24.png"),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CharmBarInfoProvider charmBarInfoProvider =
        Provider.of<CharmBarInfoProvider>(context);
    infoPressed =
        Provider.of<InfoButtonProvider>(context).getInfoButtonPressStatus();
    charmBarInfoProvider.intializeCharmBarItemsValues();
    return Consumer<CharmBarInfoProvider>(builder: (context, charmProv, child) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          wifiInfo(charmProv),
          timeClockInfo(charmProv),
          calenderInfo(charmProv),
          if (charmBarInfoProvider.getCurWeatherInfo != null)
            weatherInfo(charmBarInfoProvider),
        ],
      );
    });
  }
}
