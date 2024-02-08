// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pharma_transfer/models/producto_model.dart';

class Recibo {
  String fecha;
  String numeroTransferencia;
  String usuSoliTransf;
  String farSoliTransf;
  String usuAutoTransf;
  String farAutoTransf;
  List<Producto> producto;

  Recibo({
    required this.fecha,
    required this.numeroTransferencia,
    required this.usuSoliTransf,
    required this.farSoliTransf,
    required this.usuAutoTransf,
    required this.farAutoTransf,
    required this.producto,
  });



  // String fecha = '';
  // String numeroTransferencia = '';
  // String usuSoliTransf = '';
  // String farSoliTransf = '';
  // String usuAutoTransf = '';
  // String farAutoTransf = '';
  // String producto = '';

// //TODO: eliminar estos elementos innecesarios
//   Rect? rectEnt;
//   Rect? rectFrac;
//   Rect? rectProducts;
//   String? myString;

  // List<String> listaProductos = []; //podrian ser locales
  // List<String> listaCantidades = []; //podrian ser locales
  // List<String> listaFraciones = []; //podrian ser locales
  // List<List<String>> listaProductosCantidad = []; // esta es la importante
  // List<Pharma> pharmaList = [];




// //TODO: esto valida si todos los datos están completos, talves eliminar a futuro
//   bool isComplete() {
//     bool productosOK = _createProduts();
//     if (fecha.isNotEmpty &&
//         numeroTransferencia.isNotEmpty &&
//         usuSoliTransf.isNotEmpty &&
//         farSoliTransf.isNotEmpty &&
//         usuAutoTransf.isNotEmpty &&
//         farAutoTransf.isNotEmpty &&
//         productosOK) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//TODO: verificar necesidad, validacion por errores de lectura...
  // bool _createProduts() {
  //   if (listaProductos.length == listaCantidades.length) {
  //     if (listaProductos.length == listaFraciones.length) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  factory Recibo.fromMap(Map<String, dynamic> map) {
    return Recibo(
      fecha: map['fecha'] as String,
      numeroTransferencia: map['nroTransferencia'] as String,
      usuSoliTransf: map['usuSoliTransf'] as String,
      farSoliTransf: map['farSoliTransf'] as String,
      usuAutoTransf: map['usuAutoTransf'] as String,
      farAutoTransf: map['farAutoTransf'] as String,
      // producto: []
      producto: List<Producto>.from((map['productos'] as List).map<Producto>((x) => Producto.fromMap(x as Map<String,dynamic>),),),
    );
  }
  // factory Recibo.fromMap(Map<String, dynamic> map) {
  //   return Recibo(
  //     fecha: map['FECHA'] as String,
  //     numeroTransferencia: map['NRO.TRANSFERENCIA'] ?? map['NRO. TRANSFERENCIA'],
  //     usuSoliTransf: map['USU.SOLI.TRANSF'] as String,
  //     farSoliTransf: map['FAR.SOLI.TRANSF'] as String,
  //     usuAutoTransf: map['USU.AUTO.TRANSF'] as String,
  //     farAutoTransf: map['FAR.AUTO.TRANSF'] as String,
  //     // producto: []
  //     producto: List<Producto>.from((map['PRODUCTOS'] as List).map<Producto>((x) => Producto.fromMap(x as Map<String,dynamic>),),),
  //   );
  // }

  factory Recibo.fromJson(String source) => Recibo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Recibo(fecha: $fecha, numeroTransferencia: $numeroTransferencia, usuSoliTransf: $usuSoliTransf, farSoliTransf: $farSoliTransf, usuAutoTransf: $usuAutoTransf, farAutoTransf: $farAutoTransf, producto: $producto)';
  }

  Recibo copyWith({
    String? fecha,
    String? numeroTransferencia,
    String? usuSoliTransf,
    String? farSoliTransf,
    String? usuAutoTransf,
    String? farAutoTransf,
    List<Producto>? producto,
  }) {
    return Recibo(
      fecha: fecha ?? this.fecha,
      numeroTransferencia: numeroTransferencia ?? this.numeroTransferencia,
      usuSoliTransf: usuSoliTransf ?? this.usuSoliTransf,
      farSoliTransf: farSoliTransf ?? this.farSoliTransf,
      usuAutoTransf: usuAutoTransf ?? this.usuAutoTransf,
      farAutoTransf: farAutoTransf ?? this.farAutoTransf,
      producto: producto ?? this.producto,
    );
  }
}
