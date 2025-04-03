import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.label, required this.isReceived});

  final String label;
  final bool isReceived;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isReceived ? Alignment.topLeft : Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color:
                isReceived ? Colors.lightBlueAccent : const Color(0xff9bbe31),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            label,
            style: TextStyle(color: Colors.black),
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
