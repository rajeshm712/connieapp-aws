import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connie/src/abstract/callingAbstract.dart';
import 'package:connie/src/models/agora_response.dart';
import 'package:connie/src/utils/commonVal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:provider/provider.dart';

class CallingProvider extends CallingAbstract {
  final _users = <int>[];
  List<String> infoStrings;

  bool muted = false;
  bool mutedAudio = false;
  final agotaInfo = <String>[];
  String timerValue;
  bool muteStatus = false;

  RtcEngine _engine;
  String APP_ID = ConstantVal().agoraAppId;
  String token = "";
  bool userJoined = false;
  bool videoEnable = false;
  bool audioCall = false;
  CollectionReference referenceFirebase;
  bool switchState = false;
  bool audio = false;
  bool video = false;
  String callStatusAgora;
  bool localUser = false;
  String videoRequestStatus;
  bool videoRequPopShow = false;

  bool audioCallStatus = false;
  bool videoCallStatus = false;

  Timer _timmerInstance;
  int _start = 0;
  String timmer = '';
  bool timerStarted = false;

  @override
  String getTimerTime(int start) {
    // TODO: implement getTimerTime
    int minutes = (start ~/ 60);
    String sMinute = '';
    if (minutes.toString().length == 1) {
      sMinute = '0' + minutes.toString();
    } else
      sMinute = minutes.toString();

    int seconds = (start % 60);
    String sSeconds = '';
    if (seconds.toString().length == 1) {
      sSeconds = '0' + seconds.toString();
    } else
      sSeconds = seconds.toString();

    return sMinute + ':' + sSeconds;
  }

  @override
  void onCallEnd() {
    videoRequPopShow = false;
    localUser = false;
    trigerAudioVideoSwitch(false, false, false, "ended");
    // Navigator.pop(context);
  }

  @override
  void onToggleMute(bool audio, BuildContext context) {
    // setState(() {
    if (!audio) {
      muted = !muted;
      _engine.muteLocalAudioStream(muted);
    } else {
      mutedAudio = !mutedAudio;
      setupMutetatusProvider(context, mutedAudio);
      _engine.muteLocalAudioStream(mutedAudio);
    }
    // });
  }

  void setupMutetatusProvider(BuildContext context, bool muteStatus) {
    Provider.of<CallingProvider>(context, listen: false)
        .setupMuteStatus(muteStatus);
  }

  void setupVideoStatusProvider(BuildContext context, bool videoSttsus) {
    Provider.of<CallingProvider>(context, listen: false)
        .setupVideoStatus(videoSttsus);
  }

  void setupAudioStatusProvider(BuildContext context, bool videoSttsus) {
    Provider.of<CallingProvider>(context, listen: false)
        .setupAudioCall(videoSttsus);
  }

  void setupAgoraVideoInfoStatusProvider(
      BuildContext context, List<String> videoInfo) {
    Provider.of<CallingProvider>(context, listen: false)
        .setupAgoraVideoInfo(videoInfo);
  }

  void setupCallingTimer(BuildContext context, String timerVal) {
    Provider.of<CallingProvider>(context, listen: false)
        .setupCallTimer(timerVal);
  }

  void onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  intiAgora(BuildContext context, String chanelName, ClientRole role) {
    // TODO: implement intiAgora
    referenceFirebase = FirebaseFirestore.instance.collection('agoravideo');
    listentoFirebaseTrigger(context);

    // initialize agora sdk
    getAgoraAccessToken(chanelName, role, context);
  }

  Future<void> getAgoraAccessToken(
      String chlName, ClientRole role, BuildContext context) async {
    final response = await https.get(Uri.parse(
        "https://connie-app-helper.dev.conigitalcloud.io/agoraToken?channel=firstchannel"));
    if (response.statusCode == 200) {
      AgoraResponse agoraResponse =
          AgoraResponse.fromJson(jsonDecode(response.body));
      print("agoraToken" + agoraResponse.token);
      initialize(agoraResponse.token, chlName, role, context);
    }
  }

  Future<void> initialize(String accessToken, String chanelName,
      ClientRole role, BuildContext context) async {
    if (ConstantVal().agoraAppId.isEmpty) {
      // setState(() {
      agotaInfo
          .add("APP_ID missing, please provide your APP_ID in settings.dart");
      agotaInfo.add("Agora Engine is not starting");

      setupAgoraVideoInfoStatusProvider(context, agotaInfo);

      return;
    }

    await initAgoraRtcEngine(role);
    _addAgoraEventHandlers(context);
    await _engine.enableVideo();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(500, 500);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(accessToken, chanelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> initAgoraRtcEngine(ClientRole role) async {
    _engine = await RtcEngine.create(ConstantVal().agoraAppId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers(BuildContext context) {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      // setState(() {
      final info = 'onError: $code';
      agotaInfo.add(info);
      setupAgoraVideoInfoStatusProvider(context, agotaInfo);

      // infoStrings.add(info);
      // });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      // setState(() {
      if (!timerStarted) {
        startTimmer(context);
        // setState(() {
        if (!audioCall) {
          setupAudioStatusProvider(context, true);
          audioCall = true;
        } else {
          setupVideoStatusProvider(context, true);
          videoEnable = true;
          final info = 'onJoinChannel: $channel, uid: $uid';
          agotaInfo.add(info);

          setupAgoraVideoInfoStatusProvider(context, agotaInfo);
        }
        // });
      }
      // userJoined = true;
      // });
    }, leaveChannel: (stats) {
      // setState(() {
      agotaInfo.add("onLeaveChannel");
      setupAgoraVideoInfoStatusProvider(context, agotaInfo);

      // infoStrings.add('onLeaveChannel');
      _users.clear();
      // });
    }, userJoined: (uid, elapsed) {
      // setState(() {
      final info = 'userJoined: $uid';

      agotaInfo.add(info);
      setupAgoraVideoInfoStatusProvider(context, agotaInfo);
      // infoStrings.add(info);
      _users.add(uid);
      // });
    }, userOffline: (uid, elapsed) {
      // setState(() {
      final info = 'userOffline: $uid';
      agotaInfo.add(info);
      setupAgoraVideoInfoStatusProvider(context, agotaInfo);
      // infoStrings.add(info);
      _users.remove(uid);
      // });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      // setState(() {
      final info = 'firstRemoteVideo: $uid ${width}x $height';
      agotaInfo.add(info);
      setupAgoraVideoInfoStatusProvider(context, agotaInfo);
      // infoStrings.add(info);
      // });
    }));
  }

  void listentoFirebaseTrigger(BuildContext context) {
    referenceFirebase.snapshots().listen((result) {
      result.docChanges.forEach((res) async {
        if (res.type == DocumentChangeType.modified) {
          FirebaseFirestore.instance
              .collection("agoravideo")
              .doc("HKrnpcjvL7OvMYK3kIvZ")
              .get()
              .then((value) {
            switchState = value.data()["videocall"];
            audio = value.data()["audio"];
            video = value.data()["video"];
            videoRequestStatus = value.data()["videorequest"];
            callStatusAgora = value.data()["callstatus"];
            if (!switchState) {
              print("ended" + callStatusAgora);
              if (callStatusAgora == "ended") {
                print("ended" + "call");
                Navigator.pop(context);
              }
              // setState(() {
              if (audio) {
                setupVideoStatusProvider(context, false);
                setupAudioStatusProvider(context, true);
                videoEnable = false;
                audioCall = true;
              }
              if (video) {
                if (!localUser) {
                  if (!videoRequPopShow) {
                    showVideoIncomingDialogue(context);
                  }
                }
                if (videoRequestStatus
                    .trim()
                    .toLowerCase()
                    .contains("accepted")) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  if (localUser) {
                    showSnackBar("User accepted the video call", context);
                  }
                  localUser = false;
                  videoRequPopShow = false;
                  audioCall = false;
                  videoEnable = true;
                  setupVideoStatusProvider(context, true);
                  setupAudioStatusProvider(context, false);
                } else if (videoRequestStatus
                    .trim()
                    .toLowerCase()
                    .contains("rejected")) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  showSnackBar("User declined the video call", context);
                  videoEnable = false;
                  audioCall = true;
                  setupVideoStatusProvider(context, true);
                  setupAudioStatusProvider(context, false);
                }
              }

              // });
            }
          });
        }
      });
    });
  }

  Future<void> showVideoIncomingDialogue(BuildContext context) async {
    videoRequPopShow = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Requesting for Video Call'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Would you like to accpet the video call request?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Accept'),
              onPressed: () async {
                Navigator.of(context).pop();
                trigerVideoRequest("accepted");
              },
            ),
            TextButton(
              child: const Text('Decline'),
              onPressed: () async {
                localUser = false;
                videoRequPopShow = false;
                trigerVideoRequest("rejected");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  showSnackBar(String contents, BuildContext context) {
    // TODO: implement showSnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(contents),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          // Some code to undo the change.
        },
      ),
    ));
  }

  @override
  startTimmer(BuildContext context) {
    // TODO: implement startTimmer
    timerStarted = true;
    var oneSec = Duration(seconds: 1);
    _timmerInstance =
        Timer.periodic(oneSec, (Timer timer) => updateTimer(_start, context));
  }

  updateTimer(int start, BuildContext context) {
    if (_start < 0) {
      _timmerInstance.cancel();
    } else {
      _start = _start + 1;
      timmer = getTimerTime(_start);
      setupCallingTimer(context, timmer);
    }
  }

  @override
  switchAudioVideo() {
    // TODO: implement switchAudioVideo
    videoRequPopShow = false;
    localUser = false;

    trigerAudioVideoSwitch(true, true, false, "progress");
  }

  void trigerAudioVideoSwitch(
      bool audioSwitch, bool audio, bool video, String callStatus) {
    FirebaseFirestore.instance
        .collection("agoravideo")
        .doc("HKrnpcjvL7OvMYK3kIvZ")
        .update({
      "videocall": false,
      "audio": audio,
      "video": video,
      "callstatus": callStatus,
      "videorequest": ""
    }).then((_) {
      print("audioTrigered!");
    });
  }

  @override
  trigerVideoRequest(String status) {
    // TODO: implement trigerVideoRequest
    FirebaseFirestore.instance
        .collection("agoravideo")
        .doc("HKrnpcjvL7OvMYK3kIvZ")
        .update({
      "videocall": false,
      "videorequest": status,
    }).then((_) {
      print("audioTrigered!");
    });
  }

  @override
  bool getAudioStatus() {
    // TODO: implement getAudioStatus
    return audioCallStatus;
  }

  @override
  bool getVideoStatus() {
    // TODO: implement getVideoStatus
    return videoCallStatus;
  }

  @override
  setupAudioCall(bool audioStatus) {
    // TODO: implement setupAudioCall
    audioCallStatus = audioStatus;
    notifyListeners();
  }

  @override
  setupVideoStatus(bool videoStatus) {
    // TODO: implement setupVideoStatus
    videoCallStatus = videoStatus;
    notifyListeners();
  }

  @override
  List<String> getAgoraVideoInfo() {
    // TODO: implement getAgoraVideoInfo
    return infoStrings;
  }

  @override
  setupAgoraVideoInfo(List<String> videoInfo) {
    // TODO: implement setupAgoraVideoInfo
    infoStrings = videoInfo;
    notifyListeners();
  }

  @override
  String getCallTimerValue() {
    // TODO: implement getCallTimerValue
    return timerValue;
  }

  @override
  setupCallTimer(String timerValues) {
    // TODO: implement setupCallTimer
    timerValue = timerValues;
    notifyListeners();
  }

  @override
  bool getMuteStatus() {
    // TODO: implement getMuteStatus
    return muteStatus;
  }

  @override
  setupMuteStatus(bool mutestatus) {
    // TODO: implement setupMuteStatus
    muteStatus = mutestatus;
    notifyListeners();
  }
}
