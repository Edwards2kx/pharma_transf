import 'dart:convert';

enum UserCargo { administrador, dependiente, motorizado }

extension UserCargoExtension on UserCargo {
  String toReadableString() {
    switch (this) {
      case UserCargo.administrador:
        return "Administrador";
      case UserCargo.dependiente:
        return "Dependiente";
      case UserCargo.motorizado:
        return "Motorizado";
    }
  }
}

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

class User {
  User(
      {required this.usersId,
      required this.usersDate,
      required this.usersEmail,
      required this.usersNombre,
      required this.usersEstado,
      required this.userCargo,
      this.userPertenece,
      this.isActive = false,
      this.franquiciado});

  String usersId;
  DateTime usersDate;
  String usersEmail;
  String usersNombre;
  String usersEstado;
  UserCargo userCargo;
  String? userPertenece;
  bool isActive;
  String? franquiciado;

  factory User.fromJson(Map<String, dynamic> json) {
    UserCargo toUserCargo(String cargo) {
      final cargoToConvert = cargo.toLowerCase();
      if (cargoToConvert == 'administrador') {
        return UserCargo.administrador;
      }
      if (cargoToConvert == 'dependiente') {
        return UserCargo.dependiente;
      }
      return UserCargo.motorizado;
    }

    bool isActive(String estado) {
      return estado.toLowerCase() == 'activo';
    }

    return User(
      usersId: json["users_id"],
      usersDate: DateTime.parse(json["users_date"]),
      usersEmail: json["users_email"],
      usersNombre: json["users_name"],
      usersEstado: json["users_estado"],
      userCargo: toUserCargo(json["users_cargo"]),
      userPertenece: json["users_pertenece"],
      isActive: isActive(json["users_estado"]),
      franquiciado: json["users_franquiciado"],
    );
  }

  Map<String, dynamic> toModel() {
    return {
      "email": usersEmail,
      "users_estado": usersEstado,
      "users_cargo": userCargo.toReadableString(),
      "users_pertenece": userPertenece,
      "users_dependencia": franquiciado
    };
  }

  User copyWith(
      {String? usersId,
      DateTime? usersDate,
      String? usersEmail,
      String? usersNombre,
      String? usersEstado,
      UserCargo? userCargo,
      String? userPertenece,
      bool? isActive,
      String? franquiciado}) {
    return User(
        usersId: usersId ?? this.usersId,
        usersDate: usersDate ?? this.usersDate,
        usersEmail: usersEmail ?? this.usersEmail,
        usersNombre: usersNombre ?? this.usersNombre,
        usersEstado: usersEstado ?? this.usersEstado,
        userCargo: userCargo ?? this.userCargo,
        userPertenece: userPertenece ?? this.userPertenece,
        isActive: isActive ?? this.isActive,
        franquiciado: franquiciado ?? this.franquiciado);
  }

  @override
  String toString() {
    return 'User { usersId: $usersId, usersDate: $usersDate, usersEmail: $usersEmail, usersCargo: ${userCargo.toString()}, usersNombre: $usersNombre, usersEstado: $usersEstado }, isActive: $isActive, franquiciado : $franquiciado';
  }
}
