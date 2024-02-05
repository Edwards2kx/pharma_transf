// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:text_recognition_ml_firebase/controller/serverComunication.dart';
// import 'package:text_recognition_ml_firebase/controller/providerTransferencias.dart';
// import 'package:text_recognition_ml_firebase/models/trasferenciaModel.dart';
// import 'package:text_recognition_ml_firebase/models/userModel.dart';
// import 'package:text_recognition_ml_firebase/utils/utils.dart';

// class TransferCard extends StatefulWidget {
//   final Transferencia transferencia;

//   TransferCard({@required this.transferencia});

//   @override
//   _TransferCardState createState() => _TransferCardState();
// }

// class _TransferCardState extends State<TransferCard> {
//   @override
//   Widget build(BuildContext context) {
//     Transferencia transferencia = widget.transferencia;

//     var _estadoTransferencia = transferencia.estadoTransferencia();
//     String _estado;
//     Color _color;
//     String _accion;
//     DateTime _fechaHora = transferencia.transfDateGenerado;

//     switch (_estadoTransferencia) {
//       case EstadoTransferencia.pendiente:
//         _estado = 'Pendiente';
//         _color = Colors.red;
//         _accion = 'Recogido?';
//         break;
//       case EstadoTransferencia.recogido:
//         _estado = 'Recogido';
//         _color = Colors.yellow;
//         _accion = 'Entregado?';
//         break;
//       case EstadoTransferencia.entregado:
//         _estado = 'Entregado';
//         _color = Colors.green;
//         _accion = 'Terminado';
//         break;
//     }

//     return Card(
//       margin: EdgeInsets.all(8.0),
//       child: Container(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text('Farma solicita'),
//                   Text('Farma acepta'),
//                   Text('User acepta'),
//                   Text('Fecha y Hora'),
//                 ]),
//                 SizedBox(width: 10.0),
//                 Expanded(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(transferencia.transfFarmaSolicita,
//                             overflow: TextOverflow.ellipsis),
//                         Text(transferencia.transfFarmaAcepta,
//                             overflow: TextOverflow.ellipsis),
//                         Text(transferencia.transfUsrAcepta,
//                             overflow: TextOverflow.ellipsis),
//                         Text(
//                             '${_fechaHora.day.toString().padLeft(2, '0')}/${_fechaHora.month.toString().padLeft(2, '0')}/${_fechaHora.year} - ${_fechaHora.hour.toString().padLeft(2, '0')}:${_fechaHora.minute.toString().padLeft(2, '0')}'),
//                       ]),
//                 ),
//               ],
//             ),
//             Divider(),
//             Text(transferencia.transfProducto, style: textStyleValue),
//             Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//               Text('Ent. ${transferencia.transfCantidadEntera}',
//                   style: textStyleValue),
//               Text('  -   ', style: textStyleValue),
//               Text('Frac. ${transferencia.transfCantidadFraccion}',
//                   style: textStyleValue)
//             ]),
//             Divider(),
//             Row(
//               children: [
//                 MaterialButton(
//                   onPressed: () async {
//                     if (_estadoTransferencia != EstadoTransferencia.entregado)
//                       await _changeTransfState(transferencia);
//                   },
//                   child: Container(
//                     child: Text(_accion),
//                   ),
// //                    shape: StadiumBorder(),
//                   shape: RoundedRectangleBorder(),
//                   color: Colors.white,
//                   elevation: 8.0,
//                 ),
//                 Expanded(
//                   child: Container(),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text('Estado:   $_estado    '),
//                     Icon(Icons.circle, color: _color)
//                   ],
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _changeTransfState(Transferencia transferencia) async {
//     final provider =
//         Provider.of<ProviderTransferencias>(context, listen: false);
//     final User user = provider.currentUser;

//     var _estadoTransferencia = transferencia.estadoTransferencia();
//     showDialog(
//         context: context,
//         builder: (_) {
//           return AlertDialog(
//             title: Text('¿Quieres cambiar el estado de la transferencia?'),
//             actions: [
//               MaterialButton(
//                   onPressed: () => Navigator.pop(context), child: Text('No')),
//               MaterialButton(
//                   onPressed: () async {
//                     //TODO: ejecutar el cambio de transferencia
//                     //toast de confirmacion
//                     //redibujar pantalla
//                     if (_estadoTransferencia == EstadoTransferencia.pendiente)
//                       await updateTransfRet(transferencia, user.usersEmail);

//                     if (_estadoTransferencia == EstadoTransferencia.recogido)
//                       await updateTransfEnt(transferencia, user.usersEmail);
//                     provider.updateTransferencias();

//                     Navigator.pop(context);
//                     setState(() {});
//                   },
//                   child: Text('Si')),
//             ],
//           );
//         });
//   }
// }
