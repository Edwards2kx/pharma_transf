// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Producto {

  final String nombre;
  final int ent;
  final int frac;

  Producto({required this.nombre, required this.ent, required this.frac});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nombre': nombre,
      'ent': ent,
      'frac': frac,
    };
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      nombre: map['nombre'] as String,
      ent: map['ent'] as int,
      frac: map['frac'] as int,
    );
  }
  // factory Producto.fromMap(Map<String, dynamic> map) {
  //   return Producto(
  //     nombre: map['NOMBRE'] as String,
  //     ent: map['ENT'] as int,
  //     frac: map['FRAC'] as int,
  //   );
  // }

  String toJson() => json.encode(toMap());

  factory Producto.fromJson(String source) => Producto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Producto(nombre: $nombre, ent: $ent, frac: $frac)';
}
