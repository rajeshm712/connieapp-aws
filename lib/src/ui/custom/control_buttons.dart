import 'package:connie/src/abstract/cms_query_impl.dart';
import 'package:connie/src/providers/controlButtonsProvider.dart';
import 'package:connie/src/providers/infoButtonProvider.dart';
import 'package:flutter/material.dart';
import 'package:connie/src/UI/type.dart';
import 'package:connie/src/UI/calling.dart';
import 'package:http/http.dart' as https;
import 'package:provider/provider.dart';

class ControlButtons extends StatelessWidget {
  final Function(String) speak;
  final Function(bool) setupui;
  final Function(bool) ismapEnable;
  final bool mapFlag;

  ControlButtons({this.speak, this.setupui, this.ismapEnable, this.mapFlag});

  var bloc = CMSQueryImpl();
  bool micFlag;
  bool isInfoPressed;
  bool isMapEnabled = false;
  bool typePressed = false;

  @override
  Widget build(BuildContext context) {
    isInfoPressed =
        Provider.of<InfoButtonProvider>(context).getInfoButtonPressStatus();
    micFlag =
        Provider.of<ControlButtonsProvider>(context).getMicButtonPressStatus();
    isMapEnabled =
        Provider.of<ControlButtonsProvider>(context).getMapButtonPressStatus();
    typePressed =
        Provider.of<ControlButtonsProvider>(context).getTypeButtonPressStatus();
    return Container(
      padding: EdgeInsets.only(left: 2.0, right: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 0, right: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  key: Key('mic_button'),
                  child: SizedBox(
                    width: micFlag ? 90 : 60,
                    height: micFlag ? 90 : 60,
                    child: micFlag
                        ? Image.asset("assets/images/microphone_pressed.png")
                        : Image.asset("assets/images/microphone_off.png"),
                  ),
                  onTap: () {
                    setMicButtonPressStatus(context, !micFlag);

                    // setState(() {
                    //   ConstantVal.isTypePressed = false;
                    //   ConstantVal.isMicPressed = !ConstantVal.isMicPressed;
                    //   widget.isMicPressed(ConstantVal.isMicPressed);
                    // });
                    // Navigator.of(context).push(new MaterialPageRoute(
                    //     builder: (BuildContext context1) =>
                    //         Type(
                    //           onCommand: (val) {f
                    setupui(!micFlag);
                    // },
                    // )));
                  },
                ),
                if (isInfoPressed)
                  SizedBox(
                    height: 5,
                  ),
                if (isInfoPressed)
                  SizedBox(
                    width: 67.2,
                    height: 16.8,
                    child: Image.asset("assets/images/group_17.png"),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: micFlag ? 27 : 45,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2, right: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  key: Key('type_button'),
                  child: SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: Image.asset("assets/images/type.png"),
                  ),
                  onTap: () {
                    print("textPressed");
                    if (!micFlag) {
                      typeButtonFunction(context);
                    }
                  },
                ),
                if (isInfoPressed)
                  SizedBox(
                    height: 5,
                  ),
                if (isInfoPressed)
                  SizedBox(
                    width: 88,
                    height: 16.8,
                    child: Image.asset("assets/images/group_18.png"),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 45,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2, right: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  key: Key('map'),
                  onTap: () {
                    isMapEnabled = !isMapEnabled;
                    setMapButtonPressStatus(context, isMapEnabled);
                    ismapEnable(isMapEnabled);
                  },
                  child: mapFlag
                      ? SizedBox(
                          width: 85.0,
                          height: 85.0,
                          child: Image.asset(
                            "assets/images/map_pressed.png",
                            fit: BoxFit.contain,
                          ),
                        )
                      : SizedBox(
                          width: 60.0,
                          height: 60.0,
                          child: Image.asset("assets/images/map.png"),
                        ),
                ),
                if (isInfoPressed)
                  SizedBox(
                    height: 5,
                  ),
                if (isInfoPressed)
                  SizedBox(
                    width: 56,
                    height: 16.8,
                    child: Image.asset("assets/images/group_19.png"),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 45,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2, right: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: Image.asset("assets/images/call.png"),
                  ),
                  onTap: () {
                    print("callPressed");
                    callAccessTokenAPI(context);
                  },
                ),
                if (isInfoPressed)
                  SizedBox(
                    height: 5,
                  ),
                if (isInfoPressed)
                  SizedBox(
                    width: 84.7,
                    height: 16.8,
                    child: Image.asset("assets/images/group_20.png"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void typeButtonFunction(BuildContext context) {
    setTypeButtonPressStatus(context, !typePressed);
    // setState(() {
    //   ConstantVal.isTypePressed = true;
    //
    // });
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context1) => Type(
              onCommand: (val) {
                speak(val);
              },
            )));
  }

  void callNativeForCall(
      String callStatus, String accessToken, BuildContext context) {
    bloc
        .cmsQuery(false, callStatus, accessToken, "call to supervisor")
        .then((value) async {
      print("callPressed   API response");

      if (value.toLowerCase().contains('ringing')) {
        Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              Calling(text: 'Supervisor'),
        ));
      }
    });
  }

  Future<void> callAccessTokenAPI(BuildContext context) async {
    final response = await https.get(Uri.parse(
        "https://connie-app-helper.dev.conigitalcloud.io/accessToken?identity=avinash"));
    if (response.statusCode == 200) {
      print("callPressed   API CAlled");
      callNativeForCall("callTwilio", response.body.toString(), context);
    } else {}
  }

  void setMicButtonPressStatus(BuildContext context, bool micpressed) {
    // setTypeButtonPressStatus(context, false);
    Provider.of<ControlButtonsProvider>(context, listen: false)
        .setMicButtonPressStatus(micpressed);
  }

  void setMapButtonPressStatus(BuildContext context, bool mapPressed) {
    Provider.of<ControlButtonsProvider>(context, listen: false)
        .setMapButtonPressStatus(mapPressed);
    print("mapfagsf  1233" +
        Provider.of<ControlButtonsProvider>(context, listen: false)
            .getMapButtonPressStatus()
            .toString());
  }

  void setTypeButtonPressStatus(BuildContext context, bool typePressed) {
    Provider.of<ControlButtonsProvider>(context, listen: false)
        .setTypeButtonPressStatus(typePressed);
  }
}
