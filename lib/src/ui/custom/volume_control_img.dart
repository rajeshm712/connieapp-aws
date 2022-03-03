import 'package:flutter/material.dart';
class VolumeControlImage extends StatefulWidget {
  final int volumeState;
  VolumeControlImage({this.volumeState});
  @override
  _VolumeControlImageState createState() => _VolumeControlImageState();
}

class _VolumeControlImageState extends State<VolumeControlImage> {
  int volumeDisable = 0;
  int volumeDown = 1;
  int volumeUp = 2;
  int volume = 3;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 66.0,
        height: 400.0,
        child: widget.volumeState == volumeDisable
            ? Image.asset("assets/images/volume_standby.png")
            : widget.volumeState == volumeUp
            ? Image.asset("assets/images/volume_up.png")
            : widget.volumeState == volumeDown
            ? Image.asset(
            "assets/images/volume_down.png")
            : Image.asset("assets/images/volume.png"),
      ),
    );
  }
}
