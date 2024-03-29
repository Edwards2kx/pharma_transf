import 'package:flutter/material.dart';
import 'package:pharma_transfer/presentation/providers/provider_transferencias.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/widgets/pharma_card_widget.dart';
import 'package:provider/provider.dart';

class PharmaPage extends StatefulWidget {
  const PharmaPage({super.key});
  @override
  PharmaPageState createState() => PharmaPageState();
}

class PharmaPageState extends State<PharmaPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = Provider.of<ProviderTransferencias>(context, listen: true);
    final farmasConEvento = provider.getFarmaciasConEventos.toList();
    // final farmasToPickUp = provider.getFarmaciasParaRecoger.toList();
    // final farmasToDelivery = provider.getFarmaciasParaEntregar.toList();
    // final farmasToPickUp = provider.getFarmaciasParaRecoger.toList();

    return RefreshIndicator(
      onRefresh: () async {
        await provider.updateNearPharma();
        return provider.fetchTransferenciasActivas();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: ListView(
          children: [
            Row(
              children: [
                const Text('Productos: '),
                const Text('Para recoger  '),
                Icon(Icons.circle,
                    color: Theme.of(context).colorScheme.primaryContainer),
                const Text('  Para Entregar  '),
                Icon(Icons.circle,
                    color: Theme.of(context).colorScheme.outlineVariant)
              ],
            ),
            // if (farmasToDelivery.isNotEmpty)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Farmacias para entregar (${farmasToDelivery.length})',
            //         style: Theme.of(context)
            //             .textTheme
            //             .headlineSmall
            //             ?.copyWith(fontWeight: FontWeight.w300),
            //       ),
            //       const SizedBox(height: 8.0),
            //       ...farmasToDelivery
            //           .map((f) => PharmaCardWidget(pharmaInfo: f)),
            //       const Divider(),
            //     ],
            //   ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       'Farmacias para recoger (${farmasToPickUp.length})',
            //       style: Theme.of(context)
            //           .textTheme
            //           .headlineSmall
            //           ?.copyWith(fontWeight: FontWeight.w300),
            //     ),
            //     const SizedBox(height: 8.0),
            //     ...farmasToPickUp.map((f) => PharmaCardWidget(pharmaInfo: f)),
            //   ],
            // ),
            const SizedBox(height: 8.0),
            ...farmasConEvento.map((f) => PharmaCardWidget(pharmaInfo: f)),

            const SizedBox(height: 64.0),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
