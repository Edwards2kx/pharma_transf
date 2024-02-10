import 'dart:convert';

enum UserCargo { administrador, dependiente, motorizado }

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

// String userToJson(List<User> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User(
      {required this.usersId,
      required this.usersDate,
      required this.usersEmail,
      required this.usersNombre,
      required this.usersEstado,
      required this.userCargo,
      this.dependencia});

  String usersId;
  DateTime usersDate;
  String usersEmail;
  String usersNombre;
  String usersEstado;
  UserCargo userCargo;
  String? dependencia;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        usersId: json["users_id"],
        usersDate: DateTime.parse(json["users_date"]),
        usersEmail: json["users_email"],
        usersNombre: json["users_nombre"],
        usersEstado: json["users_estado"],
        userCargo: toUserCargo(json["users_cargo"]),
        dependencia: json["users_pertence"]);
  }

  static UserCargo toUserCargo(String cargo) {
    final cargoToConvert = cargo.toLowerCase();
    if (cargoToConvert == 'administrador') {
      return UserCargo.administrador;
    }
    if (cargoToConvert == 'dependiente') {
      return UserCargo.dependiente;
    }
    return UserCargo.motorizado;
  }


  User copyWith({
    String? usersId,
    DateTime? usersDate,
    String? usersEmail,
    String? usersNombre,
    String? usersEstado,
    UserCargo? userCargo,
    String? dependencia,
  }) {
    return User(
      usersId: usersId ?? this.usersId,
      usersDate: usersDate ?? this.usersDate,
      usersEmail: usersEmail ?? this.usersEmail,
      usersNombre: usersNombre ?? this.usersNombre,
      usersEstado: usersEstado ?? this.usersEstado,
      userCargo: userCargo ?? this.userCargo,
      dependencia: dependencia ?? this.dependencia,
    );
  }

  // factory User.fromJson(Map<String, dynamic> json) => User(
  //       usersId: json["users_id"],
  //       usersDate: DateTime.parse(json["users_date"]),
  //       usersEmail: json["users_email"],
  //       usersCargo: json["users_cargo"],
  //       usersNombre: json["users_nombre"],
  //       usersEstado: json["users_estado"],
  //     );

  // Map<String, dynamic> toJson() => {
  //       "users_id": usersId,
  //       "users_date": usersDate.toIso8601String(),
  //       "users_email": usersEmail,
  //       // "users_cargo": usersCargo,
  //       "users_cargo": userCargo.toString(),
  //       "users_nombre": usersNombre,
  //       "users_estado": usersEstado,
  //     };

  @override
  String toString() {
    return 'User { usersId: $usersId, usersDate: $usersDate, usersEmail: $usersEmail, usersCargo: ${userCargo.toString()}, usersNombre: $usersNombre, usersEstado: $usersEstado }';
  }
}
