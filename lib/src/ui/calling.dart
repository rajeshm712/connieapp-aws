import 'package:connie/src/abstract/cms_query_impl.dart';
import 'package:flutter/material.dart';

class Calling extends StatelessWidget {
// receive data from the FirstScreen as a parameter
  Calling({Key key, @required this.text}) : super(key: key);
  final String text;
  var bloc = CMSQueryImpl();
  BuildContext globalContext;

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: new BoxDecoration(
            //color is transparent so that it does not blend with the actual color specified
            color: new Color.fromRGBO(40, 40, 40,
                0.96) // Specifies the background color and the opacity
            ),
        child: Stack(
          children: [
            Positioned(
                top: 135,
                left: 470,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Connie is contacting" + " " + "Sanjeev",
                    style: TextStyle(color: Colors.white70, fontSize: 22.0),
                    textAlign: TextAlign.center,
                  ),
                )),
            Positioned(
              top: 230,
              left: 380,
              child: Text(
                "Calling  " + "Sanjeev" + "....",
                style: TextStyle(color: Colors.white, fontSize: 60.0),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: 50,
              left: 95,
              child: SizedBox(
                width: 219.4,
                height: 58.5,
                child: Image.asset("assets/images/connie_logo.png"),
              ),
            ),
            Positioned(
              top: 45,
              right: 50,
              child: SizedBox(
                width: 60,
                height: 60,
                child: GestureDetector(
                  child: Image.asset("assets/images/cancel.png"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Positioned(
              top: 400,
              left: 360,
              child: SizedBox(
                height: 129.6,
                width: 528,
                child: Image.asset('assets/images/cloud_up.png'),
              ),
            ),
            Positioned(
              top: 530,
              left: 360,
              child: SizedBox(
                height: 129.5,
                width: 528,
                child: Image.asset('assets/images/cloud_down.png'),
              ),
            ),
            Positioned(
              bottom: 75,
              left: 438,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset("assets/images/microphone.png"),
                    ),
                    onTap: () {},
                  ),
                  SizedBox(
                    width: 45,
                  ),
                  GestureDetector(
                    child: SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: Image.asset("assets/images/type.png"),
                    ),
                    onTap: () {},
                  ),
                  SizedBox(
                    width: 45,
                  ),
                  GestureDetector(
                    child: SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: Image.asset("assets/images/map.png"),
                    ),
                  ),
                  SizedBox(
                    width: 27,
                  ),
                  GestureDetector(
                    child: SizedBox(
                      width: 90.0,
                      height: 90.0,
                      child: Image.asset("assets/images/call_pressed.png"),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
