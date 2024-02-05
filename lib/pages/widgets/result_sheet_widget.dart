import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/models/recibo_model.dart';
import 'package:pharma_transfer/pages/widgets/recibo_resumen_reduce_widget.dart';
import 'package:provider/provider.dart';

class ResultSheetWidget extends StatelessWidget {
  final String filePath;
  const ResultSheetWidget({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
        final provider = Provider.of<ProviderTransferencias>(context, listen: true);
    final image = File(filePath);
    return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildImageCard(image),
            const SizedBox(height: 16),
            FutureBuilder<Either<String, Recibo>>(
              future: provider.procesarImagenRecibo(filePath),
              builder: (context, snapshoot) {
                if (snapshoot.hasData) {
                  final response = snapshoot.data!;
                  if (response.isLeft) {
                    return Center(
                      child: Text(response.left),
                    );
                  }
                  if (response.isRight) {
                    // recibo = response.right;
                    return ReciboResumenReduce(recibo: response.right);
                  }
                    // return ReciboResumenReduce(recibo: response);
                  return Container();
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          ],
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