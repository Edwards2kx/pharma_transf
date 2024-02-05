import 'package:flutter/material.dart';
import 'package:pharma_transfer/models/recibo_model.dart';

const TextStyle textStyleValue = TextStyle(
    fontSize: 16.0, color: Colors.black87, fontWeight: FontWeight.w500);

const TextStyle textStyleLabel = TextStyle(
    fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.w300);

class ReciboResumen extends StatelessWidget {
  final Recibo recibo;
  const ReciboResumen({super.key, required this.recibo});

  @override
  Widget build(BuildContext context) {
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
              ListTile(
                title: const Text('Fecha', style: textStyleLabel),
                subtitle: Text(recibo.fecha, style: textStyleValue),
              ),
              const Divider(),
              ListTile(
                title: const Text('numeroTransferencia', style: textStyleLabel),
                subtitle:
                    Text(recibo.numeroTransferencia, style: textStyleValue),
              ),
              const Divider(),
              ListTile(
                title: const Text('usuSoliTransf', style: textStyleLabel),
                subtitle: Text(recibo.usuSoliTransf, style: textStyleValue),
              ),
              const Divider(),
              ListTile(
                title: const Text('farSoliTransf', style: textStyleLabel),
                subtitle: Text(recibo.farSoliTransf, style: textStyleValue),
              ),
              const Divider(),
              ListTile(
                title: const Text('usuAutoTransf', style: textStyleLabel),
                subtitle: Text(recibo.usuAutoTransf, style: textStyleValue),
              ),
              const Divider(),
              ListTile(
                title: const Text('farAutoTransf', style: textStyleLabel),
                subtitle: Text(recibo.farAutoTransf, style: textStyleValue),
              ),
              const Divider(),
              ...recibo.producto
                  .map((e) => ListTile(
                        title: Text('Producto ${e.nombre}', style: textStyleLabel),
                        subtitle: Text('Ent: ${e.ent} Frac: ${e.frac}',  style: textStyleValue),
                      ))
                  .toList()
              // for(var product in recibo.producto) {
              //   return Container();
              // }
            ],
          ),
        ),
      ),
    );
  }
}
