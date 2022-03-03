import 'package:flutter/material.dart';

class ViewUtil {
  static void showSnackBar(
      GlobalKey<ScaffoldState> _scaffoldKey, String message) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: new Duration(seconds: 2),
      content: new Row(
        children: <Widget>[new Text(message)],
      ),
    ));
  }

  static bool checkStringIsEmpty(String s) {
    if (s != null && s.isNotEmpty) {
      return true;
    }
    return false;
  }

  static void openDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Material(
              color: Colors.transparent,
              shadowColor: Colors.grey,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Center(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Image.asset(
                          "assets/images/ic_conapp_wifi.gif",
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
            ));
      },
    );
  }

  static bool checkEmailValid(String value) {
    bool isValid = RegExp(
            r"^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$")
        .hasMatch(value);

    return isValid;
  }
}
