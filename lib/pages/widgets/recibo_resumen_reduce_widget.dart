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
              Text('NoTransferencia: ${recibo.numeroTransferencia}',
                  style: textTheme),
              Text('usuSoliTransf: ${recibo.usuSoliTransf}', style: textTheme),
              Text('farSoliTransf: ${recibo.farSoliTransf}', style: textTheme),
              Text('usuAutoTransf: ${recibo.usuAutoTransf}', style: textTheme),
              Text('farAutoTransf: ${recibo.farAutoTransf}', style: textTheme),
              const Divider(),
              ...recibo.producto
                  .map((e) => Text(
                      'Producto ${e.nombre} \n Ent: ${e.ent} Frac: ${e.frac}'))
                  .toList(),
              // Align(
              //   alignment: Alignment.center,
              //   child: FilledButton(
              //       onPressed: () async {
              //         await _showConfirmation(context);
              //       },
              //       child: const Padding(
              //         padding: EdgeInsets.all(8.0),
              //         child: Text('Registrar Información'),
              //       )),
              // )
            ],
          ),
        ),
      ),
    );
  }

//   Future<void> _showConfirmation(BuildContext context) async {
//     await showDialog(
//         context: context,
//         builder: (_) {
//           final contenido =
//               "Fecha: ${recibo.fecha}\nNoTransferencia: ${recibo.numeroTransferencia}\nusuSoliTransf: ${recibo.usuSoliTransf}\nfarSoliTransf: ${recibo.farSoliTransf}\nusuAutoTransf: ${recibo.usuAutoTransf}\nfarAutoTransf: ${recibo.farAutoTransf}";
//           return AlertDialog(
//               title: const Center(child: Text('Registro')),
//               content: Text(
//                   '¿Deseas registar la información como aparece en el resumen?\n\n$contenido'),
//               // backgroundColor: Colors.grey.shade100,
//               actions: [
//                 TextButton(
//                   child: const Text('No'),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 FilledButton(
//                   child: const Text('Si'),
//                   onPressed: () async {
//                     final response = await pushTransferencia(recibo);
// //TODO: mejorar este snackbar
//                     final snackBar = SnackBar(
//                       content: Text(response
//                           ? 'Registro exitoso'
//                           : 'Se presento un error, intenta nuevamente'),
//                     );
//                     Navigator.pop(context);
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                   },
//                 ),
//               ]);
//         });
//   }
}
