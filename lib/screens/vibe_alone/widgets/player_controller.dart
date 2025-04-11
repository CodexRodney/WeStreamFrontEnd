import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:westreamfrontend/constants/custom_icons.dart';

class PlayerController extends StatefulWidget {
  const PlayerController({super.key, required this.songLength});
  final int songLength;

  @override
  State<PlayerController> createState() => _PLayControllerState();
}

class _PLayControllerState extends State<PlayerController> {
  late final AudioPlayer _player = AudioPlayer();
  Timer? _timer;
  bool _isPlaying = false;
  bool _isFirstTime = true;
  bool _onLoop = false;
  double _progressValue = 0;
  double _volumeValue = 0.6;
  int _songPos = 0;

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
                await _player.setSource(AssetSource('test_music/bahati.mp3'));
                // setting player source to stop by default
                await _player.setReleaseMode(ReleaseMode.stop);
                _player.seek(Duration(seconds: _songPos));
                _isFirstTime = false;

                // setting an oncomplete listener
                _player.onPlayerComplete.listen((event) {
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
              await _player.resume();

              setState(() {
                _isPlaying = !_isPlaying;
              });
              updateProgress();
              return;
            }
            _player.pause();
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
              await _player.setReleaseMode(ReleaseMode.loop);
              setState(() {
                _onLoop = true;
              });
              return;
            }
            await _player.setReleaseMode(ReleaseMode.stop);
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
                _songPos = (value * widget.songLength).toInt();
              });
              if (!_isFirstTime) {
                await _player.seek(Duration(seconds: _songPos));
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
              await _player.setVolume(value);
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
    double minVal = (1 * 1) / widget.songLength;
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

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();

    super.dispose();
  }
}
