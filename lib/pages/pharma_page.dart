import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/pages/widgets/pharma_card.dart';
// import 'package:location/location.dart';
import 'package:provider/provider.dart';

//import 'package:latlong2/latlong.dart';

//const double kDistanceMin = 5.0; //5 km distancia minima

class PharmaPage extends StatefulWidget {
  @override
  PharmaPageState createState() => PharmaPageState();
}

class PharmaPageState extends State<PharmaPage> {
  bool onlyClose = false;
  // Location location = Location();
  // double latitud;
  // double longitud;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderTransferencias>(context, listen: true);
    final userLatitud = provider.latitud;
    final userLongitud = provider.longitud;

    return RefreshIndicator(
        onRefresh: provider.updateTransferencias,
        child: _pharmaListCard(provider.transfList, provider.pharmaList,
                userLatitud, userLongitud) ??
            ListView(children: [
              Center(
                  child: Container(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: const Text('No se encontraron registros'))),
            ])

        // child: ListView.builder(
        //   itemCount: 10,
        //   itemBuilder: (BuildContext context, int index) {
        //     return ListTile(title: Text('listTile #$index'));
        //   },
        // ),
        );
  }

  Widget? _pharmaListCard(List<Transferencia> transferencias,
      List<Pharma> farmacias, double? userLatitud, double? userLongitud) {
    Set<Pharma> farmasParaEntregar = {};
    Set<Pharma> farmasParaRecoger = {};

    // Widget cards(Pharma farmacia) {
    //   String distanciaStr = '-distancia-';
    //   if (userLatitud != null &&
    //       userLongitud != null &&
    //       farmacia.farmasLat != null &&
    //       farmacia.farmasLon != null) {
    //     final distancia = Geolocator.distanceBetween(userLatitud, userLongitud,
    //         farmacia.farmasLat!, farmacia.farmasLon!);
    //         distanciaStr = distancia.toString().replaceAll('.0', '');
    //   }
    //   return Card(
    //     child: ListTile(
    //       title: Row(
    //         children: [
    //           Text(farmacia.farmasName ?? ''),
    //         ],
    //       ),
    //       subtitle: Text(
    //           'Horario de atención: ${farmacia.farmasHorario} \nDistancia Aprox: $distanciaStr Metros'),
    //       isThreeLine: true,
    //     ),
    //   );
    // }

    if (transferencias.isEmpty) return null;
    // return Container(
    //   child: Center(child: Text('No hay transferencias pendientes')),
    // );

    List<Pharma> listaFarmacias = farmacias;
    transferencias.forEach((transferencia) {
      final nameSolicita = transferencia.transfFarmaSolicita;
      final nameEnvia = transferencia.transfFarmaAcepta;
      final estado = transferencia.estado;
      // if (estado == null) estado = transferencia.estadoTransferencia();
      if (estado != EstadoTransferencia.entregado) {
        listaFarmacias.forEach((farmacia) {
          //se se muestran todos /// ignorar los que ya están corregidos.
          if (farmacia.farmasName == nameSolicita &&
              estado == EstadoTransferencia.recogido) {
            farmasParaEntregar.add(farmacia);
          }
          if (farmacia.farmasName == nameEnvia &&
              estado == EstadoTransferencia.pendiente) {
            farmasParaRecoger.add(farmacia);
          }
        });
      }
    });

    List<Pharma> farmasParaEntregarinList = farmasParaEntregar.toList();
    List<Pharma> farmasParaRecogerinList = farmasParaRecoger.toList();

    debugPrint('farmacias para recoger $farmasParaRecogerinList');
    debugPrint('farmacias para entregar $farmasParaRecogerinList');

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text('Farmacias para recoger (${farmasParaRecogerinList.length})',
              style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87)),
          const SizedBox(height: 8.0),
          Expanded(
            //Scrollbar
            child: ListView.builder(
              itemCount: farmasParaRecogerinList.length,
              itemBuilder: (BuildContext context, int index) {
                return PharmaCard(
                  farmacia: farmasParaRecogerinList[index],
                  userLatitud: userLatitud,
                  userLongitud: userLongitud,
                );
              },
            ),
          ),
          const Divider(),
          Text('Farmacias para entregar (${farmasParaEntregarinList.length})',
              style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87)),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: farmasParaEntregarinList.length,
              itemBuilder: (BuildContext context, int index) {
                return PharmaCard(
                  farmacia: farmasParaEntregarinList[index],
                  userLatitud: userLatitud,
                  userLongitud: userLongitud,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
