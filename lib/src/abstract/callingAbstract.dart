import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';

abstract class CallingAbstract extends ChangeNotifier {
  startTimmer(BuildContext context);

  String getTimerTime(int start);

  intiAgora(BuildContext context, String chanelName, ClientRole role);

  switchAudioVideo();

  trigerVideoRequest(String callStatus);

  showSnackBar(String contents, BuildContext context);

  onCallEnd();

  onToggleMute(bool audio, BuildContext context);

  setupAudioCall(bool audioStatus);

  setupVideoStatus(bool videoStatus);

  bool getAudioStatus();

  bool getVideoStatus();

  setupAgoraVideoInfo(List<String> videoInfo);

  List<String> getAgoraVideoInfo();

  setupCallTimer(String timerValues);

  String getCallTimerValue();

  setupMuteStatus(bool mutestatus);

  bool getMuteStatus();
}
