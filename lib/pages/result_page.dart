import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/recibo_model.dart';
import 'package:pharma_transfer/pages/widgets/recibo_resumen_widget.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  static String route = 'resultPage';
  final String filePath;
  const ResultPage({super.key, required this.filePath});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Recibo? recibo;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderTransferencias>(context, listen: true);
    final image = File(widget.filePath);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmación de datos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildImageCard(image),
            const SizedBox(height: 16),
            FutureBuilder<Either<String, Recibo>>(
              future: provider.procesarImagenRecibo(widget.filePath),
              builder: (context, snapshoot) {
                if (snapshoot.hasData) {
                  final response = snapshoot.data!;
                  if (response.isLeft) {
                    return Center(
                      child: Text(response.left),
                    );
                  }
                  if (response.isRight) {
                    recibo = response.right;
                    return ReciboResumen(recibo: response.right);
                  }
                  return Container();
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (recibo != null) pushTransferencia(recibo!);
        },
        child: const Icon(Icons.file_upload),
      ),
    );
  }

  Widget buildImageCard(File image) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(elevation: 2.0, child: Image.file(image)),
    );
  }
}
