// import 'package:flutter/material.dart';
// import 'package:pharma_transfer/models/pharma_info_model.dart';
// import 'package:pharma_transfer/models/pharma_model.dart';

// const double kCardElevation = 0;

// class PharmaCardWidget extends StatelessWidget {
//   const PharmaCardWidget({super.key, required this.pharmaInfo});
//   final PharmaInfo pharmaInfo;

//   @override
//   Widget build(BuildContext context) {
//     final Pharma farmacia = pharmaInfo.farmacia;
//     String distanciaStr = pharmaInfo.distancia != null
//         ? pharmaInfo.distancia!.toInt().toString()
//         : 'Desconocida';

//     return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 4),
//         child: Card(
//           margin: EdgeInsets.zero,
//           elevation: kCardElevation,
//           shape: RoundedRectangleBorder(
//             borderRadius: const BorderRadius.all(Radius.circular(12)),
//             side: BorderSide(color: Theme.of(context).colorScheme.outline),
//           ),
//           shadowColor: null,
//           child: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: ExpansionTile(
//               // iconColor: Colors.black,
//               initiallyExpanded: true,
//               title: Text(
//                 farmacia.farmasName ?? '',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               subtitle: Text(
//                   'Horario de atención: ${farmacia.farmasHorario ?? "Desconocido"} \nDistancia Aprox. (mts): $distanciaStr'),
//               // isThreeLine: true,
//               // expandedAlignment: Alignment.centerLeft,
//               children: [
//                 const Divider(),
//                 const Row(
//                   children: [SizedBox(width: 16), Text('Productos')],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     // const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         const Text('Recoger: '),
//                         CircleAvatar(
//                             child: Text(pharmaInfo.prodRecoger
//                                 .toString()
//                                 .padLeft(2, '0'))),
//                       ],
//                     ),
//                     // const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         const Text('Entregar:'),
//                         CircleAvatar(
//                             child: Text(pharmaInfo.prodEntregar
//                                 .toString()
//                                 .padLeft(2, '0'))),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Text('Tienes:'),
//                         CircleAvatar(
//                             child: Text(pharmaInfo.prodRecogidoUsuario
//                                 .toString()
//                                 .padLeft(2, '0')))
//                       ],
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 // Row(
//                 //   children: [
//                 //     const SizedBox(height: 4),
//                 //     Text('A Entregar '),
//                 //     CircleAvatar(
//                 //         child: Text(pharmaInfo.prodEntregar
//                 //             .toString()
//                 //             .padLeft(2, '0'))),
//                 //     Text('Tienes '),
//                 //     CircleAvatar(
//                 //         child: Text(pharmaInfo.prodRecogidoUsuario
//                 //             .toString()
//                 //             .padLeft(2, '0')))
//                 //   ],
//                 // ),
//                 const SizedBox(height: 4),
//               ],
//             ),
//           ),
//         ));
//   }
// }
