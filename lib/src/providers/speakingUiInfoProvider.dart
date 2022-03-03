import 'package:connie/src/abstract/speakingUiInfoAbstract.dart';

class SpeakingUiInfoProvider extends SpeakingUiInfoAbstract {
  bool isSpeaking = false;
  bool isFetching = false;
  bool isMusicPlaying = false;
  String speakTextVal;

  @override
  getFetchResultsStatus() {
    // TODO: implement getFetchResultsStatus
    return isFetching;
  }

  @override
  getspeakingStatus() {
    // TODO: implement getspeakingStatus
    return isSpeaking;
  }

  @override
  void setFetchResultsStatus(bool fetching) {
    // TODO: implement setFetchResultsStatus
    isFetching = fetching;
    notifyListeners();
  }

  @override
  void setSpeakingStatus(bool speaking) {
    // TODO: implement setSpeakingStatus
    isSpeaking = speaking;
    notifyListeners();
  }

  @override
  getMusicPlayingStatus() {
    // TODO: implement getMusicPlayingStatus
    return isMusicPlaying;
  }

  @override
  void setMusicPlayingStatus(bool playing) {
    // TODO: implement setMusicPlayingStatus
    isMusicPlaying = playing;
    notifyListeners();
  }

  @override
  getSpeakingText() {
    // TODO: implement getSpeakingText
    return speakTextVal;
  }

  @override
  void setSpeakingText(String speakText) {
    // TODO: implement setSpeakingText
    speakTextVal = speakText;
    notifyListeners();
  }

  get speakStatuss => isSpeaking;

  get speakingTextVal => speakTextVal;

  get fetchinfVal => isFetching;

  get musicPlayingVal => isMusicPlaying;
}
