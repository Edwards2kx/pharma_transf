import 'dart:convert';

enum EstadoTransferencia { pendiente, recogido, entregado }

List<Transferencia> transferenciaFromJson(String str) =>
    List<Transferencia>.from(
        json.decode(str).map((x) => Transferencia.fromJson(x)));

class Transferencia {
  Transferencia({
    this.transfId,
    this.transfDateSubida,
    this.transfDateGenerado,
    this.transfNumero,
    this.transfUsrSolicita,
    this.transfFarmaSolicita,
    this.transfUsrAcepta,
    this.transfFarmaAcepta,
    this.transfProducto,
    this.transfCantidadEntera,
    this.transfCantidadFraccion,
    this.transfUsrRecoge,
    this.transfUsrEntrega,
    this.estado = EstadoTransferencia.pendiente,
  });

  String? transfId;
  DateTime? transfDateSubida;
  DateTime? transfDateGenerado;
  String? transfNumero;
  String? transfUsrSolicita;
  String? transfFarmaSolicita;
  String? transfUsrAcepta;
  String? transfFarmaAcepta;
  String? transfProducto;
  String? transfCantidadEntera;
  String? transfCantidadFraccion;
  String? transfUsrRecoge;
  String? transfUsrEntrega;
  EstadoTransferencia estado;

  factory Transferencia.fromJson(Map<String, dynamic> json) {
    final transferencia = Transferencia(
      transfId: json["transf_id"],
      transfDateSubida: DateTime.parse(json["transf_date_subida"]),
      transfDateGenerado: DateTime.parse(json["transf_date_generado"]),
      transfNumero: json["transf_numero"],
      transfUsrSolicita: json["transf_usr_solicita"],
      transfFarmaSolicita: json["transf_farma_solicita"],
      transfUsrAcepta: json["transf_usr_acepta"],
      transfFarmaAcepta: json["transf_farma_acepta"],
      transfProducto: json["transf_producto"],
      transfCantidadEntera: json["transf_cantidad_entera"],
      transfCantidadFraccion: json["transf_cantidad_fraccion"],
      transfUsrRecoge: json["transf_usr_recoge"],
      transfUsrEntrega: json["transf_usr_entrega"],
    );
    if (transferencia.transfUsrRecoge == null) {
      transferencia.estado = EstadoTransferencia.pendiente;
    } else if (transferencia.transfUsrEntrega == null) {
      transferencia.estado = EstadoTransferencia.recogido;
    } else {
      transferencia.estado = EstadoTransferencia.entregado;
    }
    return transferencia;
  }
  @override
  String toString() {
    return 'Transferencia{'
        'transfId: $transfId, '
        'transfDateSubida: $transfDateSubida, '
        'transfDateGenerado: $transfDateGenerado, '
        'transfNumero: $transfNumero, '
        'transfUsrSolicita: $transfUsrSolicita, '
        'transfFarmaSolicita: $transfFarmaSolicita, '
        'transfUsrAcepta: $transfUsrAcepta, '
        'transfFarmaAcepta: $transfFarmaAcepta, '
        'transfProducto: $transfProducto, '
        'transfCantidadEntera: $transfCantidadEntera, '
        'transfCantidadFraccion: $transfCantidadFraccion, '
        'transfUsrRecoge: $transfUsrRecoge, '
        'transfUsrEntrega: $transfUsrEntrega, '
        'estado: $estado}';
  }
  // EstadoTransferencia? estadoTransferencia() {
  //   if (transfUsrRecoge == null) return EstadoTransferencia.pendiente;
  //   if (transfUsrRecoge != null && transfUsrEntrega == null)
  //     return EstadoTransferencia.recogido;
  //   if (transfUsrRecoge != null && transfUsrEntrega != null)
  //     return EstadoTransferencia.entregado;
  //   return null;
  // }
}
