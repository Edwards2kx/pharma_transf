import 'dart:convert';

List<Pharma> pharmaFromJson(String str) =>
    List<Pharma>.from(json.decode(str).map((x) => Pharma.fromJson(x)));

//TODO: agregar un equatable
class Pharma {
  Pharma(
      {this.farmasId,
      this.farmasName,
      this.farmasLat,
      this.farmasLon,
      this.farmasHorario});

  String? farmasId;
  String? farmasName;
  double? farmasLat;
  double? farmasLon;
  String? farmasHorario;

  factory Pharma.fromJson(Map<String, dynamic> json) => Pharma(
        farmasId: json["farmas_id"],
        farmasName: json["farmas_name"],
        farmasLat: double.parse(json["farmas_lat"]),
        farmasLon: double.parse(json["farmas_lon"]),
        farmasHorario: json["farmas_horario"],
      );

  @override
  String toString() {
    return 'Pharma { farmasId: $farmasId, farmasName: $farmasName, farmasLat: $farmasLat, farmasLon: $farmasLon, farmasHorario: $farmasHorario }';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pharma &&
        farmasId == other.farmasId &&
        farmasName == other.farmasName &&
        farmasLat == other.farmasLat &&
        farmasLon == other.farmasLon &&
        farmasHorario == other.farmasHorario;
  }

  @override
  int get hashCode {
    return farmasId.hashCode ^
        farmasName.hashCode ^
        farmasLat.hashCode ^
        farmasLon.hashCode ^
        farmasHorario.hashCode;
  }
}
