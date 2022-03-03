import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connie/src/models/agora_response.dart';
import 'package:connie/src/utils/commonVal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// non-modifiable client role of the page
  final ClientRole role;

  /// Creates a call page with given channel name.
  const CallPage({Key key, this.channelName, this.role}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool mutedAudio = false;

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

  Timer _timmerInstance;
  int _start = 0;
  String _timmer = '';
  bool timerStarted = false;

  void startTimmer() {
    timerStarted = true;
    var oneSec = Duration(seconds: 1);
    _timmerInstance = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start < 0) {
                _timmerInstance.cancel();
              } else {
                _start = _start + 1;
                _timmer = getTimerTime(_start);
              }
            }));
  }

  String getTimerTime(int start) {
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
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    referenceFirebase = FirebaseFirestore.instance.collection('agoravideo');
    listentoFirebaseTrigger();

    // initialize agora sdk
    getAgoraAccessToken();
  }

  Future<void> getAgoraAccessToken() async {
    final response = await https.get(Uri.parse(
        "https://connie-app-helper.dev.conigitalcloud.io/agoraToken?channel=firstchannel"));
    if (response.statusCode == 200) {
      AgoraResponse agoraResponse =
          AgoraResponse.fromJson(jsonDecode(response.body));
      print("agoraToken" + agoraResponse.token);
      initialize(agoraResponse.token);
    }
  }

  Future<void> initialize(String accessToken) async {
    if (ConstantVal().agoraAppId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });

      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableVideo();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(500, 500);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(accessToken, widget.channelName, null, 0);
  }

  switchAudioVideo() async {
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

  void trigerVideoRequest(String callStatus) {
    FirebaseFirestore.instance
        .collection("agoravideo")
        .doc("HKrnpcjvL7OvMYK3kIvZ")
        .update({
      "videocall": false,
      "videorequest": callStatus,
    }).then((_) {
      print("audioTrigered!");
    });
  }

  void _showSnackBar(String contents) {
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

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(ConstantVal().agoraAppId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        if (!timerStarted) {
          startTimmer();
          setState(() {
            if (!audioCall) {
              audioCall = true;
            } else {
              videoEnable = true;
              final info = 'onJoinChannel: $channel, uid: $uid';
              _infoStrings.add(info);
            }
          });
        }
        // userJoined = true;
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onToggleMute(false),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => switchAudioVideo(),
            child: Icon(
              Icons.videocam_off,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Text(
                    "null"); // return type can't be null, a widget was required
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    videoRequPopShow = false;
    localUser = false;
    trigerAudioVideoSwitch(false, false, false, "ended");
    // Navigator.pop(context);
  }

  void _onToggleMute(bool audio) {
    setState(() {
      if (!audio) {
        muted = !muted;
        _engine.muteLocalAudioStream(muted);
      } else {
        mutedAudio = !mutedAudio;
        _engine.muteLocalAudioStream(mutedAudio);
      }
    });
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('Connie Video Call',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            if (audioCall) audioCallWidget(),
            if (videoEnable) _viewRows(),
            if (videoEnable) _panel(),
            if (videoEnable) _toolbar(),
          ],
        ),
      ),
    );
  }

  void listentoFirebaseTrigger() {
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
              setState(() {
                if (audio) {
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
                      _showSnackBar("User accepted the video call");
                    }
                    localUser = false;
                    videoRequPopShow = false;
                    audioCall = false;
                    videoEnable = true;
                  } else if (videoRequestStatus
                      .trim()
                      .toLowerCase()
                      .contains("rejected")) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    _showSnackBar("User declined the video call");
                    videoEnable = false;
                    audioCall = true;
                  }
                }
              });
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

  Widget audioCallWidget() {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              'VOICE CALL',
              style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.w300,
                  fontSize: 15),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Connie' + " " + "Sanjeev",
              style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              _timmer,
              style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.w300,
                  fontSize: 15),
            ),
            SizedBox(
              height: 20.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.network(
                'https://img.icons8.com/color/48/000000/person-male.png',
                height: 100.0,
                width: 100.0,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FunctionalButton(
                  title: 'Speaker',
                  icon: Icons.phone_in_talk,
                  onPressed: () {},
                ),
                FunctionalButton(
                  title: 'Video Call',
                  icon: Icons.videocam,
                  onPressed: () {
                    localUser = true;
                    _showSnackBar("Requesting for video call");
                    trigerAudioVideoSwitch(true, false, true, "progress");
                    // setState(() {
                    //   audioCall = false;
                    //   videoEnable = true;
                    //
                    // });
                  },
                ),
                // FunctionalButton(
                //   title: 'Mute',
                //   icon: Icons.mic_off,
                //   onPressed: () {
                //     _onToggleMute(true);
                //   },
                // ),

                RawMaterialButton(
                  onPressed: () => _onToggleMute(true),
                  child: Icon(
                    mutedAudio ? Icons.mic_off : Icons.mic,
                    color: mutedAudio ? Colors.white : Colors.blueAccent,
                    size: 30.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 10.0,
                  fillColor: mutedAudio ? Colors.blueAccent : Colors.white,
                  padding: const EdgeInsets.all(15.0),
                ),
              ],
            ),
            SizedBox(
              height: 80.0,
            ),
            FloatingActionButton(
              onPressed: () => _onCallEnd(context),

              // onPressed: () {
              //   _onCallEnd(context);
              // },
              elevation: 20.0,
              shape: CircleBorder(side: BorderSide(color: Colors.red)),
              mini: false,
              child: Icon(
                Icons.call_end,
                color: Colors.red,
              ),
              backgroundColor: Colors.red[100],
            )
          ],
        ),
      ),
    );
  }
}

class FunctionalButton extends StatefulWidget {
  final title;
  final icon;
  final Function() onPressed;

  const FunctionalButton({Key key, this.title, this.icon, this.onPressed})
      : super(key: key);

  @override
  _FunctionalButtonState createState() => _FunctionalButtonState();
}

class _FunctionalButtonState extends State<FunctionalButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RawMaterialButton(
          onPressed: widget.onPressed,
          splashColor: Colors.deepPurpleAccent,
          fillColor: Colors.white,
          elevation: 10.0,
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              widget.icon,
              size: 30.0,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 15.0, color: Colors.deepPurpleAccent),
          ),
        )
      ],
    );
  }
}
