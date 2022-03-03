import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'Controls.dart';

class YouTubeWidget extends StatefulWidget {
  final Function(bool) playVideo;
  final Function(YoutubePlayerController) playerController;
  final String youTubeId;
  final bool isVideoLive;

  YouTubeWidget(
      {Key key,
      this.playVideo,
      this.playerController,
      this.youTubeId,
      this.isVideoLive})
      : super(key: key);

  @override
  _YouTubeWidgetState createState() => _YouTubeWidgetState();
}

class _YouTubeWidgetState extends State<YouTubeWidget> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    setupYoutube();
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      print('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      setupYoutube();
      setState(() {
        _controller.reset();
      });
      print('Exited Fullscreen');
    };
  }

  void setupYoutube() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.youTubeId,
      params: const YoutubePlayerParams(
        startAt: const Duration(minutes: 0, seconds: 0),
        showControls: true,
        autoPlay: true,
        showFullscreenButton: true,
        desktopMode: true,
        privacyEnhanced: true,
      ),
    );

    widget.playerController(_controller);
    // widget.playVideo(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      // Passing controller to widgets below.
      // Passing controller to widgets below.
      controller: _controller,

      child: LayoutBuilder(
        builder: (context, constraints) {
          if (kIsWeb && constraints.maxWidth > 800) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: player),
                const SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                    child: Controls(),
                  ),
                ),
              ],
            );
          }

          return ListView(
            children: [
              player,
              const Controls(),
            ],
          );
        },
      ),
    );
  }
}
