import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  group('get_transf_result_test', () {
    test('Debe cargar y deserializar el archivo get_transf_result.json',
        () async {
      // Leer el archivo JSON
      final file = File('test/mocks/get_transf_result.json');
      expect(file.existsSync(), true, reason: 'El archivo JSON debe existir');

      // Cargar el contenido del archivo
      final jsonString = await file.readAsString();
      expect(jsonString.isNotEmpty, true,
          reason: 'El archivo no debe estar vacío');

      // Deserializar el JSON
      final List<dynamic> jsonData = json.decode(jsonString);

      // Imprimir la cantidad de objetos encontrados
      print('Cantidad de objetos encontrados en el JSON: ${jsonData.length}');

      // Verificar que la cantidad de elementos sea mayor a 0
      expect(jsonData.length, greaterThan(0),
          reason: 'El JSON debe contener al menos un elemento');

      // Información adicional para debug
      print('Primer elemento del JSON: ${jsonData.first}');
      print('Último elemento del JSON: ${jsonData.last}');
    });

    test('Debe verificar la estructura de los objetos en el JSON', () async {
      // Leer y deserializar el archivo JSON
      final file = File('test/mocks/get_transf_result.json');
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);

      // Verificar que no esté vacío
      expect(jsonData.length, greaterThan(0));

      // Verificar la estructura del primer elemento
      final firstElement = jsonData.first as Map<String, dynamic>;

      // Verificar que contenga las propiedades esperadas
      expect(firstElement.containsKey('transf_id'), true);
      expect(firstElement.containsKey('transf_date'), true);
      expect(firstElement.containsKey('transf_numero'), true);
      expect(firstElement.containsKey('transf_producto'), true);

      print('Estructura del primer objeto verificada correctamente');
      print('Propiedades disponibles: ${firstElement.keys.toList()}');
    });

    test('Debe deserializar jsonData usando el modelo Transferencia', () async {
      // Leer y deserializar el archivo JSON
      final file = File('test/mocks/get_transf_result.json');
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);

      print('Iniciando deserialización de ${jsonData.length} elementos...');

      List<Transferencia> transferencias = [];
      int erroresEncontrados = 0;

      for (int i = 0; i < jsonData.length; i++) {
        try {
          final element = jsonData[i] as Map<String, dynamic>;
          final transferencia = Transferencia.fromJson(element);
          transferencias.add(transferencia);

          // Mostrar progreso cada 100 elementos
          if ((i + 1) % 100 == 0) {
            print('Procesados ${i + 1}/${jsonData.length} elementos...');
          }
        } catch (e, stackTrace) {
          erroresEncontrados++;
          print('Error en elemento $i: $e');
          print('Datos del elemento: ${jsonData[i]}');
          print('StackTrace: $stackTrace');

          // Si hay muchos errores, detener para investigar
          if (erroresEncontrados > 10) {
            print('Se encontraron más de 10 errores. Deteniendo el proceso.');
            break;
          }
        }
      }

      print('Deserialización completada:');
      print('- Elementos procesados exitosamente: ${transferencias.length}');
      print('- Errores encontrados: $erroresEncontrados');
      print('- Total de elementos en JSON: ${jsonData.length}');

      // Verificar que al menos se procesó algún elemento
      expect(transferencias.length, greaterThan(0),
          reason: 'Debe procesarse al menos una transferencia correctamente');

      // Mostrar información del primer elemento procesado
      if (transferencias.isNotEmpty) {
        print('Primera transferencia procesada: ${transferencias.first}');
      }

      // Verificar que el porcentaje de errores no sea muy alto
      final porcentajeErrores = (erroresEncontrados / jsonData.length) * 100;
      print('Porcentaje de errores: ${porcentajeErrores.toStringAsFixed(2)}%');

      expect(porcentajeErrores, lessThan(50),
          reason: 'El porcentaje de errores no debe superar el 50%');
    });

    test('Debe probar la función transferenciaFromJson con el JSON completo',
        () async {
      try {
        // Leer el archivo JSON
        final file = File('test/mocks/get_transf_result.json');
        final jsonString = await file.readAsString();

        print('Probando transferenciaFromJson con el JSON completo...');

        // Usar la función global del modelo
        final List<Transferencia> transferencias =
            transferenciaFromJson(jsonString);

        print('Función transferenciaFromJson ejecutada exitosamente');
        print('Número de transferencias procesadas: ${transferencias.length}');

        // Verificar que se procesaron elementos
        expect(transferencias.length, greaterThan(0));

        // Mostrar información de la primera transferencia
        if (transferencias.isNotEmpty) {
          print('Primera transferencia: ${transferencias.first.transfId}');
          print('Estado: ${transferencias.first.estado}');
          print('Producto: ${transferencias.first.transfProducto}');
        }
      } catch (e, stackTrace) {
        print('Error al usar transferenciaFromJson: $e');
        print('StackTrace: $stackTrace');

        // El test fallará, pero queremos ver el error específico
        fail('transferenciaFromJson falló: $e');
      }
    });

    test('Debe identificar elementos específicos con datos nulos problemáticos',
        () async {
      // Leer y deserializar el archivo JSON
      final file = File('test/mocks/get_transf_result.json');
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);

      print('Buscando elementos con campos DateTime nulos...');

      int elementosConFechasNulas = 0;
      List<int> indicesProblematicos = [];

      for (int i = 0; i < jsonData.length; i++) {
        final element = jsonData[i] as Map<String, dynamic>;

        // Verificar campos de fecha que pueden ser problemáticos
        bool tieneProblemas = false;

        if (element['transf_date'] == null) {
          print('Elemento $i: transf_date es null');
          tieneProblemas = true;
        }

        if (element['transf_date_generado'] == null) {
          print('Elemento $i: transf_date_generado es null');
          tieneProblemas = true;
        }

        if (tieneProblemas) {
          elementosConFechasNulas++;
          indicesProblematicos.add(i);

          print('Elemento problemático $i: ${element}');

          // Mostrar solo los primeros 5 para no saturar la salida
          if (elementosConFechasNulas >= 5) {
            break;
          }
        }
      }

      print('Total elementos con fechas nulas: $elementosConFechasNulas');
      print('Índices problemáticos encontrados: $indicesProblematicos');

      // Crear un test específico para el elemento que sabemos que falla
      if (jsonData.length > 1929) {
        print('\\nAnalizando elemento 1929 específicamente:');
        final elementoProblematico = jsonData[1929] as Map<String, dynamic>;
        print('Elemento 1929: $elementoProblematico');

        // Verificar qué campos tienen null
        elementoProblematico.forEach((key, value) {
          if (value == null) {
            print('Campo $key es NULL en elemento 1929');
          }
        });
      }

      expect(elementosConFechasNulas, greaterThan(0),
          reason:
              'Debe encontrar al menos un elemento con fechas nulas para confirmar el problema');
    });

    test('Debe sugerir corrección para el modelo Transferencia', () {
      print('''
PROBLEMA IDENTIFICADO:
- El método Transferencia.fromJson() falla cuando transf_date_generado es null
- Línea problemática: DateTime.parse(json["transf_date_generado"])
- Error: type 'Null' is not a subtype of type 'String'

SOLUCIÓN SUGERIDA:
Cambiar en transferencia_model.dart línea 47:
  
DE:
  transfDateGenerado: DateTime.parse(json["transf_date_generado"]),

A:
  transfDateGenerado: json["transf_date_generado"] != null 
      ? DateTime.parse(json["transf_date_generado"]) 
      : null,

O alternativamente:
  transfDateGenerado: json["transf_date_generado"] != null 
      ? DateTime.tryParse(json["transf_date_generado"]) 
      : null,
      ''');

      // Este test siempre pasa, solo está documentando la solución
      expect(true, true);
    });
  });
}
