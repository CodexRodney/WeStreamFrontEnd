import 'package:flutter/material.dart';
import 'package:westreamfrontend/screens/vibe_others/models/viber_model.dart';

class VibersProvider with ChangeNotifier {
  List<ViberModel> vibers = [];

  void updateVibers(ViberModel viber) {
    vibers.add(viber);
    notifyListeners();
  }
}
