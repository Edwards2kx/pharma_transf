import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharma_transfer/models/pharma_model.dart';

class PharmaCard extends StatelessWidget {

  const PharmaCard({super.key, this.userLatitud, this.userLongitud, required this.farmacia});
final double? userLatitud;
final double? userLongitud;
final Pharma farmacia;
 

  @override
  Widget build(BuildContext context) {
    String distanciaStr = '';
       if (userLatitud != null &&
          userLongitud != null &&
          farmacia.farmasLat != null &&
          farmacia.farmasLon != null) {
        final distancia = Geolocator.distanceBetween(userLatitud!, userLongitud!,
            farmacia.farmasLat!, farmacia.farmasLon!);
            debugPrint('la distancia con la farmacia ${farmacia.farmasName} es de $distancia');
            // distancia.toInt()
            distanciaStr = distancia.toInt().toString();
            // .replaceAll('.0', '');
      }
      return Card(
        child: ListTile(
          title: Row(
            children: [
              Text(farmacia.farmasName ?? ''),
            ],
          ),
          subtitle: Text(
              'Horario de atención: ${farmacia.farmasHorario} \nDistancia Aprox: $distanciaStr Metros'),
          isThreeLine: true,
        ),
      );
  }
}