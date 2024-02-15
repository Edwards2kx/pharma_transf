// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pharma_transfer/presentation/providers/provider_transferencias.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/recibo_model.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/widgets/recibo_resumen_widget.dart';
import 'package:pharma_transfer/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ResultSheetWidget extends StatelessWidget {
  final Uint8List? image;

  const ResultSheetWidget({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    // final imageToProcess = image;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            'Resumen',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          // buildImageCard(imageToProcess),
          buildImageCard(image),
          const SizedBox(height: 16),
          _resultFromDecoding(context, image)
        ],
      ),
    );
  }

  FutureBuilder<Either<String, Recibo>> _resultFromDecoding(
      BuildContext context, Uint8List? imageToProcess) {
    final provider =
        Provider.of<ProviderTransferencias>(context, listen: false);
    return FutureBuilder<Either<String, Recibo>>(
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
                ReciboResumenWidget(recibo: response.right),
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
          debugPrint('error en el future ResultSheetWidget ${snapshoot.error}');
          return const Center(
            child: Text('Se presentó un error, intenta nuevamente'),
          );
        }
        // return const Center(child: CircularProgressIndicator());
        return Lottie.asset('assets/scanning_text.json',
            width: MediaQuery.of(context).size.width * 0.6);
      },
    );
  }

  Widget buildImageCard(Uint8List? image) {
    if (image == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(elevation: 2.0, child: Image.memory(image)),
      // child: Card(elevation: 2.0, child: Image(image: MemoryImage(image),),)
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
                String message = '';
                message = response
                    ? 'Registro exitoso'
                    : 'Se presento un error, intenta nuevamente';
                Navigator.of(context).popUntil((route) => route.isFirst);
                ScaffoldMessenger.of(context)
                    .showSnackBar(customSnackBar(context, message:message));
                context
                    .read<ProviderTransferencias>()
                    .fetchTransferenciasActivas();
              },
            ),
          ],
        );
      });
}
