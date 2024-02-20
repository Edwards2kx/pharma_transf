// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'pharma_model.dart';

class PharmaInfo {

  final Pharma farmacia;
  final int productos;
  final double? distancia;

  PharmaInfo({required this.farmacia, required this.productos, this.distancia});

  PharmaInfo copyWith({
    Pharma? farmacia,
    int? productos,
    double? distancia,
  }) {
    return PharmaInfo(
      farmacia: farmacia ?? this.farmacia,
      productos: productos ?? this.productos,
      distancia: distancia ?? this.distancia,
    );
  }

  @override
  String toString() => 'PharmaInfo(farmacia: $farmacia, productos: $productos, distancia: $distancia)';
}
