import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/recibo_model.dart';
import 'package:pharma_transfer/pages/widgets/recibo_resumen_reduce_widget.dart';
import 'package:provider/provider.dart';

class ResultSheetWidget extends StatelessWidget {
  final Uint8List? image;

  const ResultSheetWidget({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<ProviderTransferencias>(context, listen: false);
    final imageToProcess = image;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          const SizedBox(height: 16),
          Text('Resumen', style: Theme.of(context).textTheme.titleLarge,),
          const SizedBox(height: 8),
          buildImageCard(imageToProcess),
          const SizedBox(height: 16),
          FutureBuilder<Either<String, Recibo>>(
            future: provider.procesarImagenRecibo(imageToProcess),
            builder: (context, snapshoot) {
              if (snapshoot.hasData) {
                final response = snapshoot.data!;
                //Error en lectura
                if (response.isLeft) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(response.left),
                    ),
                  );
                }
                //lectura correcta
                else if (response.isRight) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ReciboResumenReduce(recibo: response.right),
                      Align(
                        alignment: Alignment.center,
                        child: FilledButton(
                          onPressed: () async {
                            await _showConfirmation(context, response.right);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Registrar Información'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  );
                }
                return Container();
              } else if (snapshoot.hasError) {
                debugPrint(
                    'error en el future ResultSheetWidget ${snapshoot.error}');
                return const Center(
                  child: Text('Se presentó un error, intenta nuevamente'),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }

  Widget buildImageCard(Uint8List? image) {
    if (image == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(elevation: 2.0, child: Image.memory(image)),
    );
  }
}

Future<void> _showConfirmation(BuildContext context, Recibo recibo) async {
  await showDialog(
      context: context,
      builder: (_) {
        final contenido =
            "Fecha: ${recibo.fecha}\nNoTransferencia: ${recibo.numeroTransferencia}\nusuSoliTransf: ${recibo.usuSoliTransf}\nfarSoliTransf: ${recibo.farSoliTransf}\nusuAutoTransf: ${recibo.usuAutoTransf}\nfarAutoTransf: ${recibo.farAutoTransf}";
        return AlertDialog(
          title: const Center(child: Text('Registro')),
          content: Text(
              '¿Deseas registar la información como aparece en el resumen?\n\n$contenido'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.pop(context),
            ),
            FilledButton.tonal(
              child: const Text('Si'),
              onPressed: () async {
                final response = await pushTransferencia(recibo);
//TODO: mejorar este snackbar
                final snackBar = SnackBar(
                  content: Text(response
                      ? 'Registro exitoso'
                      : 'Se presento un error, intenta nuevamente'),
                );
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      });
}
