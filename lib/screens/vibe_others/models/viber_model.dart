class ViberModel {
  ViberModel({
    required this.username,
    // required this.viberId,
    required this.isAdmin,
  });

  String username;
  // String viberId;
  bool isAdmin;

  ViberModel.fromJson(Map<String, dynamic> json)
    : username = json['username'],
      // viberId = json["viber_id"].toString(),
      isAdmin = json["is_admin"];
}
