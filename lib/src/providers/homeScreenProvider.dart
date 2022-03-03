import 'dart:async';
import 'dart:math';
import 'package:android_intent/android_intent.dart';
import 'package:connie/src/providers/youtubeInfoProvider.dart';
import 'package:connie/src/ui/custom/web_screen.dart';
import 'package:connie/src/ui/qrscan/qr_generator.dart';
import 'package:connie/src/ui/qrscan/qr_scan_code.dart';
import 'package:http/http.dart' as https;
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connie/src/abstract/cms_query_impl.dart';
import 'package:connie/src/abstract/homeScreenAbstract.dart';
import 'package:connie/src/providers/controlButtonsProvider.dart';
import 'package:connie/src/providers/speakingUiInfoProvider.dart';
import 'package:connie/src/ui/calling.dart';
import 'package:connie/src/ui/videocall.dart';
import 'package:connie/src/utils/AppPref.dart';
import 'package:connie/src/utils/PrefModel.dart';
import 'package:connie/src/utils/PushNotificationsManager.dart';
import 'package:connie/src/utils/commonVal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/sound_profiles.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'charmBarInfoProvider.dart';
import 'package:connie/src/models/cms_model.dart' as cms;

class HomeScreenProvider extends HomeScreenAbstract {
  CollectionReference referenceFirebase;
  bool isInfoPressed = false;
  double widthSize;
  bool mapEnable = false;
  bool ttsStarted = false;
  bool callingTwilio = false;
  bool stopConnie = false;
  bool resultCameFromTTS = false;
  bool connieActivated = false;
  bool musicisPlaying = false;
  RtcEngine _engine;
  bool videoPopShow = false;
  String callFrom;

  String callStatus;
  String callTo;
  bool musicPlaying = false;
  bool changeMusic = false;
  String notitmsg;

  var volume = 0.8;
  BuildContext globalContext;
  List<cms.CMSModel> cmsModelObject = [];

  //STT
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  final SpeechToText speech = SpeechToText();
  int maxVol = 0, currentVol = 0;

  //TTS
  FlutterTts flutterTts;
  dynamic languages;
  String language = ConstantVal().londonLang;
  double pitch = 0.9;
  double rate = 0.6;
  bool detected = false;

  String _newVoiceText;
  String youTubeID;
  bool isVideoLive = false;
  bool toPlayVideo = false;

  TtsState ttsState = TtsState.stopped;
  Response response;
  String responseTextToDisplay = "";
  bool fetechingResults = false;

  Map<dynamic, dynamic> ansValues;
  bool localVideoStream = false;
  bool googleCustomSerach = false;

  List callToo;

  CharmBarInfoProvider charmBarInfoProvider;
  YoutubePlayerController _controller;
  Timer mytimer;
  var uuid;
  var blocNativeBrdige = CMSQueryImpl();
  bool videoCallStatus = false;
  String remoteorLocal;
  String localUser = "supervisor";
  bool coffee = false;
  bool foodDrink = false;
  bool pubcafe = false;
  PrefModel prefModel;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  callAccessTokenAPI(
      String registerTwilio, String callTo, BuildContext context) async {
    // TODO: implement callAccessTokenAPI
    final response = await https.get(Uri.parse(
        "https://connie-app-helper.dev.conigitalcloud.io/accessToken?identity=avinash"));
    if (response.statusCode == 200) {
      print("callAccessTokenAPI" + response.body.toString());
      if (registerTwilio != null &&
          registerTwilio.toLowerCase().contains(ConstantVal().rigisterTwilio)) {
        callNativeForCall(ConstantVal().rigisterTwilio,
            response.body.toString(), callTo, context);
      } else {
        callNativeForCall(ConstantVal().callTwilio, response.body.toString(),
            callTo, context);
      }
      //display UI}
    } else {
      //Show Error Message
    }
  }

  @override
  callMapScreen(BuildContext context) {
    // TODO: implement callMapScreen
    setupMapButton(true, context);
  }

  @override
  callNativeForCall(String callStatus, String accesstoken, String callTo,
      BuildContext context) {
    // TODO: implement callNativeForCall
    blocNativeBrdige
        .cmsQuery(false, callStatus, accesstoken, callTo)
        .then((value) async {
      print("callStatusflutter" + value);
      if (value.toLowerCase().contains(ConstantVal().ringingCall)) {
        Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              Calling(text: callTo[2]),
        ));
      } else if (value.toLowerCase().contains(ConstantVal().callConnected)) {
        videoCallScreen(context, false);
        // openCallScreen(context);
      }
    });
  }

  @override
  void callNativeTts(bool nativeTTS, String startOrStop, BuildContext context) {
    // TODO: implement callNativeTts
    blocNativeBrdige
        .cmsQuery(nativeTTS, startOrStop, "", "")
        .then((value) async {
      print("connieNotify" + value);

      if (value.toLowerCase().toString().contains(ConstantVal().welcometext)) {
        if (notitmsg != null) {
          speakOut(notitmsg, context);
        } else {
          speakOut(ConstantVal().connieWelcomeMes, context);
        }
        return;
      } else if (value.toLowerCase().toString().contains("firebase")) {
        var notificationContentsBody = value.split("firebase");
        speakOut(notificationContentsBody[1], context);
        return;
      } else if (value.toLowerCase().toString().contains("notify")) {
        var notificationContents = value.split("..");
        print("notificationContents" + notificationContents.toString());
        PushNotificationsManager.displayNotificationConnie(
            notificationContents[1].trim(), notificationContents[2]);
        speakOut(notificationContents[2], context);
      } else if (value
          .toLowerCase()
          .toString()
          .contains(ConstantVal().connieActive)) {
        chagePhoneSoundModestoSilent();
        connieActivated = true;
        speakOut(ConstantVal().assistConnie, context);
      } else if (value
          .toLowerCase()
          .toString()
          .contains(ConstantVal().musicisplaying)) {
        callNativeTts(true, "", context);
        setupMicButton(true, context);
        setupMusicPlayingStatus(true, context);
        setupSpeakText(ConstantVal().musicDetails, context);
        setupSpeakingStatus(true, context);
      } else if (value
          .toLowerCase()
          .toString()
          .contains(ConstantVal().musicstopped)) {
        callNativeTts(true, "", context);
        setupMicButton(true, context);
        setupMusicPlayingStatus(false, context);
        setupSpeakText("", context);
        setupSpeakingStatus(false, context);
      } else if (value
          .toLowerCase()
          .toString()
          .contains(ConstantVal().callConnected)) {
        setupMicButton(false, context);
        setupSpeakingStatus(false, context);
        setupSpeakText("", context);
        videoCallScreen(context, false);
        return;
      } else {
        resultCameFromTTS = true;

        chagePhoneSoundModestoSilent();
        print("callStatusflutter 123" + value);

        speak(value, true, context);
      }
    });
  }

  @override
  callStatusTrigger(String callStatus, bool progressStatus) {
    // TODO: implement callStatusTrigger
    FirebaseFirestore.instance
        .collection("agoravideo")
        .doc("HKrnpcjvL7OvMYK3kIvZ")
        .update({
      "callstatus": callStatus,
      "callprogress": progressStatus
    }).then((_) {
      print("Addedsuccess!");
    });

    print("firestoreadded   value");
  }

  @override
  callingInProgress(BuildContext context) {
    // TODO: implement callingInProgress
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          Calling(text: "sanjeev"),
    ));
  }

  @override
  cancelListening() {
    // TODO: implement cancelListening
    speech.cancel();
    level = 0.0;
  }

  @override
  chagePhoneSoundModestoNormal() async {
    // TODO: implement chagePhoneSoundModestoNormal
    try {
      await SoundMode.setSoundMode(Profiles.NORMAL);
    } on PlatformException {
      print('Please enable permissions required');
    }
  }

  @override
  chagePhoneSoundModestoSilent() async {
    // TODO: implement chagePhoneSoundModestoSilent
    try {
      await SoundMode.setSoundMode(Profiles.SILENT);
    } on PlatformException {
      print('Please enable permissions required');
    }
  }

  @override
  customSearchWelform(String query) async {
    // TODO: implement customSearchWelform
    Dio dio = new Dio();
    try {
      response = await dio.get(
          "https://api.wolframalpha.com/v1/result?appid=LXUL2L-8R8HKG3RPK&i=$query");
      print("customerREsponseCode" + response.statusCode.toString());

      if (response.statusCode == 200) {
        return response.data; //customSearch.items[0].snippet;
      } else {
        return "Sorry, No results found";
      }
    } on Exception catch (_) {
      print("customerREsponseCode" + "excepetionnn");

      return "Sorry, No results found";
    }
  }

  @override
  eCommerceProductSite(String productName, BuildContext context) {
    // TODO: implement eCommerceProductSite
    ttsStarted = true;
    callNativeTts(true, "", context);
    setupMicButton(true, context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WebScreen(
                query: productName,
              )),
    );
  }

  @override
  fetchCMS(BuildContext context) async {
    // TODO: implement fetchCMS
    List jsonString = await charmBarInfoProvider.cmsCommands(context);
    if (jsonString.length > 0) {
      for (var command in jsonString) {
        cmsModelObject.add(cms.CMSModel.fromJson(command));
      }
    }
  }

  @override
  getPermissionStatus() async {
    // TODO: implement getPermissionStatus
    bool isGranted = await PermissionHandler.permissionsGranted;
    if (!isGranted) {
      // Opens the Do Not Disturb Access settings to grant the access
      await PermissionHandler.openDoNotDisturbSetting();
    }
  }

  @override
  getResponseFromFireBaseData(String qns) {
    // TODO: implement getResponseFromFireBaseData
    String response;
    if (qns.length > 3 && qns.substring(0, 3) == "buy") {
      qns = "buy";
    }
    response = ansValues[qns];
    if (response == null) {
      response = "search";
    }
    return response;
  }

  @override
  initVales(BuildContext context) {
    // TODO: implement initVales
    PrefModel prefModel = AppPref.getPref();
    notitmsg = prefModel.notificationMsg;
    print("notitficationmsg" + notitmsg);
    uuid = Uuid();
    charmBarInfoProvider = Provider.of<CharmBarInfoProvider>(context);
    // WidgetsBinding.instance.addObserver(widget(child: this));
    charmBarInfoProvider.getLocation();
    setupVolume();
    initTts(context);
    fetchCMS(context);
    callNativeTts(false, "", context);
  }

  @override
  intializeVideoListners(BuildContext context) {
    referenceFirebase = FirebaseFirestore.instance.collection('agoravideo');

    // TODO: implement intializeVideoListners
    referenceFirebase.snapshots().listen((result) {
      result.docChanges.forEach((res) async {
        if (res.type == DocumentChangeType.modified) {
          FirebaseFirestore.instance
              .collection("agoravideo")
              .doc("HKrnpcjvL7OvMYK3kIvZ")
              .get()
              .then((value) {
            videoCallStatus = value.data()["videocall"];
            remoteorLocal = value.data()["callfrom"];
            callTo = value.data()["client"];

            print("fixtheissue" + videoCallStatus.toString());
            print("fixtheissue" + remoteorLocal.toString());
            print("fixtheissue" + localVideoStream.toString());
            if (videoCallStatus) {
              if (!localVideoStream) {
                if (!videoPopShow) {
                  if (remoteorLocal == "local") {
                    // if (callTo == "supervisor" && localUser == "supervisor") {
                    chagePhoneSoundModestoNormal();
                    FlutterRingtonePlayer.playRingtone();
                    showVideoIncomingDialogue(context);
                    // }
                    // } else {
                    //   chagePhoneSoundModestoNormal();
                    //   FlutterRingtonePlayer.playRingtone();
                    //   showVideoIncomingDialogue(context);
                    // }
                  }
                }
              } else {
                // result.docs[0].data()["callfrom"];
                FirebaseFirestore.instance
                    .collection("agoravideo")
                    .doc("HKrnpcjvL7OvMYK3kIvZ")
                    .get()
                    .then((value) {
                  callFrom = value.data()["callfrom"];
                  callStatus = value.data()["callstatus"];
                  callTo = value.data()["client"];
                  print("callAccpeted" + callFrom.toString());
                  print("callAccpeted" + callStatus);
                  if (callFrom == "remote") {
                    print("callAccpeted" + "twwoo");
                    if (callStatus == "accepted") {
                      trigerVideoCalltoOtherClient("", "", false, false, "");
                      print("callAccpeted" + "oneee");
                      Navigator.pop(context);
                      videoCallScreen(context, false);
                    } else if (callFrom == "remote") {
                      if (callStatus == "rejected") {
                        trigerVideoCalltoOtherClient("", "", false, false, "");
                        Navigator.pop(context);
                      }
                    }
                  }
                });
              }
            }
          });
        }
      });
    });
  }

  @override
  Future<void> openDoNotDisturbSettings() async {
    // TODO: implement openDoNotDisturbSettings
    await PermissionHandler.openDoNotDisturbSetting();
  }

  @override
  openNativeConApp() async {
    // TODO: implement openNativeConApp
    String deeplink =
        "conapp://riseyourskill.in/action?pickuplatitude=50.8955&pickuplongitude=-1.3929&pickupname=Southampton Harbour Hotel&dropofflatitude=50.950162866&dropofflongitude=-1.353998584&dropoffnickname=Southampton Airport";
    AndroidIntent intent = AndroidIntent(action: 'action_view', data: deeplink);
    await intent.launch();
  }

  @override
  setupMapButton(bool status, BuildContext context) {
    // TODO: implement setupMapButton
    Provider.of<ControlButtonsProvider>(context, listen: false)
        .setMapButtonPressStatus(status);
  }

  @override
  setupMicButton(bool status, BuildContext context) {
    // TODO: implement setupMicButton
    Provider.of<ControlButtonsProvider>(context, listen: false)
        .setMicButtonPressStatus(status);
  }

  @override
  setupSpeakingStatus(bool status, BuildContext context) {
    // TODO: implement setupSpeakingStatus
    Provider.of<SpeakingUiInfoProvider>(context, listen: false)
        .setSpeakingStatus(status);
  }

  @override
  setupTypeButton(bool status, BuildContext context) {
    // TODO: implement setupTypeButton
    Provider.of<ControlButtonsProvider>(context, listen: false)
        .setTypeButtonPressStatus(status);
  }

  @override
  setupVolume() {
    // TODO: implement setupVolume
    getPermissionStatus();
  }

  @override
  showVideoIncomingDialogue(BuildContext context) {
    // TODO: implement showVideoIncomingDialogue
    trigerVideoCalltoOtherClient("", "", false, false, "");
    videoPopShow = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incoming Video Call'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Sanjeev is calling you'),
                Text('Would you like to accpet the call?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Accept'),
              onPressed: () async {
                localVideoStream = false;
                trigerVideoCalltoOtherClient(
                    "remote", "accepted", true, true, "");

                // callStatusTrigger("accepted",true);
                FlutterRingtonePlayer.stop();
                chagePhoneSoundModestoSilent();
                videoPopShow = false;
                Navigator.pop(context);
                videoCallScreen(context, false);
              },
            ),
            TextButton(
              child: const Text('Decline'),
              onPressed: () async {
                localVideoStream = false;
                // callStatusTrigger("rejected",false);
                trigerVideoCalltoOtherClient(
                    "remote", "rejected", false, false, "");

                FlutterRingtonePlayer.stop();
                chagePhoneSoundModestoSilent();
                videoPopShow = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  soundLevelListener(double level) {
    // TODO: implement soundLevelListener
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    this.level = level;
  }

  @override
  speakOut(String speakValue, BuildContext context) async {
    // TODO: implement speakOut
    var result = await flutterTts.speak(speakValue);
    if (result == 1) {
      setupSpeakingStatus(true, context);
      setupSpeakText(speakValue, context);
      setupMicButton(true, context);
      ttsState = TtsState.playing;
    }
    flutterTts.setLanguage(ConstantVal().londonLang);
  }

  // @override
  // startTimer() {
  //   // TODO: implement startTimer
  //   Timer(Duration(seconds: 10), () {
  //     if(!detected)
  //       setupFetchingStatus(false, globalContext);
  //     speakOut("please try again");
  //     return;
  //   });
  // }

  @override
  statusListener(String status) {
    // TODO: implement statusListener
    lastStatus = "$status";
  }

  @override
  stopListening(BuildContext context) {
    // TODO: implement stopListening
    speech.stop();
    setupMapButton(false, context);
    setupMicButton(false, context);
  }

  @override
  trigerAudioVideoSwitch(
      bool audioSwitch, bool audio, bool video, String callStatus) {
    // TODO: implement trigerAudioVideoSwitch
    FirebaseFirestore.instance
        .collection("agoravideo")
        .doc("HKrnpcjvL7OvMYK3kIvZ")
        .update({
      "videocall": false,
      "audio": audio,
      "video": video,
      "callstatus": callStatus
    }).then((_) {
      print("audioTrigered!");
    });
  }

  @override
  trigerVideoCalltoOtherClient(String callFrom, String CallStatus,
      bool callProgress, bool videoCall, String callTo) {
    // TODO: implement trigerVideoCalltoOtherClient
    FirebaseFirestore.instance
        .collection("agoravideo")
        .doc("HKrnpcjvL7OvMYK3kIvZ")
        .update({
      "videoid": uuid.v4().toString(),
      "callfrom": callFrom,
      "callstatus": CallStatus,
      "callprogress": callProgress,
      "videocall": videoCall,
      "client": callTo
    }).then((_) {
      print("Addedsuccess!");
    });

    print("firestoreadded   value");
  }

  @override
  videoCallScreen(BuildContext context, bool videoStream) async {
    // TODO: implement videoCallScreen
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: ConstantVal().firstchannel,
          role: ClientRole.Broadcaster,
        ),
      ),
    ).then((value) async {
      localVideoStream = false;
    });
  }

  @override
  initTts(BuildContext context) {
    // TODO: implement initTts
    flutterTts = FlutterTts();
    flutterTts.setLanguage(language);
    getLanguages();

    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() async {
      if (!stopConnie) {
        if (!ConstantVal.isTypePressed) {
          ttsStarted = true;
          ttsState = TtsState.stopped;
          setupMicButton(true, context);
          setupSpeakingStatus(false, context);
          String ringerStatus = await SoundMode.ringerModeStatus;
          print("ringerStatus" + ringerStatus);
          chagePhoneSoundModestoSilent();

          callNativeTts(true, "", context);
          // restartTTS();
        } else {
          setupSpeakingStatus(false, context);

          ttsState = TtsState.stopped;
          setupMicButton(false, context);
          // });
        }
      } else {
        stopConnie = false;
        setupSpeakingStatus(false, context);

        ttsState = TtsState.stopped;
        setupMicButton(false, context);
      }

      stop();
    });

    flutterTts.setCancelHandler(() {
      ttsState = TtsState.stopped;
      stopListening(context);
    });

    flutterTts.setErrorHandler((msg) {
      ttsState = TtsState.stopped;
    });
  }

  @override
  getLanguages() async {
    // TODO: implement getLanguages
    languages = await flutterTts.getLanguages;
    if (languages != null) languages;
  }

  @override
  onSearchButtonPressed(BuildContext context) {
    // TODO: implement onSearchButtonPressed
    ttsStarted = true;
    setupYoutubePlayerPlayingStatus(false, context);
    setupMicButton(true, context);
  }

  @override
  speak(String command, bool sTTFlag, BuildContext context) {
    // TODO: implement speak
    print("callStatusflutter pubcafe" + command);

    if (toPlayVideo) {
      onSearchButtonPressed(context);
    }

    if (ConstantVal.isTypePressed) {
      ConstantVal.isMicPressed = false;
    } else {
      ConstantVal.isMicPressed = true;
    }

    if (command.toLowerCase().contains("food")) {
      foodDrink = true;
      speakOut("Would you like some food or a drink?", context);
      return;
    } else if (command.toLowerCase().contains("no")) {
      if (foodDrink) {
        speakOut("Let me know if you need anything else", context);
        return;
      }
    } else if (command
        .toLowerCase()
        .contains("i would like to buy some coffee")) {
      eCommerceProductSite("coffee", context);
      return;
    } else if (command.toLowerCase().contains("pub")) {
      if (pubcafe) {
        eCommerceProductSite("pub", context);
        return;
      }
    } else if (command.toLowerCase().contains("cafe")) {
      if (pubcafe) {
        eCommerceProductSite("cafe", context);
        return;
      }
    } else if (command.toLowerCase().contains("yes")) {
      if (foodDrink) {
        pubcafe = true;
        speakOut("would you like to eat at a pub or cafe", context);
        return;
      }
    } else if (command.toLowerCase().contains(ConstantVal().sunglasses)) {
      eCommerceProductSite(ConstantVal().sunglasses, context);
      return;
    } else if (command.toLowerCase().contains(ConstantVal().suitcase)) {
      eCommerceProductSite(ConstantVal().suitcase, context);
      return;
    } else if (command.toLowerCase().contains(ConstantVal().perfume)) {
      eCommerceProductSite(ConstantVal().perfume, context);
      return;
    } else if (command.toLowerCase().contains(ConstantVal().shorts)) {
      eCommerceProductSite(ConstantVal().shorts, context);
      return;
    } else if (command.toLowerCase().contains("end call")) {
      trigerAudioVideoSwitch(false, false, false, "ended");
    } else if (command.toLowerCase().contains("group call")) {
      videoCallScreen(context, false);
      return;
    } else if (command.toLowerCase().contains(ConstantVal().videoCall) ||
        command.toLowerCase().contains(ConstantVal().videoChannelName)) {
      ttsStarted = true;
      callNativeTts(true, "", context);
      setupMicButton(true, context);
      localVideoStream = true;
      trigerVideoCalltoOtherClient("local", "calling", false, true, "");
      callingInProgress(context);
      // videoCallScreen(context,true);
      return;
    } else if (command.toLowerCase().contains(ConstantVal().whoareyou) ||
        command.toLowerCase().contains(ConstantVal().whatareyou)) {
      ConstantVal.isSpeaking = true;
      String speakText = ConstantVal().connieDiscrip;
      speakOut(speakText, context);
    } else if (command.toLowerCase().contains(ConstantVal().hidemap) ||
        command.toLowerCase().contains(ConstantVal().closemap)) {
      setupMicButton(false, context);
      setupMapButton(false, context);
      return;
    } else if (command.toLowerCase().contains(ConstantVal().saythanks)) {
      stopConnie = true;
      ConstantVal.isSpeaking = true;
      speakOut(ConstantVal().niceday, context);
    } else if (command.toLowerCase().contains(ConstantVal().goback) ||
        command.toLowerCase().contains(ConstantVal().back)) {
      callNativeTts(true, "", context);
      setupMicButton(true, context);
      callingTwilio = true;
      Navigator.pop(context);
    } else if (command.toLowerCase().contains(ConstantVal().shutdown) ||
        command.toLowerCase().contains(ConstantVal().shutdownOne)) {
      //I like to buy sunglasses
      callingTwilio = true;
      callNativeTts(false, ConstantVal().stop, context);
      ConstantVal.isMicPressed = false;
      stopListening(context);
    } else if (command.toLowerCase().contains(ConstantVal().bye) ||
        command.toLowerCase().contains(ConstantVal().goodbye)) {
      callNativeTts(false, ConstantVal().stop, context);
      speak(ConstantVal().saythanks, true, context);
      return;
    } else if (command.toLowerCase().contains(ConstantVal().journey) ||
        command.toLowerCase().contains(ConstantVal().Stockport) ||
        command.toLowerCase().contains(ConstantVal().Manchester)) {
      //I like to buy sunglasses
      callingTwilio = true;
      openNativeConApp();
    } else if (command.toLowerCase().contains(ConstantVal().videobbc) ||
        command.toLowerCase().contains(ConstantVal().bbcNews)) {
      callingTwilio = true;
      setupYoutubeId(ConstantVal().bbcNewsYoutubeId, context);
      setupMicButton(false, context);
      setupYoutubePlayerPlayingStatus(true, context);
      setupYoutubrPlayerLiveVideoStatus(false, context);
      return;
    } else if (command.toLowerCase().contains("play music")) {
      print("callStatusflutter playmusic" + command);

      musicPlaying = true;
      callingTwilio = true;
      setupYoutubeId("3T1c7GkzRQQ", context);
      setupMicButton(false, context);
      setupYoutubePlayerPlayingStatus(true, context);
      setupYoutubrPlayerLiveVideoStatus(false, context);
      return;
    } else if (command.toLowerCase().contains("change music")) {
      if (musicPlaying) {
        print("callStatusflutter changeMusic" + command);
        _controller.close();

        changeMusic = true;
        callingTwilio = true;
        setupYoutubeId("ywZqBGHDTlA", context);
        setupMicButton(false, context);
        setupYoutubePlayerPlayingStatus(true, context);
        setupYoutubrPlayerLiveVideoStatus(false, context);
        _controller.play();
        return;
      }
    } else if (command.toLowerCase().contains("change music")) {
      if (musicPlaying && changeMusic) {
        _controller.close();
        changeMusic = false;
        musicPlaying = false;
        callingTwilio = true;
        setupYoutubeId("HgzGwKwLmgM", context);
        setupMicButton(false, context);
        setupYoutubePlayerPlayingStatus(true, context);
        setupYoutubrPlayerLiveVideoStatus(false, context);
        _controller.play();
        return;
      }
    } else if (command.toLowerCase().contains(ConstantVal().skyNewsVideo) ||
        command.toLowerCase().contains(ConstantVal().skyNews)) {
      callingTwilio = true;
      setupMicButton(false, context);
      setupYoutubePlayerPlayingStatus(true, context);
      setupYoutubrPlayerLiveVideoStatus(false, context);
      setupYoutubeId(ConstantVal().skyNewsYoutubeId, context);
      return;
    } else if (command.toLowerCase().contains(ConstantVal().armstrongVideo) ||
        command.toLowerCase().contains(ConstantVal().louisarmstrong)) {
      callingTwilio = true;
      setupMicButton(false, context);
      setupYoutubePlayerPlayingStatus(true, context);
      setupYoutubrPlayerLiveVideoStatus(false, context);
      setupYoutubeId(ConstantVal().armstrongYoutubeId, context);
      return;
    } else if (command.toLowerCase().contains(ConstantVal().autonomousVideo) ||
        command.toLowerCase().contains(ConstantVal().autonomous) ||
        command.toLowerCase().contains(ConstantVal().autonomousVehicle)) {
      callingTwilio = true;
      setupMicButton(false, context);
      setupYoutubePlayerPlayingStatus(true, context);
      setupYoutubrPlayerLiveVideoStatus(false, context);
      setupYoutubeId(ConstantVal().autonomousYoutubeId, context);
    } else if (command.toLowerCase().contains(ConstantVal().favoriteConnie) ||
        command.toLowerCase().contains(ConstantVal().favoriteConnieOne) ||
        command.toLowerCase().contains(ConstantVal().favoriteConnieTwo) ||
        command.toLowerCase().contains(ConstantVal().favoriteConnieThree) ||
        command.toLowerCase().contains(ConstantVal().favoriteConnieFour)) {
      callingTwilio = true;
      setupMicButton(false, context);
      setupYoutubePlayerPlayingStatus(true, context);
      setupYoutubrPlayerLiveVideoStatus(false, context);
      setupYoutubeId(ConstantVal().connieFevYoutubeId, context);
    } else if (command.toLowerCase().contains(ConstantVal().map) ||
        command.toLowerCase().contains(ConstantVal().openmap)) {
      callingTwilio = true;
      callMapScreen(context);
    } else if (command.toLowerCase().contains(ConstantVal().call) ||
        command.toLowerCase().contains(ConstantVal().callsupervisor) ||
        command.toLowerCase().contains(ConstantVal().calltab) ||
        command.toLowerCase().contains(ConstantVal().calldevice)) {
      setupMicButton(false, context);
      setupMapButton(false, context);
      callingTwilio = true;
      callAccessTokenAPI(
          ConstantVal().callTwilio, command.toLowerCase().toString(), context);
      return;
    } else if (command.toLowerCase().contains(ConstantVal().closeTabs) ||
        command.toLowerCase().contains(ConstantVal().close)) {
      toPlayVideo = false;
      setupYoutubePlayerPlayingStatus(false, context);
      if (command.toLowerCase().contains(ConstantVal().closeVideo) ||
          command.toLowerCase().contains(ConstantVal().closevideoOne)) {
        ConstantVal.isMicPressed = true;
      } else {
        ConstantVal.isMicPressed = false;
      }
      // });
      callingTwilio = true;
    } else if (command.toLowerCase().contains(ConstantVal().namaste)) {
      flutterTts.setLanguage(ConstantVal().hinLang);
      speakOut(ConstantVal().hinLangWelcome, context);
      return;
    } else if (command.toLowerCase().contains('bonjour') ||
        command.toLowerCase().contains('bonzer') ||
        command.toLowerCase().contains('bonzo')) {
      flutterTts.setLanguage("fr-FR");
      speakOut(
          "Mon nom est Connie, bienvenue dans le véhicule autonome comment puis-je vous aider",
          context);
      return;
    } else if (command.toLowerCase().contains('joke') ||
        command.toLowerCase().contains('say something funny') ||
        command.toLowerCase().contains('tell me something funny') ||
        command.toLowerCase().contains('say a joke') ||
        command.toLowerCase().contains('tell me a joke')) {
      //I like to buy sunglasses
      flutterTts.setLanguage("en-GB-Wavenet-C");
      // create a ArrayList String type
      final jokesList = [
        "Here is a joke, Want to hear a construction joke? Oh never mind, I’m still working on that one.",
        "Here is a joke, Why don’t scientists trust atoms? Because they make up everything!",
        "Here is a joke , If we shouldn’t eat at night, why do they put a light in the fridge?",
        "Here is a joke, Why doesn’t the sun go to college? Because it has a million degrees!",
        "Here is a joke, My girlfriend treats me like God. She ignores my existence and only talks to me when she needs something.",
        "Here is a joke, Where does the sheep get his hair cut? The baa baa shop!",
        "Here is a joke, What dd the man in the moon do when his hair got too long? Eclipse it!",
        "Here is a joke, What did 0 say to 8? Nice belt!",
        "Here is a joke, Some people think prison is one word…but to robbers it’s the whole sentence.",
        "Here is a joke Why do French people eat snails? They don’t like fast food!"
      ];
      // generates a new Random object
      final _random = new Random();
      var element = jokesList[_random.nextInt(jokesList.length)];
      speakOut(element, context);
    } else if (command.toLowerCase().contains('scan my qr') ||
        command.toLowerCase().contains('scan') ||
        command.toLowerCase().contains('can') ||
        command.toLowerCase().contains('scan qr') ||
        command.toLowerCase().contains('generate code') ||
        command.toLowerCase().contains('generate QR code') ||
        command.toLowerCase().contains('shopping')) {
      Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true, builder: (context) => QRScan()),
      );
      return;
    } else if (command.toLowerCase().contains('generate ecommerce details') ||
        command.toLowerCase().contains('ecommerce')) {
      Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true, builder: (context) => QRGenerator()),
      );
      return;
    } else {
      setupFetchingStatus(true, context);
      flutterTts.setLanguage("en-GB-Wavenet-C");
      for (var object in cmsModelObject) {
        for (var cmd in object.utterences.enGB) {
          if (cmd.toLowerCase() == command.toLowerCase() ||
              cmd.toLowerCase().contains(command.toLowerCase())) {
            {
              String newString = object.response.enGB.toString();
              responseTextToDisplay = newString;

              setupFetchingStatus(false, context);
              setupSpeakingStatus(true, context);
              setupSpeakText(responseTextToDisplay, context);

              detected = true;
              speakOut(object.response.enGB, context);
              return;
            }
          } else {
            setupMicButton(true, context);
          }
        }
      }
      detected = false;
    }

    if (!(ConstantVal.isSpeaking)) {
      if (ConstantVal.isTypePressed) {
        setupMicButton(false, context);
      }
      if (!callingTwilio) {
        ttsStarted = true;
        if (command.toLowerCase().toString().trim().contains('adult') ||
            command.toLowerCase().toString().trim().contains('sex') ||
            command.toLowerCase().toString().trim().contains('porn') ||
            command.toLowerCase().toString().trim().contains('xx') ||
            command.toLowerCase().toString().trim().contains('xxx') ||
            command.toLowerCase().toString().trim().contains('romance') ||
            command.toLowerCase().toString().trim().contains('fuck') ||
            command.toLowerCase().toString().trim().contains('asshole') ||
            command.toLowerCase().toString().trim().contains('sexy') ||
            command.toLowerCase().toString().trim().contains('horny') ||
            command.toLowerCase().toString().trim().contains('hot')) {
          setupFetchingStatus(false, context);
          speakOut("Sorry No Results Found", context);
        } else {
          // startTimer();
          print("dstection" + detected.toString());
          customSearchWelform(command.toLowerCase().toString())
              .then((value) async {
            detected = true;
            setupFetchingStatus(false, context);
            print("dstection" + value.toString());
            speakOut(value, context);
          });
        }
      }
    }
  }

  @override
  stop() async {
    // TODO: implement stop
    var result = await flutterTts.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }

  @override
  setupMusicPlayingStatus(bool misicPlayijng, BuildContext context) {
    // TODO: implement setupMusicPlayingStatus
    Provider.of<SpeakingUiInfoProvider>(context, listen: false)
        .setMusicPlayingStatus(misicPlayijng);
  }

  @override
  setupSpeakText(String speakValue, BuildContext context) {
    // TODO: implement setupSpeakText
    Provider.of<SpeakingUiInfoProvider>(context, listen: false)
        .setSpeakingText(speakValue);
  }

  @override
  setupYoutubeId(String youtubeId, BuildContext context) {
    // TODO: implement setupYoutubeId
    Provider.of<YoutubeInfoProvider>(context, listen: false)
        .setYoutubeId(youtubeId);
  }

  @override
  setupYoutubePlayerPlayingStatus(bool playingStatus, BuildContext context) {
    // TODO: implement setupYoutubePlayerPlayingStatus

    Provider.of<YoutubeInfoProvider>(context, listen: false)
        .setisVideoPlayingStatus(playingStatus);
  }

  @override
  setupYoutubrPlayerLiveVideoStatus(
      bool liveVideoStatus, BuildContext context) {
    // TODO: implement setupYoutubrPlayerLiveVideoStatus
    Provider.of<YoutubeInfoProvider>(context, listen: false)
        .setLiveVideoStatus(liveVideoStatus);
  }

  @override
  setupFetchingStatus(bool fetching, BuildContext context) {
    // TODO: implement setupFetchingStatus
    Provider.of<SpeakingUiInfoProvider>(context, listen: false)
        .setFetchResultsStatus(fetching);
  }

  @override
  startTimer() {
    // TODO: implement startTimer
    throw UnimplementedError();
  }
}

enum TtsState { playing, stopped, paused, continued }
