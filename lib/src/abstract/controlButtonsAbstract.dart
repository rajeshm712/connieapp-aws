import 'package:flutter/cupertino.dart';

abstract class ControlButtonsAbstract extends ChangeNotifier {
  void setMicButtonPressStatus(bool pressed);

  bool getMicButtonPressStatus();

  void setTypeButtonPressStatus(bool pressed);

  bool getTypeButtonPressStatus();

  void setMapButtonPressStatus(bool pressed);

  bool getMapButtonPressStatus();

  void setCallButtonPressStatus(bool pressed);

  bool getCallButtonPressStatus();
}
