// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

List<UserLocation> userLocationFromJson(String str) => List<UserLocation>.from(
    json.decode(str).map((x) => UserLocation.fromMap(x)));
// List<UserLocation> userLocationFromJson(String str) =>
//     List<UserLocation>.from(
//         json.decode(str).map((x) => UserLocation.fromJson(x)));

class UserLocation {
  ///Clase para contenedora de la ubicacion de los usuarios
  UserLocation({
    required this.dateTime,
    required this.userName,
    required this.userEmail,
    required this.latitud,
    required this.longitud,
  });

  final DateTime dateTime;

  final String userName;

  final String userEmail;

  final double latitud;

  final double longitud;

  UserLocation copyWith({
    DateTime? dateTime,
    String? userName,
    String? userEmail,
    double? latitud,
    double? longitud,
  }) {
    return UserLocation(
      dateTime: dateTime ?? this.dateTime,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
    );
  }

// $moto_time = strip_tags($_POST['moto_time']);
// $moto_name = strip_tags($_POST['moto_name']);
// $moto_email = strip_tags($_POST['moto_email']);
// $moto_lat = strip_tags($_POST['moto_lat']);
// $moto_lon = strip_tags($_POST['moto_lon']);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'moto_time': dateTime.millisecondsSinceEpoch,
      'moto_name': userName,
      'moto_email': userEmail,
      'moto_lat': latitud,
      'moto_lon': longitud,
    };
  }

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      dateTime: DateTime.parse(map['reg_moto_time'] as String),
      userName: map['reg_moto_name'] as String,
      userEmail: map['reg_moto_email'] as String,
      latitud: double.parse(map['reg_moto_lat'] as String),
      longitud: double.parse(map['reg_moto_lon'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLocation.fromJson(String source) =>
      UserLocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserLocation(dateTime: $dateTime, userName: $userName, userEmail: $userEmail, latitud: $latitud, longitud: $longitud)';
  }

  @override
  bool operator ==(covariant UserLocation other) {
    if (identical(this, other)) return true;

    return other.dateTime == dateTime &&
        other.userName == userName &&
        other.userEmail == userEmail &&
        other.latitud == latitud &&
        other.longitud == longitud;
  }

  @override
  int get hashCode {
    return dateTime.hashCode ^
        userName.hashCode ^
        userEmail.hashCode ^
        latitud.hashCode ^
        longitud.hashCode;
  }
}
