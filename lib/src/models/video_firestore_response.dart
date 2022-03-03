// Created by Sanjeev Sangral on 08/09/21.
class VideoFireStore {
  String callStatus;
  String videoId;
  String channelName;
  String callProgress;

  VideoFireStore(
      {this.callStatus, this.videoId, this.channelName, this.callProgress});

  VideoFireStore.fromJson(Map<String, dynamic> json) {
    callProgress = json['callprogress'];
    channelName = json['channelname'];
    callStatus = json['callstatus'];
    videoId = json['videoid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['callprogress'] = this.callProgress;
    data['channelname'] = this.channelName;
    data['callstatus'] = this.callStatus;
    data['videoid'] = this.videoId;
    return data;
  }
}
