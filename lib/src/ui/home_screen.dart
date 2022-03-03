import 'package:connie/src/providers/homeScreenProvider.dart';
import 'package:connie/src/providers/typeSpeakProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connie/src/providers/controlButtonsProvider.dart';
import 'package:connie/src/providers/infoButtonProvider.dart';
import 'package:connie/src/providers/speakingUiInfoProvider.dart';
import 'package:connie/src/providers/youtubeInfoProvider.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connie/src/ui/custom/control_buttons.dart';
import 'package:connie/src/ui/custom/info_button.dart';
import 'package:connie/src/ui/custom/volume_control_img.dart';
import 'package:connie/src/ui/google_map_screen.dart';
import 'package:connie/src/utils/commonVal.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../utils/commonVal.dart';
import 'package:connie/src/ui/custom/welcom_widget.dart';
import 'package:connie/src/ui/custom/top_group.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';
import 'custom/volume_control.dart';
import 'custom/youtube_player.dart';

class HomeScreen extends StatelessWidget {
  bool isInfoPressed = false;
  double widthSize;
  bool mapEnable = false;
  bool ttsStarted = false;
  bool musicisPlaying = false;
  BuildContext globalContext;
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  final SpeechToText speech = SpeechToText();
  bool isVideoLive = false;
  bool toPlayVideo = false;
  CollectionReference referenceFirebase;
  HomeScreenProvider homeScreenProvider;
  YoutubePlayerController _controller;
  Timer mytimer;
  TypeSpeakProvider typeSpeakProvider;

  @override
  Widget build(BuildContext context) {
    print("homescreeen");
    referenceFirebase = FirebaseFirestore.instance.collection('agoravideo');
    globalContext = context;
    homeScreenProvider = Provider.of<HomeScreenProvider>(context);
    typeSpeakProvider = Provider.of<TypeSpeakProvider>(context);

    // Provider.of<ControlButtonsProvider>(context).setMapButtonPressStatus(true);
    isInfoPressed =
        Provider.of<InfoButtonProvider>(context).getInfoButtonPressStatus();
    ConstantVal.isMicPressed =
        Provider.of<ControlButtonsProvider>(context).getMicButtonPressStatus();
    mapEnable =
        Provider.of<ControlButtonsProvider>(context).getMapButtonPressStatus();
    ConstantVal.isTypePressed =
        Provider.of<ControlButtonsProvider>(context).getTypeButtonPressStatus();
    ConstantVal.isSpeaking =
        Provider.of<SpeakingUiInfoProvider>(context).getspeakingStatus();
    musicisPlaying =
        Provider.of<SpeakingUiInfoProvider>(context).getMusicPlayingStatus();

    toPlayVideo =
        Provider.of<YoutubeInfoProvider>(context).getvideoPlayingStatus();
    widthSize = MediaQuery.of(context).size.longestSide;
    homeScreenProvider.initVales(context);
    homeScreenProvider.intializeVideoListners(context);
    return Consumer<YoutubeInfoProvider>(
        builder: (context, youTubeProvider, child) {
      return Scaffold(
        backgroundColor: Colors.black, // const Color(0x10101000),
        body: _homeScreenUIItems(context, youTubeProvider),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('\n\ndidChangeAppLifecycleState');
    switch (state) {
      case AppLifecycleState.resumed:
        print('\n\nresumed');
        break;
      case AppLifecycleState.inactive:
        // mytimer.cancel();
        homeScreenProvider.callNativeTts(true, "", globalContext);
        print('\n\ninactive');
        break;
      case AppLifecycleState.paused:
        homeScreenProvider.callNativeTts(true, "", globalContext);
        mytimer.cancel();
        homeScreenProvider.setupMicButton(false, globalContext);
        homeScreenProvider.setupSpeakingStatus(false, globalContext);
        homeScreenProvider.stop();
        print('\n\npaused');
        break;
      case AppLifecycleState.detached:
        homeScreenProvider.chagePhoneSoundModestoNormal();
        print('\n\ndetached');
        _controller.pause();
        _controller.close();
        homeScreenProvider.stop();
        homeScreenProvider.stopListening(globalContext);
        homeScreenProvider.callNativeTts(
            false, ConstantVal().stop, globalContext);
        mytimer.cancel();
        break;
    }
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    // if (!mounted) return;
  }

  void errorListener(SpeechRecognitionError error) {
    lastError = "${error.errorMsg} - ${error.permanent}";
    homeScreenProvider.setupMicButton(false, globalContext);
  }

  void statusListener(String status) {
    lastStatus = "$status";
  }

  Widget _buildInfoButton(BuildContext context) {
    isInfoPressed =
        Provider.of<InfoButtonProvider>(context).getInfoButtonPressStatus();
    return Positioned(
      left: isInfoPressed ? 80 : 95,
      bottom: isInfoPressed ? 56 : 70,
      child: InfoButton(),
    );
  }

  Widget _wavesAnumation(
      BuildContext context, SpeakingUiInfoProvider speakingUiInfoProvider) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 500.0,
          height: 120.0,
          child: AutoSizeText(
            speakingUiInfoProvider.getFetchResultsStatus()
                ? ConstantVal().fetchingResults
                : speakingUiInfoProvider.speakingTextVal,
            minFontSize: 10,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.0, color: Colors.white),
            maxLines: 10,
          ),
        ),
        SizedBox(height: 70.0),
        SizedBox(
          height: 100.0,
          child: SpinKitWave(
            color: Colors.white60,
            type: SpinKitWaveType.start,
            itemCount: 20,
            size: 100.0,
          ),
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    ));
  }

  Widget _googleMapScreen(
      YoutubeInfoProvider youtubeInfoProvider, BuildContext context) {
    return Container(
      width: 500.00,
      height: youtubeInfoProvider.videoPlayStatus ? 500.00 : 750.00,
      child: GoogleMapScreen(
        onMapEnable: (enable) {
          homeScreenProvider.setupMapButton(false, context);
        },
      ),
    );
  }

  Widget _youTubeWidget(
      BuildContext context, YoutubeInfoProvider youtubeInfoProvider) {
    print("videoPlayingStaus  ID" +
        Provider.of<YoutubeInfoProvider>(context).getYoutubeId().toString());

    return Positioned(
      right: 10,
      bottom: 10,
      child: SizedBox(
        height: 220,
        width: 500,
        child: YouTubeWidget(
          playVideo: (playVideo) {
            homeScreenProvider.setupYoutubePlayerPlayingStatus(
                playVideo, context);
          },
          playerController: (playerController) {
            _controller = playerController;
            print("_controller sfgsdfg");
          },
          youTubeId: youtubeInfoProvider.getYoutubeId(),
          isVideoLive: false,
        ),
      ),
    );
  }

  Widget _volumeInfoImage() {
    return Positioned(
      left: 102,
      bottom: 137,
      child: SizedBox(
        width: 43.2,
        height: 16.8,
        child: Image.asset(ConstantVal().imageAssets),
      ),
    );
  }

  Widget _charmBarItems() {
    return Positioned(
      right: mapEnable ? 10.0 : 170.0,
      top: 60,
      child: TopGroup(), //wifiLevel
    );
  }

  Widget _connieLogoImage() {
    return Positioned(
      top: 50,
      left: 95,
      child: SizedBox(
        width: 219.4,
        height: 58.5,
        child: Image.asset(ConstantVal().imageConnieAssests),
      ),
    );
  }

  Widget _conigitalLogoImage() {
    return Positioned(
      top: 50,
      right: 50,
      child: SizedBox(
        width: 100,
        height: 40,
        child: Image.asset(ConstantVal().imageConigitalLogo),
      ),
    );
  }

  Widget _volumeControlerImage() {
    return Positioned(
      left: 95,
      top: 200,
      child: VolumeControlImage(
        volumeState: ConstantVal.volumeState,
      ),
    );
  }

  Widget _volumeControl() {
    return Positioned(
      left: 104,
      top: 245,
      child: VolumeControl(
        volumeState: (volumeState) {
          ConstantVal.volumeState = volumeState;
        },
      ),
    );
  }

  Widget _welcomeWidgetItems() {
    return Positioned.fill(
      top: 290.0,
      left: 150,
      child: Align(
        alignment: Alignment.center,
        child: WelcomeWidget(
          welcomeSize: 70.0,
          mapEnable: mapEnable,
        ),
      ),
    );
  }

  Widget _welcomeWidgetsItemsnoMap(
      BuildContext context, SpeakingUiInfoProvider speakingUiInfoProvider) {
    print("speakStatus" + speakingUiInfoProvider.speakStatuss.toString());
    return Positioned.fill(
      top: 230.0,
      child: Align(
        alignment: Alignment.center,
        child: speakingUiInfoProvider.speakStatuss
            ? _wavesAnumation(context, speakingUiInfoProvider)
            : speakingUiInfoProvider.getFetchResultsStatus()
                ? _wavesAnumation(context, speakingUiInfoProvider)
                : Center(
                    child: WelcomeWidget(
                      welcomeSize: 120.0,
                      mapEnable: mapEnable,
                    ),
                  ),
      ),
    );
    // });
  }

  void setUpSpeakUi(bool micPressStatus,
      ControlButtonsProvider controlButtonsProvider, BuildContext context) {
    homeScreenProvider.setupFetchingStatus(false, context);
    if (musicisPlaying) {
      homeScreenProvider.setupMusicPlayingStatus(false, context);
      homeScreenProvider.callNativeTts(false, "stopmusic", context);
    }
    homeScreenProvider.setupMicButton(micPressStatus, globalContext);
    if (micPressStatus) {
      // startTimerforTss(context);
      if (toPlayVideo) {
        _controller.pause();
      }
      // } else {
      if (ttsStarted) {
        print("ttsStarted   1one");
        homeScreenProvider.callNativeTts(true, "", context);
      } else {
        print("ttsStarted   2one");

        homeScreenProvider.callNativeTts(false, "", context);
      }
    } else {
      print("ttsStarted   3one");
      homeScreenProvider.setupSpeakText("", context);
      homeScreenProvider.setupSpeakingStatus(false, context);
      homeScreenProvider.stop();
      ttsStarted = true;
      homeScreenProvider.callNativeTts(false, "stop", context);
    }
  }

  Widget _controlButtons(BuildContext context) {
    return Consumer<ControlButtonsProvider>(
        builder: (context, controlButtonsProv, child) {
      return Positioned(
          bottom: isInfoPressed
              ? mapEnable
                  ? 70
                  : 85
              : ConstantVal.isMicPressed
                  ? 85
                  : 90,
          left: isInfoPressed
              ? mapEnable
                  ? 230.0
                  : 420.0
              : ConstantVal.isMicPressed
                  ? mapEnable
                      ? 230.0
                      : 420
                  : (mapEnable ? 230.0 : 420),
          // bottom: ConstantVal.isMicPressed ? 75 : 90,// left: ConstantVal.isMicPressed ? 460 : (mapEnable ? 230.0 : 460),
          child: ControlButtons(
            setupui: (micPressed) {
              setUpSpeakUi(micPressed, controlButtonsProv, context);
            },
            ismapEnable: (isMapEnable) {
              homeScreenProvider.setupMapButton(isMapEnable, context);

              mapEnable = isMapEnable;
              // });
            },
            speak: (val) {
              print("callStatusflutter texxxt" + val);

              homeScreenProvider.speak(val, true, context);
            },
            mapFlag: mapEnable,
          ));
    });
  }

  Widget _youtubeWhenMap(
      BuildContext context, YoutubeInfoProvider youtubeInfoProvider) {
    return Positioned(
      right: 10,
      bottom: 10,
      child: SizedBox(
        height: 250,
        width: 360,
        child: YouTubeWidget(
          playVideo: (playVideo) {
            toPlayVideo = playVideo;
            homeScreenProvider.setupYoutubePlayerPlayingStatus(
                toPlayVideo, context);
          },
          playerController: (playerController) {
            _controller = playerController;
            print("_controller sfgsdfg");
          },
          youTubeId: youtubeInfoProvider.getYoutubeId(),
          isVideoLive: false,
        ),
      ),
    );
  }

  Widget _videoPlaying(BuildContext context) {
    return Positioned(
      right: 1,
      bottom: 182,
      child: new IconButton(
        icon: new Icon(
          Icons.close,
          color: Colors.black,
        ),
        onPressed: () {
          homeScreenProvider.onSearchButtonPressed(context);
        },
      ),
    );
  }

  Widget _buildHomeContainer(
      BuildContext context, YoutubeInfoProvider youtubeInfoProvider) {
    print("videoPlayingStaus  123456" +
        Provider.of<YoutubeInfoProvider>(context)
            .getvideoPlayingStatus()
            .toString());
    print("videoPlayingStaus  ID" +
        Provider.of<YoutubeInfoProvider>(context).getYoutubeId().toString());

    return Consumer<SpeakingUiInfoProvider>(builder: (context, speakInfo, _) {
      return Container(
        width: mapEnable ? widthSize * 0.6 : widthSize,
        height: MediaQuery.of(globalContext).size.shortestSide,
        decoration: musicisPlaying
            ? BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ConstantVal().alanwalkerImage),
                    fit: BoxFit.cover))
            : BoxDecoration(),
        child: Stack(
          children: [
            _buildInfoButton(context),
            if (isInfoPressed) _volumeInfoImage(),
            _charmBarItems(),
            _connieLogoImage(),
            mapEnable ? SizedBox() : _conigitalLogoImage(),
            _volumeControlerImage(),
            _volumeControl(),
            mapEnable
                ? _welcomeWidgetItems()
                : _welcomeWidgetsItemsnoMap(context, speakInfo),
            _controlButtons(context),
            if (youtubeInfoProvider.getvideoPlayingStatus() && !mapEnable)
              _youtubeWhenMap(context, youtubeInfoProvider),
            if (youtubeInfoProvider.getvideoPlayingStatus())
              _videoPlaying(context),
          ],
        ),
      );
    });
  }

  Widget _homeScreenUIItems(
      BuildContext context, YoutubeInfoProvider youtubeInfoProvider) {
    return Row(
      children: [
        _buildHomeContainer(context, youtubeInfoProvider),
        if (mapEnable) _googleMapandYoutubePlayer(youtubeInfoProvider, context),
      ],
    );
  }

  Widget _googleMapandYoutubePlayer(
      YoutubeInfoProvider youtubeInfoProvider, BuildContext context) {
    print("videoPlayingStaus  map " +
        youtubeInfoProvider.getvideoPlayingStatus.toString());

    return Padding(
      padding: EdgeInsets.only(left: 2, right: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _googleMapScreen(youtubeInfoProvider, context),
          if (youtubeInfoProvider.getvideoPlayingStatus() && mapEnable)
            _youTubeWidget(context, youtubeInfoProvider),
        ],
      ),
    );
  }
}
