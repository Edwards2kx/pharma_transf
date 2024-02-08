import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/pages/widgets/transfer_card_widget.dart';
import 'package:provider/provider.dart';

class TransfPage extends StatefulWidget {
  const TransfPage({super.key});
  @override
  TransfPageState createState() => TransfPageState();
}

class TransfPageState extends State<TransfPage> {
  bool onlyNearPharma = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderTransferencias>(context, listen: true);

    final List<Transferencia> transferencias = provider.transfList;
    final currentPharma = provider.currentPharma;

    return RefreshIndicator(
      onRefresh: provider.updateTransferencias,
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
                    child: buildNearPharmaTransferList(
                        context, transferencias, currentPharma))
                : Expanded(child: buildFullTransferList(context, transferencias))
          ],
        ),
      ),
    );
  }

  buildNearPharmaTransferList(BuildContext context,
      List<Transferencia> transferencias, Pharma? currentPharma) {
    if (transferencias.isEmpty || currentPharma == null) {
      return const Center(child: Text('No estás cerca un punto de recogida'));
    }
    //obtengo de las transferencias las que estan en estado pendiente
    var tempListPickUp = transferencias
        .where((f) =>
            f.transfFarmaAcepta == currentPharma.farmasName &&
            f.estado == EstadoTransferencia.pendiente)
        .toList();
//obtengo de las transferencias las que estan en estado recogido
    var tempListDelivery = transferencias
        .where((f) =>
            f.transfFarmaSolicita == currentPharma.farmasName &&
            f.estado == EstadoTransferencia.recogido) //Aqui para pruebas
        .toList();

    if ((tempListPickUp.isEmpty) && (tempListDelivery.isEmpty)) {
      return const Center(
          child: Text('No estás cerca un punto de recogida o entrega'));
    }

    Widget groupPickUp() {
      return Expanded(
        child: Column(
          children: [
            const Text('PARA RECOGER', style: TextStyle(fontSize: 16.0)),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                  itemCount: tempListPickUp.length,
                  itemBuilder: (ctx, i) =>
                      TransferCard(transferencia: tempListPickUp[i])),
              //itemBuilder: (ctx, i) => _buildCard(tempListPickUp[i])),
            ),
            const Divider(),
            const SizedBox(height: 8.0),
          ],
        ),
      );
    }

    Widget groupDelivery() {
      return Expanded(
        child: Column(children: [
          const Text('PARA ENTREGAR', style: TextStyle(fontSize: 16.0)),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
                itemCount: tempListDelivery.length,
                itemBuilder: (ctx, i) =>
                    TransferCard(transferencia: tempListDelivery[i])),
            //itemBuilder: (ctx, i) => _buildCard(tempListDelivery[i])),
          ),
        ]),
      );
    }

    //lo que se devuelve en realidad
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (tempListPickUp.isNotEmpty) groupPickUp(),
        if (tempListDelivery.isNotEmpty) groupDelivery(),
      ],
    );

    // return Container(
    //   child: Text('Esta activo lo de la cercania'),
    // );
  }

  Widget buildFullTransferList(
      BuildContext context, List<Transferencia> transferencias) {
    List<Widget> cards = [];
    if (transferencias.isEmpty) {
      return const Center(child: Text('No hay datos'));
    }

    List<Transferencia> filteredListTransferencias = transferencias
        .where((f) => f.estado != EstadoTransferencia.entregado)
        .toList();

    filteredListTransferencias.forEach((t) {
      Widget tempWidget = TransferCard(transferencia: t);
      cards.add(tempWidget);
    });

    return ListView(
      children: cards,
    );
  }
}
