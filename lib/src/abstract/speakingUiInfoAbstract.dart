import 'package:flutter/cupertino.dart';

abstract class SpeakingUiInfoAbstract extends ChangeNotifier {
  void setFetchResultsStatus(bool fetching);

  getFetchResultsStatus();

  void setSpeakingStatus(bool speaking);

  getspeakingStatus();

  void setMusicPlayingStatus(bool playing);

  getMusicPlayingStatus();

  void setSpeakingText(String speakText);

  getSpeakingText();
}
