import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtil {
  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }

  static String getTwoDecimalValue(var value) {
    var num2 = value.toStringAsFixed(2);
    return num2;
  }

  static Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static double getNumber(double input, {int precision = 2}) {
    return double.parse(
        '$input'.substring(0, '$input'.indexOf('.') + precision + 1));
  }

  static String getCurrentTime() {
    DateTime now = DateTime.now();
    String time = now.hour.toString() + ":" + now.minute.toString();
    print("chhonker time-" + time);
    return time;
  }

  static void makingPhoneCall(String number) async {
    // String url = "tel:" + "+91-7006625924";
    String url = "tel:" + number.replaceAll(' ', '');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
