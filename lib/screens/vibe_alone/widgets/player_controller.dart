import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:westreamfrontend/constants/custom_icons.dart';

class PlayerController extends StatefulWidget {
  const PlayerController({
    super.key,
    required this.musicLength,
    required this.musicPath,
    required this.player,
  });

  final int musicLength;
  final String musicPath;
  final AudioPlayer player;

  @override
  State<PlayerController> createState() => _PLayControllerState();
}

class _PLayControllerState extends State<PlayerController> {
  Timer? _timer;
  late bool _isPlaying;
  late bool _isFirstTime;
  late bool _onLoop;
  late double _progressValue;
  late double _volumeValue;
  late int _songPos;

  @override
  void initState() {
    _isPlaying = false;
    _isFirstTime = true;
    _onLoop = false;
    _progressValue = 0;
    _volumeValue = 0.6;
    _songPos = 0;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PlayerController oldWidget) {
    super.didUpdateWidget(oldWidget);
    _timer?.cancel();
    _isPlaying = false;
    _isFirstTime = true;
    _progressValue = 0;
    _songPos = 0;
  }

  @override
  void dispose() async {
    _timer?.cancel();
    super.dispose();
    await widget.player.release();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: Icon(CustomIcons.shuffle)),
        IconButton(onPressed: () {}, icon: Icon(CustomIcons.stepBackward)),
        // play button
        IconButton(
          onPressed: () async {
            if (!_isPlaying) {
              if (_isFirstTime) {
                await widget.player.setReleaseMode(
                  _onLoop ? ReleaseMode.loop : ReleaseMode.stop,
                );
                widget.player.seek(Duration(seconds: _songPos));
                _isFirstTime = false;

                // setting an oncomplete listener
                widget.player.onPlayerComplete.listen((event) {
                  // change playing icon
                  setState(() {
                    _isPlaying = _onLoop;
                    _progressValue = 0;
                    _songPos = 0;
                    if (_onLoop) {
                      updateProgress();
                    }
                  });
                });
              }
              await widget.player.resume();

              setState(() {
                _isPlaying = !_isPlaying;
              });
              updateProgress();
              return;
            }
            widget.player.pause();
            _timer?.cancel();
            setState(() {
              _isPlaying = !_isPlaying;
            });
          },
          icon:
              _isPlaying
                  ? Icon(Icons.pause_outlined)
                  : Icon(Icons.play_arrow_rounded),
        ),
        IconButton(onPressed: () {}, icon: Icon(CustomIcons.skipForward)),
        // looping button
        IconButton(
          onPressed: () async {
            // TODO change once you have made player available on innit
            if (_isFirstTime) return;
            if (!_onLoop) {
              await widget.player.setReleaseMode(ReleaseMode.loop);
              setState(() {
                _onLoop = true;
              });
              return;
            }
            await widget.player.setReleaseMode(ReleaseMode.stop);
            setState(() {
              _onLoop = false;
            });
          },
          icon:
              _onLoop
                  ? Icon(CustomIcons.loop, color: Color(0xffA04F51))
                  : Icon(CustomIcons.loop),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("1:35"),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.02,
          child: Slider(
            value: _progressValue,
            min: 0,
            max: 1,
            onChanged: (value) {},
            onChangeStart: (value) => _timer?.cancel(),
            onChangeEnd: (value) async {
              setState(() {
                _progressValue = value;
                _songPos = (value * widget.musicLength).toInt();
              });
              if (!_isFirstTime) {
                await widget.player.seek(Duration(seconds: _songPos));
              }
              updateProgress();
            },
            activeColor: Color(0xff00C699),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("4:01"),
        ),
        const Spacer(),
        Icon(CustomIcons.speaker),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.height * 0.02,
          child: Slider(
            value: _volumeValue,
            min: 0,
            max: 1,
            onChanged: (value) async {
              await widget.player.setVolume(value);
              setState(() {
                _volumeValue = value;
              });
            },
            activeColor: Color(0xff00C699),
          ),
        ),
      ],
    );
  }

  void updateProgress() {
    if (!_isPlaying) return;
    double minVal = (1 * 1) / widget.musicLength;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_progressValue >= 0.99) {
        _timer?.cancel();
        return;
      }
      setState(() {
        _progressValue += minVal;
      });
    });
  }
}
