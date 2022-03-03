import 'dart:async';
import 'package:connie/src/providers/typeSpeakProvider.dart';
import 'package:flutter/material.dart';
import 'package:connie/src/ui/custom/audio_visualiser.dart';
import 'package:connie/src/utils/commonVal.dart';
import 'package:provider/provider.dart';

class Type extends StatelessWidget {
  TextEditingController editingController;
  Timer timer;
  TypeSpeakProvider typeSpeakProvider;
  final Function(String) onCommand;

  Type({Key key, this.onCommand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    typeSpeakProvider = Provider.of<TypeSpeakProvider>(context);

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black, //new Color.fromRGBO(40, 40, 40, 0.96),
      body: Container(
        height: screenHeight,
        decoration: new BoxDecoration(
            //color is transparent so that it does not blend with the actual color specified
            color: new Color.fromRGBO(40, 40, 40,
                0.96) // Specifies the background color and the opacity
            ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 219.4,
                    height: 53.5,
                    child: Image.asset("assets/images/connie_logo.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: GestureDetector(
                    key: Key('type_screen_close_button'),
                    child: SizedBox(
                        height: 55.0,
                        width: 60.0,
                        child: Image.asset("assets/images/cancel.png")),
                    onTap: () {
                      if (timer != null) {
                        timer.cancel();
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: ConstantVal.isSpeaking
                    ? Text('')
                    : Text(
                        "Type your request for Connie:",
                        style: TextStyle(color: Colors.white70, fontSize: 22.0),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            ConstantVal.isSpeaking
                ? Expanded(
                    child: Center(
                    child: SizedBox(
                      height: 100.0,
                      width: 600.0,
                      child: CustomPaint(
                        size: Size.fromHeight(40.0),
                        painter: LineBarVisualizer(
                          color: Colors.white30,
                          width: screenWidth * 0.5,
                          height: screenHeight * .05,
                          waveData: typeSpeakProvider.initValues(),
                        ),
                      ),
                      // Image.asset('assets/images/cloud_up.png'),
                    ),
                  ))
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                        key: Key('type_command'),
                        textAlign: TextAlign.center,
                        cursorColor: Colors.cyanAccent,
                        autofocus: true,
                        controller: editingController,
                        decoration: InputDecoration(
                          // hintText: 'Type Text Here',
                          focusColor: Colors.greenAccent,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .black), //new Color.fromRGBO(40, 40, 40, 0.96)
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: new Color.fromRGBO(40, 40, 40, 0.96)),
                          ),
                        ),
                        onSubmitted: (String val) {
                          Navigator.pop(context);
                          setSpeakValues(context, val);
                          onCommand(val);
                          typeSpeakProvider.visualiser();
                          // setState(() {
                          //   ConstantVal.isSpeaking = true;
                          // });
                          editingController.clear();
                          if (!ConstantVal.isSpeaking) {
                            timer.cancel();
                          }
                        },
                      ),
                    ),
                  ),
            Expanded(
              flex: 3,
              child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child:
                              Image.asset("assets/images/microphone_off.png"),
                        ),
                        onTap: () {},
                      ),
                      SizedBox(
                        width: 36,
                      ),
                      GestureDetector(
                        child: SizedBox(
                          width: 90.0,
                          height: 90.0,
                          child: Image.asset("assets/images/type_pressed.png"),
                        ),
                        onTap: () {},
                      ),
                      SizedBox(
                        width: 36,
                      ),
                      GestureDetector(
                        child: SizedBox(
                          width: 60.0,
                          height: 60.0,
                          child: Image.asset("assets/images/map.png"),
                        ),
                      ),
                      SizedBox(
                        width: 45,
                      ),
                      GestureDetector(
                        child: SizedBox(
                          width: 60.0,
                          height: 80.0,
                          child: Image.asset("assets/images/call.png"),
                        ),
                        onTap: () {},
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
      // )
    );
  }

  void setSpeakValues(BuildContext context, String speakValues) {
    Provider.of<TypeSpeakProvider>(context, listen: false)
        .setSpeakVal(speakValues);
  }
}
