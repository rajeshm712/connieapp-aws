import 'package:flutter/cupertino.dart';

abstract class TypeAbstract extends ChangeNotifier {
  List<int> initValues();

  void visualiser();

  void setSpeakVal(String speakVal);

  String getSpeakVal();

  void setSpeakSubmissionStatus(bool statusSpeakSub);

  bool getSpeakSubmissionStatus();
}
