import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.usersId,
    required this.usersDate,
    required this.usersEmail,
    required this.usersCargo,
    required this.usersNombre,
    required this.usersEstado,
  });

  String usersId;
  DateTime usersDate;
  String usersEmail;
  String usersCargo;
  String usersNombre;
  String usersEstado;

  factory User.fromJson(Map<String, dynamic> json) => User(
        usersId: json["users_id"],
        usersDate: DateTime.parse(json["users_date"]),
        usersEmail: json["users_email"],
        usersCargo: json["users_cargo"],
        usersNombre: json["users_nombre"],
        usersEstado: json["users_estado"],
      );

  Map<String, dynamic> toJson() => {
        "users_id": usersId,
        "users_date": usersDate.toIso8601String(),
        "users_email": usersEmail,
        "users_cargo": usersCargo,
        "users_nombre": usersNombre,
        "users_estado": usersEstado,
      };

  @override
  String toString() {
    return 'User { usersId: $usersId, usersDate: $usersDate, usersEmail: $usersEmail, usersCargo: $usersCargo, usersNombre: $usersNombre, usersEstado: $usersEstado }';
  }
}
