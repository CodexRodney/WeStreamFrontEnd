// contains services related to rooms

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:westreamfrontend/screens/start_screen/services/base_services.dart';

class RoomsService {
  static Future createRoom() async {
    var response = await http.post(
      Uri.parse("${BaseServices.baseUrl}/create-room"),
      headers: BaseServices.headers,
    );
    if (response.statusCode >= 200 && response.statusCode < 299) {
      return jsonDecode(response.body);
    }
    throw "Something Went Wrong";
  }

  static Future uploadMusicToRoom(
    Map<String, String> body,
    File musicFile,
    // Uint8List musicAsBytes,
  ) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse('${BaseServices.baseUrl}/upload-music'),
    );
    request.fields.addAll(body);
    request.files.add(
      await http.MultipartFile.fromPath("music_file", musicFile.path),
      // http.MultipartFile.fromBytes(
      //   'image',
      //   imageAsBytes,
      //   filename: imageFile.path.toString() + imageFile.name,
      // ),
    );
    var response = await request.send();
    String responseBody = await response.stream.bytesToString();
    if (response.statusCode >= 200 && response.statusCode < 299) {
      return jsonDecode(responseBody);
    }
    throw "Something Went Wrong";
  }

  static Future<WebSocketChannel> joinRoom(
    String roomId,
    String viberId,
    bool isAdmin,
  ) async {
    try {
      final WebSocketChannel channel = WebSocketChannel.connect(
        Uri.parse('${BaseServices.wsUrl}/join-room/$roomId/$viberId/$isAdmin'),
      );
      await channel.ready;
      return channel;
    } on SocketException {
      // Handle the exception.
      rethrow;
    } on WebSocketChannelException {
      // Handle the exception.
      rethrow;
    }
  }

  static Future<WebSocketChannel> joinMusicRoomChannel(String viberId) async {
    try {
      final WebSocketChannel channel = WebSocketChannel.connect(
        Uri.parse('${BaseServices.wsUrl}/stream-room-music/$viberId'),
      );
      await channel.ready;
      return channel;
    } on SocketException {
      // Handle the exception.
      rethrow;
    } on WebSocketChannelException {
      // Handle the exception.
      rethrow;
    }
  }
}
