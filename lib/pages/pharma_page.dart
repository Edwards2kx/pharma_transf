import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/pages/widgets/pharma_card.dart';
import 'package:provider/provider.dart';

//const double kDistanceMin = 5.0; //5 km distancia minima

class PharmaPage extends StatefulWidget {
  const PharmaPage({super.key});
  @override
  PharmaPageState createState() => PharmaPageState();
}

class PharmaPageState extends State<PharmaPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderTransferencias>(context, listen: true);
    final userLatitud = provider.latitud;
    final userLongitud = provider.longitud;
    List<Pharma> farmasToDelivery = provider.getFarmaciasParaEntregar.toList();
    List<Pharma> farmasToPickUp = provider.getFarmaciasParaRecoger.toList();
    return RefreshIndicator(
      onRefresh: provider.fetchTransferenciasActivas,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: ListView(
          children: [
            if (farmasToDelivery.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Farmacias para entregar (${farmasToDelivery.length})',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 8.0),
                  ...farmasToDelivery.map(
                    (f) => PharmaCard(
                        farmacia: f,
                        userLatitud: userLongitud,
                        userLongitud: userLatitud),
                  ),
                  const Divider(),
                ],
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Farmacias para recoger (${farmasToPickUp.length})',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 8.0),
                ...farmasToPickUp.map(
                  (f) => PharmaCard(
                    farmacia: f,
                    userLatitud: userLongitud,
                    userLongitud: userLatitud,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48.0),
          ],
        ),
      ),
    );
  }
}

// ListView.builder(
//   itemCount: farmasToPickUp.length,
//   itemBuilder: (BuildContext context, int index) {
//     return PharmaCard(
//       farmacia: farmasToPickUp[index],
//       userLatitud: userLatitud,
//       userLongitud: userLongitud,
//     );
//   },
// ),

// ListView.builder(
//   itemCount: farmasToDelivery.length,
//   itemBuilder: (BuildContext context, int index) {
//     return PharmaCard(
//       farmacia: farmasToDelivery[index],
//       userLatitud: userLatitud,
//       userLongitud: userLongitud,
//     );
//   },
// ),