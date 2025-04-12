import 'dart:math' as math;

import 'package:flutter/material.dart';

class MusicContainer extends StatelessWidget {
  const MusicContainer({
    super.key,
    required this.musicIndex,
    required this.musicName,
    required this.artist,
    required this.textcolor,
  });

  final int musicIndex;
  final String musicName;
  final String artist;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          musicIndex < 10 ? "0$musicIndex" : "$musicIndex",
          style: TextStyle(color: textcolor),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.05,
            // adding 80 to avoid colors closer to black due to text color
            color: Color.fromARGB(
              255,
              80 + math.Random().nextInt(176),
              80 + math.Random().nextInt(176),
              80 + math.Random().nextInt(176),
            ),
            child: Center(
              child: Text(
                musicName[0],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              musicName.length > 18 ? musicName.substring(0, 18) : musicName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textcolor,
              ),
              softWrap: true,
            ),
            Text(artist, style: TextStyle(color: Colors.grey), softWrap: true),
          ],
        ),
      ],
    );
  }
}
