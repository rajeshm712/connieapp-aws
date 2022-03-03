import 'package:connie/src/abstract/infoAbstract.dart';

class InfoButtonProvider extends InfoAbstract {
  bool buttonPressed = false;

  @override
  bool getInfoButtonPressStatus() {
    return buttonPressed;
  }

  @override
  void setInfoButtonPressStatus(bool pressed) {
    buttonPressed = pressed;
    notifyListeners();
    // TODO: implement setInfoButtonPressStatus
  }
}
