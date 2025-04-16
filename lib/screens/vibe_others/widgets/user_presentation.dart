import 'dart:math' as math;

import 'package:flutter/material.dart';

class UserPresentationWidget extends StatelessWidget {
  const UserPresentationWidget({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(
              255,
              80 + math.Random().nextInt(176),
              80 + math.Random().nextInt(176),
              80 + math.Random().nextInt(176),
            ),
          ),
          child: Center(
            child: Text(
              username[0].toUpperCase(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(username),
        ),
      ],
    );
  }
}
