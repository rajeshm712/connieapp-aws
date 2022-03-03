import 'package:flutter/material.dart';

class WelcomeWidget extends StatelessWidget {
  final double welcomeSize;
  final bool mapEnable;

  WelcomeWidget({Key key, this.welcomeSize, this.mapEnable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: mapEnable ? 70 : 100),
            child: Text(
              "Welcome",
              key: Key('welcome'),
              style: TextStyle(
                color: Colors.white,
                fontSize: welcomeSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        mapEnable
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    top: 10,
                  ),
                  child: Text(
                    "\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF",
                    style: TextStyle(color: Colors.white30, fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    "\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF"
                    "\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF\u25CF",
                    style: TextStyle(color: Colors.white30, fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
      ],
    );
  }
}
