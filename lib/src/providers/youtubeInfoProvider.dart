import 'package:connie/src/abstract/youtubeInfoAbstract.dart';

class YoutubeInfoProvider extends YoutubeInfoAbstract {
  bool isvideoLiveStatus = false;
  bool isViodeoPlaying = false;
  String youtubeIdInfo = "";

  @override
  getVideoLiveStatus() {
    // TODO: implement getVideoLiveStatus
    return isvideoLiveStatus;
  }

  @override
  getYoutubeId() {
    // TODO: implement getYoutubeId
    return youtubeIdInfo;
  }

  @override
  getvideoPlayingStatus() {
    // TODO: implement getvideoPlayingStatus
    return isViodeoPlaying;
  }

  @override
  void setLiveVideoStatus(bool videlLiveStatus) {
    // TODO: implement setLiveVideoStatus
    isvideoLiveStatus = videlLiveStatus;
    notifyListeners();
  }

  @override
  void setYoutubeId(String youtubeId) {
    // TODO: implement setYoutubeId
    youtubeIdInfo = youtubeId;
    notifyListeners();
  }

  @override
  void setisVideoPlayingStatus(bool videoPLayingStatus) {
    // TODO: implement setisVideoPlayingStatus
    isViodeoPlaying = videoPLayingStatus;
    notifyListeners();
  }

  get videoPlayStatus => isViodeoPlaying;

  get videoId => youtubeIdInfo;
}
