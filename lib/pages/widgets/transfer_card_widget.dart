// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/pages/widgets/recibo_resumen_widget.dart';
import 'package:provider/provider.dart';

//TODO: convertir a stateless widget
class TransferCard extends StatefulWidget {
  final Transferencia transferencia;

  const TransferCard({Key? key, required this.transferencia}) : super(key: key);

  @override
  TransferCardState createState() => TransferCardState();
}

class TransferCardState extends State<TransferCard> {
  Color colorByStatus() =>
      widget.transferencia.estado == EstadoTransferencia.pendiente
          ? Colors.red
          : widget.transferencia.estado == EstadoTransferencia.recogido
              ? Colors.yellow
              : Colors.green;

  // Color colorByStatus(EstadoTransferencia estado) {
  //   if (estado == EstadoTransferencia.pendiente) return Colors.red;
  //   if (estado == EstadoTransferencia.recogido) return Colors.yellow;
  //   return Colors.green;
  // }

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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Farma solicita'),
                  const Text('Farma acepta'),
                  const Text('User acepta'),
                  const Text('Fecha y Hora'),
                  if (transferencia.estado != EstadoTransferencia.pendiente)
                    const Text('Recogido por'),
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
                      if (transferencia.estado != EstadoTransferencia.pendiente)
                        Text(transferencia.usuarioRecoge ?? ''),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(transferencia.transfProducto ?? '', style: textStyleValue),
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
                if (transferencia.estado != EstadoTransferencia.entregado)
                  FilledButton(
                    onPressed: () async {
                      if (estadoTransferencia !=
                          EstadoTransferencia.entregado) {
                        await _changeTransfState(transferencia);
                      }
                    },
                    child: Text(accion),
                  ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Estado:   $estado    '),
                    // Icon(Icons.circle, color: color)
                    Icon(Icons.circle, color: colorByStatus())
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
    var estadoTransferencia = transferencia.estado;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Cambiar estado'),
            content:
                const Text('¿Quieres cambiar el estado de la transferencia?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                  onPressed: () async {
                    context.loaderOverlay.show();
                    //TODO: visualizar los errores en las vistas
                    if (estadoTransferencia == EstadoTransferencia.pendiente) {
                      await provider.updateTransfRetiro(transferencia);
                    }
                    if (estadoTransferencia == EstadoTransferencia.recogido) {
                      await provider.updateTransfEntrega(transferencia);
                    }
                    await provider.fetchTransferenciasActivas();
                    context.loaderOverlay.hide();
                    Navigator.pop(context);
                  },
                  child: const Text('Si')),
            ],
          );
        });
  }
}

//   if (estadoTransferencia == EstadoTransferencia.pendiente) {
                  //     context.loaderOverlay.show();
                  //     await updateTransfRetiro(transferencia, user!.usersEmail);
                  //     // context.loaderOverlay.hide();
                  //   }

                  //   if (estadoTransferencia == EstadoTransferencia.recogido) {
                  //     context.loaderOverlay.show();
                  //     await updateTransfEntrega(
                  //         transferencia, user!.usersEmail);
                  //     // context.loaderOverlay.hide();
                  //   }
                  //   await provider.updateTransferencias();
                  //   context.loaderOverlay.hide();

                  //   Navigator.pop(context);
                  //   setState(() {}); //TOD