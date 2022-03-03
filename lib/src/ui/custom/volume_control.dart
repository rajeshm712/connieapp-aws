import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connie/src/utils/commonVal.dart';
import 'package:volume/volume.dart';

class VolumeControl extends StatefulWidget {
  final Function(int) volumeState;

  VolumeControl({this.volumeState});

  @override
  _VolumeControlState createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {
  int volumeState = 0;
  int volumeDisable = 0;
  int volumeDown = 1;
  int volumeUp = 2;
  int volume = 3;
  bool isMicPressed = false;
  bool volumeEnabled = false;
  AudioManager audioManager;
  int maxVol = 0, currentVol = 0;
  ShowVolumeUI showVolumeUI = ShowVolumeUI.SHOW;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      audioManager = AudioManager.STREAM_SYSTEM;
      initAudioStreamType();
      updateVolumes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //margin: EdgeInsets.only( left: 30, right: 20),
        alignment: Alignment.bottomLeft,
        child: GestureDetector(
          child: Container(
            height: 315,
            child: RotatedBox(
                quarterTurns: 3,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbColor: Colors.transparent,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                    activeTrackColor: ConstantVal.volumeState != volumeDisable
                        ? Color.fromRGBO(2, 209, 203, 1)
                        : Color.fromRGBO(112, 112, 112, 1),
                    inactiveTrackColor: ConstantVal.volumeState != volumeDisable
                        ? Color.fromRGBO(112, 112, 112, 1)
                        : Color.fromRGBO(32, 32, 32, 1),
                  ),
                  child: Slider(
                    value: currentVol.toDouble(),
                    //divisions: maxVol,
                    max: maxVol.toDouble(),
                    min: 0,
                    onChanged: (value) {
                      if (volumeEnabled) {
                        setState(() {
                          if (value > (currentVol.toDouble())) {
                            setVolumeState(volumeUp);
                          } else {
                            setVolumeState(volumeDown);
                          }
                          setVol(value.toInt());
                          updateVolumes();
                        });
                      }
                    },
                    onChangeStart: (double startValue) {
                      if (ConstantVal.volumeState == volumeDisable) {
                        setVolumeState(volume);
                      } else if (ConstantVal.volumeState == volume) {
                        volumeEnabled = true;
                      }
                    },
                    onChangeEnd: (double newValue) {
                      setVolumeState(volume);
                      waitForDisable(false);
                    },
                  ),
                )),
          ),
          onTap: () {
            if (ConstantVal.volumeState == volumeDisable) {
              setVolumeState(volume);
            }
          },
        ));
  }

  //Volume control related
  Future<void> initAudioStreamType() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }

  updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
    setState(() {});
    Volume.setVol(currentVol);
  }

  setVol(int i) async {
    await Volume.setVol(i, showVolumeUI: showVolumeUI);
  }

  void waitForDisable(bool flag) async {
    if (flag) {
      waitForVolume(flag);
    }
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (ConstantVal.volumeState != volumeUp &&
          ConstantVal.volumeState != volumeDown) {
        setVolumeState(volumeDisable);
        volumeEnabled = false;
      }
    });
  }

  void waitForVolume(bool flag) {
    waitForVolumeUp();
    Future.delayed(const Duration(milliseconds: 4000), () {
      setVolumeState(volume);
    });
  }

  void waitForVolumeUp() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setVolumeState(volumeUp);
    });
  }

  void setVolumeState(int value) {
    setState(() {
      widget.volumeState(value);
      ConstantVal.volumeState = value;
    });
  }
}
