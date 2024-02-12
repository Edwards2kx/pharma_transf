import 'dart:convert';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:pharma_transfer/config/python_gemini_prompt.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/recibo_model.dart';
import 'package:string_similarity/string_similarity.dart';

const bool kUsePharmaNameValidator = true;

class ImageGeminiDecoder {
  static Future<Either<String, Recibo>> procesarImagen(
      Uint8List? imageBytes) async {
    if (imageBytes == null) {
      return const Left('No seleccionaste ninguna imagen');
    }
    final gemini = Gemini.instance;
    final geminiResponse = await gemini
        .textAndImage(text: kPythonPromptDecodeTicket, images: [imageBytes]);

    final response = geminiResponse?.content?.parts?.first.text;
    debugPrint('raw response from gemini server $response');
    if (response == null) {
      return const Left('Se presentó un fallo, intenta nueamente');
    }
    final sanitizedResponse = response.substring(
        response.indexOf('{'), response.lastIndexOf('}') + 1);
    final json = jsonDecode(sanitizedResponse);
    final result = json['result'];
    final error = json['error'];
    if (result == null) {
      return const Left('Se presentó un fallo, intenta nueamente');
    }
    if (result == 'SUCCESS') {
      final recibo = Recibo.fromMap(json['body']);
      if (!kUsePharmaNameValidator) return Right(recibo);


      final pharmaList = await getPharmaFromServer();
      final pharmaListNames = pharmaList.map((e) => e.farmasName).toList();
      final farAutoBestStringComparative =
          StringSimilarity.findBestMatch(recibo.farAutoTransf, pharmaListNames);
      final farSoliBestStringComparative =
          StringSimilarity.findBestMatch(recibo.farSoliTransf, pharmaListNames);
      final reciboValidated = recibo.copyWith(
          farAutoTransf:
              pharmaListNames[farAutoBestStringComparative.bestMatchIndex],
          farSoliTransf:
              pharmaListNames[farSoliBestStringComparative.bestMatchIndex]);
      debugPrint(reciboValidated.toString());

      
      return Right(reciboValidated);
      // return kUsePharmaNameValidator ? Right(reciboValidated) : Right(reciboValidated) ;
    }
    if (error != null) {
      debugPrint(
          'se presento el siguiente error ${json['body']['message'].toString()}.');
      return Left(error.toString());
    }
    return const Left('Error al procesar la imagen');
  }
}
