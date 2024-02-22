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
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Card(
//         margin: EdgeInsets.zero,
//         elevation: kCardElevation,
//         shape: RoundedRectangleBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(12)),
//           side: BorderSide(color: Theme.of(context).colorScheme.outline),
//         ),
//         shadowColor: null,
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 8,
//                 child: ListTile(
//                   title: Text(
//                     farmacia.farmasName ?? '',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   subtitle: Text(
//                       'Horario de atención: ${farmacia.farmasHorario ?? "Desconocido"} \nDistancia Aprox. (mts): $distanciaStr'),
//                   isThreeLine: true,
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: // contentPadding: EdgeInsets.all(8),
//                     // leading: const Icon(Icons.gite_outlined),
//                     // trailing:
//                     Column(
//                   children: [
//                     if (pharmaInfo.prodRecoger > 0) CircleAvatar(
//                         // radius: 16,
//                         child: Text(
//                             pharmaInfo.prodRecoger.toString().padLeft(2, '0'))),
//                     const SizedBox(height: 4),
//                     if (pharmaInfo.prodEntregar > 0)
//                       CircleAvatar(
//                           backgroundColor:
//                               Theme.of(context).colorScheme.surfaceVariant,
//                           // radius: 16,
//                           child: Text(pharmaInfo.prodEntregar
//                               .toString()
//                               .padLeft(2, '0'))),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
