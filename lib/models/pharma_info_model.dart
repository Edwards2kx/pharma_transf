// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'pharma_model.dart';

class PharmaInfo {
  final Pharma farmacia;
  final int prodRecoger;
  final int prodEntregar;
  final int prodRecogidoUsuario;
  final double? distancia;

  PharmaInfo(
      {required this.prodRecogidoUsuario,
      required this.farmacia,
      required this.prodRecoger,
      required this.prodEntregar,
      this.distancia});

  PharmaInfo copyWith({
    Pharma? farmacia,
    int? prodRecoger,
    int? prodEntregar,
    int? prodRecogidoUsuario,
    double? distancia,
  }) {
    return PharmaInfo(
      farmacia: farmacia ?? this.farmacia,
      prodRecoger: prodRecoger ?? this.prodRecoger,
      prodEntregar: prodEntregar ?? this.prodEntregar,
      prodRecogidoUsuario: prodRecogidoUsuario ?? this.prodRecogidoUsuario,
      distancia: distancia ?? this.distancia,
    );
  }

  @override
  String toString() =>
      'PharmaInfo(farmacia: $farmacia, productos: $prodRecoger, distancia: $distancia)';
}
