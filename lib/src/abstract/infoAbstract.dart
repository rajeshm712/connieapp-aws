import 'package:flutter/cupertino.dart';

abstract class InfoAbstract extends ChangeNotifier {
  void setInfoButtonPressStatus(bool pressed);

  bool getInfoButtonPressStatus();
}
