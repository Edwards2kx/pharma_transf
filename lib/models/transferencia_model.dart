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
    this.usuarioRecoge,
    this.usuarioEntrega,
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
  String? usuarioRecoge;
  String? usuarioEntrega; //deberia ser un solo usuario
  EstadoTransferencia estado;

  factory Transferencia.fromJson(Map<String, dynamic> json) {
    final transferencia = Transferencia(
      transfId: json["transf_id"],
      transfDateSubida: DateTime.parse(json["transf_date"]), //diferente
      // transfDateSubida: DateTime.parse(json["transf_date_subida"]), //diferente
      transfDateGenerado: DateTime.parse(json["transf_date_generado"]), //diferente
      transfNumero: json["transf_numero"],
      transfUsrSolicita: json["transf_usr_solicita"],
      transfFarmaSolicita: json["transf_farma_solicita"],
      transfUsrAcepta: json["transf_usr_acepta"],
      transfFarmaAcepta: json["transf_farma_acepta"],
      transfProducto: json["transf_producto"],
      transfCantidadEntera: json["transf_cantidad_entera"],
      transfCantidadFraccion: json["transf_cantidad_fraccion"],
      usuarioRecoge: json["transf_usr_recoge"],
      usuarioEntrega: json["transf_usr_entrega"],
    );
    if (transferencia.  usuarioRecoge == null) {
      transferencia.estado = EstadoTransferencia.pendiente;
    } else if (transferencia.usuarioEntrega == null) {
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
        'transfUsrRecoge: $usuarioRecoge, '
        'transfUsrEntrega: $usuarioEntrega, '
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
