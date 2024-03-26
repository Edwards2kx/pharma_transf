import 'package:flutter/material.dart';
import 'package:pharma_transfer/models/pharma_info_model.dart';
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
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
          //TODO: MEJORAR EL FILTRADO SEGúN ESPECIFICACIóN
          showModalBottomSheet(
              // showDragHandle: true,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                final transferencias = context
                    .read<ProviderTransferencias>()
                    .getTransferenciasActivas;
                // final tFiltradas = transferencias
                //     .where((t) => (t.transfFarmaAcepta == farmacia.farmasName ||
                //         t.transfFarmaSolicita == farmacia.farmasName))
                //     .toList();

                final tFiltradas = transferencias
                    .where((t) => (t.transfFarmaAcepta == farmacia.farmasName ||
                        (t.estado == EstadoTransferencia.recogido &&
                            t.transfFarmaSolicita == farmacia.farmasName)))
                    .toList();
                return PharmaListWidget(pharmaInfo, transferencias);
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
                          child: Text((pharmaInfo.prodEntregar +
                                  pharmaInfo.prodRecogidoUsuario)
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

enum Filtro { recoger, entregar, todo }

class PharmaListWidget extends StatefulWidget {
  final PharmaInfo pharmaInfo;
  final List<Transferencia> transferencias;
  const PharmaListWidget(this.pharmaInfo, this.transferencias, {super.key});

  @override
  State<PharmaListWidget> createState() => _PharmaListWidgetState();
}

class _PharmaListWidgetState extends State<PharmaListWidget> {
  Filtro filtroSeleccionado = Filtro.recoger;

  @override
  Widget build(BuildContext context) {
    final farmacia = widget.pharmaInfo.farmacia;
    final transferencias = widget.transferencias;
    final tFiltradas = transferencias
        .where((t) => (t.transfFarmaAcepta == farmacia.farmasName ||
            (t.estado == EstadoTransferencia.recogido &&
                t.transfFarmaSolicita == farmacia.farmasName)))
        .toList();

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 56),
            Text(farmacia.farmasName ?? '',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SegmentedButton(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: Filtro.recoger, label: Text('Recoger')),
                ButtonSegment(value: Filtro.entregar, label: Text('Entregar')),
                ButtonSegment(value: Filtro.todo, label: Text('Todas')),
              ],
              selected: {filtroSeleccionado},
              onSelectionChanged: (v) =>
                  setState(() => filtroSeleccionado = v.first),
            ),

            //  final tFiltradas = transferencias
            //         .where((t) => (t.transfFarmaAcepta == farmacia.farmasName ||
            //             (t.estado == EstadoTransferencia.recogido &&
            //                 t.transfFarmaSolicita == farmacia.farmasName)))
            //         .toList();
            //     return PharmaListWidget(pharmaInfo, transferencias);
            //     return ListView.builder(
            //         itemCount: tFiltradas.length,
            //         itemBuilder: (_, i) {
            //           return TransferCard(transferencia: tFiltradas[i]);
            //         });
            const SizedBox(height: 16),
            Expanded(
              child: _buildTransferList(tFiltradas),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferList(List<Transferencia> transferencias) {
    // Widget _buildTransferList() {

    var tList = transferencias;
    var emptyMsg = 'No se encontraron transferencias.';
    switch (filtroSeleccionado) {
      case Filtro.recoger:
        tList = transferencias
            .where((t) => (t.estado == EstadoTransferencia.pendiente))
            .toList();
        emptyMsg = 'No hay elementos para recoger.';
        break;
      case Filtro.entregar:
        tList = transferencias
            .where((t) => (t.estado == EstadoTransferencia.recogido))
            .toList();
        emptyMsg = 'No tienes elementos para entregar.';
        break;
      case Filtro.todo:
        break;
    }

    return tList.isNotEmpty
        ? ListView.builder(
            itemCount: tList.length,
            itemBuilder: (_, i) {
              return TransferCard(transferencia: tList[i]);
            })
        : SizedBox(
            child: Center(
              child: Text(emptyMsg),
            ),
          );
  }
}
