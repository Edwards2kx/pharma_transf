import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharma_transfer/models/pharma_model.dart';

const double kCardElevation = 2;

class PharmaCardWidget extends StatelessWidget {
  const PharmaCardWidget(
      {super.key, this.userLatitud, this.userLongitud, required this.farmacia});
  final double? userLatitud;
  final double? userLongitud;
  final Pharma farmacia;

  @override
  Widget build(BuildContext context) {
    String distanciaStr = 'Desconocida';
    if (userLatitud != null &&
        userLongitud != null &&
        farmacia.farmasLat != null &&
        farmacia.farmasLon != null) {
      final distancia = Geolocator.distanceBetween(userLatitud!, userLongitud!,
          farmacia.farmasLat!, farmacia.farmasLon!);
      debugPrint(
          'la distancia con la farmacia ${farmacia.farmasName} es de $distancia');
      // distancia.toInt()
      distanciaStr = distancia.toInt().toString();
      // .replaceAll('.0', '');
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        
        margin: EdgeInsets.zero,
        elevation: kCardElevation,
        // shape: RoundedRectangleBorder(
        //   borderRadius: const BorderRadius.all(Radius.circular(12)),
        //   side: BorderSide(color: Theme.of(context).colorScheme.outline),
        // ),
        shadowColor: null,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            leading: const Icon(Icons.gite_outlined),
            title: Text(
              farmacia.farmasName ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
                'Horario de atención: ${farmacia.farmasHorario ?? "Desconocido"} \nDistancia Aprox. (mts): $distanciaStr'),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }
}
