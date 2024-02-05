import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/pages/widgets/recibo_resumen_widget.dart';
import 'package:provider/provider.dart';

class TransferCard extends StatefulWidget {
  final Transferencia transferencia;

  const TransferCard({Key? key, required this.transferencia}) : super(key: key);

  @override
  TransferCardState createState() => TransferCardState();
}

class TransferCardState extends State<TransferCard> {
  @override
  Widget build(BuildContext context) {
    Transferencia transferencia = widget.transferencia;

    // var _estadoTransferencia = transferencia.estadoTransferencia();
    var estadoTransferencia = transferencia.estado;
    String estado;
    Color color;
    String accion;
    DateTime fechaHora = transferencia.transfDateGenerado!;
    debugPrint(transferencia.toString());

    switch (estadoTransferencia) {
      case EstadoTransferencia.pendiente:
        estado = 'Pendiente';
        color = Colors.red;
        accion = 'Recogido?';
        break;
      case EstadoTransferencia.recogido:
        estado = 'Recogido';
        color = Colors.yellow;
        accion = 'Entregado?';
        break;
      case EstadoTransferencia.entregado:
        estado = 'Entregado';
        color = Colors.green;
        accion = 'Terminado';
        break;
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Farma solicita'),
                      Text('Farma acepta'),
                      Text('User acepta'),
                      Text('Fecha y Hora'),
                    ]),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transferencia.transfFarmaSolicita ?? '',
                          overflow: TextOverflow.ellipsis),
                      Text(transferencia.transfFarmaAcepta ?? '',
                          overflow: TextOverflow.ellipsis),
                      Text(transferencia.transfUsrAcepta ?? '',
                          overflow: TextOverflow.ellipsis),
                      Text(
                          '${fechaHora.day.toString().padLeft(2, '0')}/${fechaHora.month.toString().padLeft(2, '0')}/${fechaHora.year} - ${fechaHora.hour.toString().padLeft(2, '0')}:${fechaHora.minute.toString().padLeft(2, '0')}'),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(transferencia.transfProducto?? '', style: textStyleValue),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Ent. ${transferencia.transfCantidadEntera}',
                  style: textStyleValue),
              const Text('  -   ', style: textStyleValue),
              Text('Frac. ${transferencia.transfCantidadFraccion}',
                  style: textStyleValue)
            ]),
            const Divider(),
            Row(
              children: [
                MaterialButton(
                  onPressed: () async {
                    if (estadoTransferencia != EstadoTransferencia.entregado) {
                      await _changeTransfState(transferencia);
                    }
                  },
//                    shape: StadiumBorder(),
                  shape: const RoundedRectangleBorder(),
                  color: Colors.white,
                  elevation: 8.0,
                  child: Text(accion),
                ),
                Expanded(
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Estado:   $estado    '),
                    Icon(Icons.circle, color: color)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _changeTransfState(Transferencia transferencia) async {
    final provider =
        Provider.of<ProviderTransferencias>(context, listen: false);
    final user = provider.currentUser;

    // var _estadoTransferencia = transferencia.estadoTransferencia();
    var estadoTransferencia = transferencia.estado;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('¿Quieres cambiar el estado de la transferencia?'),
            actions: [
              MaterialButton(
                  onPressed: () => Navigator.pop(context), child: Text('No')),
              MaterialButton(
                  onPressed: () async {
                    if (estadoTransferencia == EstadoTransferencia.pendiente) {
                      await updateTransfRetiro(transferencia, user!.usersEmail);
                    }

                    if (estadoTransferencia == EstadoTransferencia.recogido) {
                      await updateTransfEntrega(transferencia, user!.usersEmail);
                    }
                    provider.updateTransferencias();

                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Si')),
            ],
          );
        });
  }
}
