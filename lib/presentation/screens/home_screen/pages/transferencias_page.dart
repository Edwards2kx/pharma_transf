import 'package:flutter/material.dart';
import 'package:pharma_transfer/presentation/providers/provider_transferencias.dart';
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/widgets/transfer_card_widget.dart';
import 'package:provider/provider.dart';

class TransferenciasPage extends StatefulWidget {
  const TransferenciasPage({super.key});
  @override
  TransferenciasPageState createState() => TransferenciasPageState();
}

class TransferenciasPageState extends State<TransferenciasPage>
    with AutomaticKeepAliveClientMixin {
  bool onlyNearPharma = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = Provider.of<ProviderTransferencias>(context, listen: true);

    final List<Transferencia> transferencias =
        provider.getTransferenciasActivas;
    final currentPharma = provider.getFarmaciaCercana;

    return RefreshIndicator(
      // onRefresh: provider.fetchTransferenciasActivas,
      onRefresh: () async {
        await provider.updateNearPharma();
        return provider.fetchTransferenciasActivas();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const Text(
              'Transferencias pendientes',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8.0),
            SwitchListTile(
                title: currentPharma != null
                    ? Text('Solo farmacia actual \n${currentPharma.farmasName}')
                    : const Text('Solo farmacia actual'),
                value: onlyNearPharma,
                onChanged: (v) {
                  setState(() {
                    onlyNearPharma = v;
                  });
                }),
            onlyNearPharma
                ? Expanded(
                    // child: buildNearPharmaTransferList(
                    //     context, transferencias, currentPharma))
                    child: buildFilteredTransferList(
                        transferencias, currentPharma),
                  )
                : Expanded(child: buildFullTransferList(transferencias))
          ],
        ),
      ),
    );
  }

  Widget buildFullTransferList(List<Transferencia> transferencias) {
    List<Widget> cards = [];
    if (transferencias.isEmpty) {
      return const Center(child: Text('No hay transferencias activas'));
    }

    List<Transferencia> filteredListTransferencias = transferencias
        .where((f) => f.estado != EstadoTransferencia.entregado)
        .toList();

    for (var t in filteredListTransferencias) {
      Widget tempWidget = TransferCard(transferencia: t);
      cards.add(tempWidget);
    }
    return ListView(children: cards);
  }

  Widget buildFilteredTransferList(
      List<Transferencia> transferencias, Pharma? currentPharma) {
    List<Widget> cards = [];
    if (transferencias.isEmpty) {
      return const Center(child: Text('No hay transferencias activas'));
    }

    List<Transferencia> filteredListTransferencias = transferencias
        .where((f) =>
            f.estado == EstadoTransferencia.pendiente &&
                (f.transfFarmaAcepta == currentPharma?.farmasName) ||
            f.estado == EstadoTransferencia.recogido &&
                (f.transfFarmaSolicita == currentPharma?.farmasName))
        .toList();

    if (filteredListTransferencias.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: ListView(children: [
            const SizedBox(height: 32),
            const Icon(
              Icons.location_off_outlined,
              size: 64,
              color: Colors.black45,
            ),
            const SizedBox(height: 32),
            Text(
              'No hay elementos para recoger o entregar en la ubicación actual.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            )
          ]),
        ),
      );
    }

    for (var t in filteredListTransferencias) {
      Widget tempWidget = TransferCard(transferencia: t);
      cards.add(tempWidget);
    }
    return ListView(children: cards);
  }

  @override
  bool get wantKeepAlive => true;
}
