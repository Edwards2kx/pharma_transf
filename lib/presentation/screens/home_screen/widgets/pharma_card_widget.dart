import 'package:flutter/material.dart';
import 'package:pharma_transfer/models/pharma_info_model.dart';
import 'package:pharma_transfer/models/pharma_model.dart';

const double kCardElevation = 0;

class PharmaCardWidget extends StatelessWidget {
  const PharmaCardWidget(
      {super.key, required this.pharmaInfo});
  // final double? userLatitud;
  // final double? userLongitud;
  // final Pharma farmacia;
  final PharmaInfo pharmaInfo;

  @override
  Widget build(BuildContext context) {
      final Pharma farmacia = pharmaInfo.farmacia;
      // debugPrint('Farmacia: ${farmacia.farmasName}\nFarmacia lat: ${farmacia.farmasLat}\nFarmacia lon: ${farmacia.farmasLat}\n');
      // debugPrint('Mi ubicacion lat:$userLatitud, lon:$userLongitud');
    String distanciaStr = pharmaInfo.distancia != null ? pharmaInfo.distancia!.toInt().toString() :'Desconocida';

    // if (userLatitud != null &&
    //     userLongitud != null &&
    //     farmacia.farmasLat != null &&
    //     farmacia.farmasLon != null) {
    //   final distancia = Geolocator.distanceBetween(userLatitud!, userLongitud!,
    //       farmacia.farmasLat!, farmacia.farmasLon!);
    //   debugPrint(
    //       'la distancia con la farmacia ${farmacia.farmasName} es de $distancia');
    //   // distancia.toInt()
    //   distanciaStr = distancia.toInt().toString();
    //   // .replaceAll('.0', '');
    // }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        
        margin: EdgeInsets.zero,
        elevation: kCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        shadowColor: null,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            // contentPadding: EdgeInsets.all(8),
            // leading: const Icon(Icons.gite_outlined),
            trailing: CircleAvatar(child: Text(pharmaInfo.productos.toString().padLeft(2,'0'))),
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
