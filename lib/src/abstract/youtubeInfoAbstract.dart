import 'package:flutter/cupertino.dart';

abstract class YoutubeInfoAbstract extends ChangeNotifier {
  void setisVideoPlayingStatus(bool videoPLayingStatus);

  getvideoPlayingStatus();

  void setLiveVideoStatus(bool videlLiveStatus);

  getVideoLiveStatus();

  void setYoutubeId(String youtubeId);

  getYoutubeId();
}
