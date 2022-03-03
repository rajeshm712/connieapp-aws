import 'package:connie/src/abstract/controlButtonsAbstract.dart';

class ControlButtonsProvider extends ControlButtonsAbstract {
  bool micPressed = false;
  bool typePressed = false;
  bool mapPressed = false;
  bool callPressed = false;

  @override
  bool getCallButtonPressStatus() {
    // TODO: implement getCallButtonPressStatus
    return callPressed;
  }

  @override
  bool getMapButtonPressStatus() {
    // TODO: implement getMapButtonPressStatus
    return mapPressed;
  }

  @override
  bool getMicButtonPressStatus() {
    // TODO: implement getMicButtonPressStatus
    return micPressed;
  }

  @override
  bool getTypeButtonPressStatus() {
    // TODO: implement getTypeButtonPressStatus
    return typePressed;
  }

  @override
  void setCallButtonPressStatus(bool pressed) {
    // TODO: implement setCallButtonPressStatus
    callPressed = pressed;
    notifyListeners();
  }

  @override
  void setMapButtonPressStatus(bool pressed) {
    // TODO: implement setMapButtonPressStatus
    mapPressed = pressed;
    notifyListeners();
  }

  @override
  void setMicButtonPressStatus(bool pressed) {
    // TODO: implement setMicButtonPressStatus
    micPressed = pressed;
    notifyListeners();
  }

  @override
  void setTypeButtonPressStatus(bool pressed) {
    // TODO: implement setTypeButtonPressStatus
    typePressed = pressed;
    notifyListeners();
  }
}
