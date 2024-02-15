import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pharma_transfer/models/recibo_model.dart';

class MLKitImageDecoder {
  static Future<Either<String, Recibo>> procesarImagen(Uint8List? imageBytes) async {
    // final inputImage = InputImage.fromBytes(bytes: bytes, metadata: metadata);
       if (imageBytes == null) {
      return const Left('No seleccionaste ninguna imagen');
    }
    // final inputImage = InputImage.fromBytes(bytes: imageBytes, metadata: metadata)
    return const Left('');
  }
}
