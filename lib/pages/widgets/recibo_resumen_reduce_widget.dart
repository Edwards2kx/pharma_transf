import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/recibo_model.dart';

const TextStyle textStyleValue = TextStyle(
    fontSize: 16.0, color: Colors.black87, fontWeight: FontWeight.w500);

const TextStyle textStyleLabel = TextStyle(
    fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.w300);

class ReciboResumenReduce extends StatelessWidget {
  final Recibo recibo;
  const ReciboResumenReduce({super.key, required this.recibo});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.labelLarge;
    return Container(
      width: double.infinity,
      // height: 200,
      padding: const EdgeInsets.all(8.0),

      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fecha: ${recibo.fecha}', style: textTheme),
              Text('numeroTransferencia: ${recibo.numeroTransferencia}',
                  style: textTheme),
              Text('usuSoliTransf: ${recibo.usuSoliTransf}', style: textTheme),
              Text('farSoliTransf: ${recibo.farSoliTransf}', style: textTheme),
              Text('usuSoliTransf: ${recibo.usuSoliTransf}', style: textTheme),
              Text('farSoliTransf: ${recibo.farSoliTransf}', style: textTheme),
              Text('usuAutoTransf: ${recibo.usuAutoTransf}', style: textTheme),
              Text('farAutoTransf: ${recibo.farAutoTransf}', style: textTheme),
              const Divider(),
              ...recibo.producto
                  .map((e) => Text(
                      'Producto ${e.nombre} \n Ent: ${e.ent} Frac: ${e.frac}'))
                  .toList(),
              ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                              title: const Text('Registrar información?'),
                              actions: [
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text('Si'),
                                  onPressed: () async {
                                    final response =
                                        await pushTransferencia(recibo);
                                    // final response = true;

                                    final snackBar = SnackBar(
                                      content: Text(response
                                          ? 'Registro exitoso'
                                          : 'Se presento un error, intenta nuevamente'),
                                    );
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                ),
                              ]);
                        });
                  },
                  child: const Center(
                      child: Text(
                    'Subir Información',
                  )))
            ],
          ),
        ),
      ),
    );
  }
}
