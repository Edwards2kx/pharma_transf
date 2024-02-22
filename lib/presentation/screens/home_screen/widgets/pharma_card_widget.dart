import 'package:flutter/material.dart';
import 'package:pharma_transfer/models/pharma_info_model.dart';
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/presentation/providers/provider_transferencias.dart';
import 'package:provider/provider.dart';
import 'transfer_card_widget.dart';

const double kCardElevation = 0;

class PharmaCardWidget extends StatelessWidget {
  const PharmaCardWidget({super.key, required this.pharmaInfo});
  final PharmaInfo pharmaInfo;

  @override
  Widget build(BuildContext context) {
    final Pharma farmacia = pharmaInfo.farmacia;
    String distanciaStr = pharmaInfo.distancia != null
        ? pharmaInfo.distancia!.toInt().toString()
        : 'Desconocida';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              showDragHandle: true,
              context: context,
              builder: (context) {
                final transferencias = context
                    .read<ProviderTransferencias>()
                    .getTransferenciasActivas;
                final tFiltradas = transferencias
                    .where((t) => (t.transfFarmaAcepta == farmacia.farmasName ||
                        t.transfFarmaSolicita == farmacia.farmasName))
                    .toList();
                return ListView.builder(
                    itemCount: tFiltradas.length,
                    itemBuilder: (_, i) {
                      return TransferCard(transferencia: tFiltradas[i]);
                    });
              });
        },
        child: Card(
          margin: EdgeInsets.zero,
          elevation: kCardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: ListTile(
                    title: Text(
                      farmacia.farmasName ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                        'Horario de atención: ${farmacia.farmasHorario ?? "Desconocido"} \nDistancia Aprox. (mts): $distanciaStr'),
                    isThreeLine: true,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: // contentPadding: EdgeInsets.all(8),
                      // leading: const Icon(Icons.gite_outlined),
                      // trailing:
                      Column(
                    children: [
                      // if (pharmaInfo.prodRecoger > 0)
                      CircleAvatar(
                          // radius: 16,
                          child: Text(pharmaInfo.prodRecoger
                              .toString()
                              .padLeft(2, '0'))),
                      const SizedBox(height: 4),
                      // if (pharmaInfo.prodEntregar > 0)
                      CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.outlineVariant,
                          // radius: 16,
                          child: Text(pharmaInfo.prodEntregar
                              .toString()
                              .padLeft(2, '0'))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
