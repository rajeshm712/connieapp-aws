import 'package:flutter/cupertino.dart';

abstract class HomeScreenAbstract extends ChangeNotifier {
  intializeVideoListners(BuildContext context);

  videoCallScreen(BuildContext context, bool videoStream);

  chagePhoneSoundModestoSilent();

  chagePhoneSoundModestoNormal();

  showVideoIncomingDialogue(BuildContext context);

  initVales(BuildContext context);

  setupMicButton(bool status, BuildContext context);

  setupMapButton(bool status, BuildContext context);

  setupTypeButton(bool status, BuildContext context);

  setupSpeakingStatus(bool status, BuildContext context);

  setupSpeakText(String speakValue, BuildContext context);

  setupMusicPlayingStatus(bool misicPlayijng, BuildContext context);

  setupFetchingStatus(bool fetching, BuildContext context);

  setupYoutubePlayerPlayingStatus(bool playingStatus, BuildContext context);

  setupYoutubrPlayerLiveVideoStatus(bool liveVideoStatus, BuildContext context);

  setupYoutubeId(String youtubeId, BuildContext context);

  initTts(BuildContext context);

  setupVolume();

  getPermissionStatus();

  Future<void> openDoNotDisturbSettings();

  stop();

  getLanguages();

  onSearchButtonPressed(BuildContext context);

  callMapScreen(BuildContext context);

  void callNativeTts(bool nativeTTS, String startOrStop, BuildContext context);

  stopListening(BuildContext context);

  cancelListening();

  soundLevelListener(double level);

  statusListener(String status);

  callNativeForCall(String callStatus, String accesstoken, String callTo,
      BuildContext context);

  callingInProgress(BuildContext context);

  callAccessTokenAPI(
      String registerTwilio, String callTo, BuildContext context);

  callStatusTrigger(String callStatus, bool progressStatus);

  trigerVideoCalltoOtherClient(String callFrom, String CallStatus,
      bool callProgress, bool videoCall, String callTo);

  trigerAudioVideoSwitch(
      bool audioSwitch, bool audio, bool video, String callStatus);

  eCommerceProductSite(String productName, BuildContext context);

  speak(String command, bool sTTFlag, BuildContext context);

  startTimer();

  getResponseFromFireBaseData(String qns);

  customSearchWelform(String query);

  openNativeConApp();

  fetchCMS(BuildContext context);

  speakOut(String speakValue, BuildContext context);
}
