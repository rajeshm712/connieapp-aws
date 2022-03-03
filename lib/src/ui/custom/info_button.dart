import 'package:connie/src/providers/infoButtonProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool infoPressed =
        Provider.of<InfoButtonProvider>(context).getInfoButtonPressStatus();
    return Container(
      child: SizedBox(
        width: infoPressed ? 90.0 : 60,
        height: infoPressed ? 90.0 : 60,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: infoPressed
              ? Image.asset("assets/images/info_pressed.png")
              : Image.asset("assets/images/info.png"),
          onTap: () => setButtonPressStatus(context, infoPressed),
        ),
      ),
    );
  }

  void setButtonPressStatus(BuildContext context, bool infoPressed) {
    Provider.of<InfoButtonProvider>(context, listen: false)
        .setInfoButtonPressStatus(!infoPressed);
  }
}
