// ignore_for_file: unnecessary_string_escapes

const String kPromptDecodeTicket = '''
En la imagen puede haber un recibo, la imagen podria estar rotada, requiero como respuesta un objeto JSON con la siguiente información:

**Productos:**
* **NOMBRE:** {{extract_table: "NOMBRE", "ENT", "FRAC"}}
o
* **NOMBRE:** {{extract_table: "NOMBRE", "ENTEROS", "FRACC"}}

el parametro NOMBRE podria terminar en numero, para asegurarse de que el parametro ENT y FRAC son los correspondiente tenerlos en cuenta
como los ultimos valores de la fila.
en el parametro NOMBRE podrian haber simbolos como +,* y -

"ENT": {{match_regex: /ENT\s+(\d+)/}},
"FRAC": {{match_regex: /FRAC\s+(\d+)/}},

estructura JSON en caso de lectura correcta de los parametros

{{create_json: {
  {
    "result": "SUCCESS",
    "body": {
      "FECHA": {{match_regex: /FECHA: (.*)/}},
      "NRO.TRANSFERENCIA": {{match_regex: /NRO\.TRANSFERENCIA: (.*)/}},
      "USU.SOLI.TRANSF": extractField("USU.SOLI.TRANSF", /USU\.SOLI\.TRANSF: (.*)/),
      "FAR.SOLI.TRANSF": extractField("FAR.SOLI.TRANSF", /FAR\.SOLI\.TRANSF: (.*)/),
      "USU.AUTO.TRANSF": extractField("USU.AUTO.TRANSF", /USU\.AUTO\.TRANSF: (.*)/),
      "FAR.AUTO.TRANSF": extractField("FAR.AUTO.TRANSF", /FAR\.AUTO\.TRANSF: (.*)/),
      "PRODUCTOS": {{extract_table: "NOMBRE", "ENT", "FRAC", /^(.*?)(?:\s+(\d+)\s+(\d+))?\$/}},
      
    }
  }
}}

estructura JSON en caso de error por falla en lectura

{"result": "ERROR", "body": {"message" : "No es posible leer los parametros [USU. SOLI. TRANSF., USU. AUTO. TRANSF.]"}}
en message hay unos valores de ejemplos no usar en caso de no ser requeridos
'''
;


// 1. cuando la imagen no contiene ninguno de los parametros solicitados devolver error: "Imagen no valida"
// 2. cuando la imagen contiene alguno pero no todos los parametros solicitados devolver error: "No es posible leer los parametros [x,y,..]" donde los parametros
// son los elementos que no se pudieron extraer.

//linea 33

// {"result": "SUCCESS","body": {"FECHA": "2024-01-26 19:14:21","NRO.TRANSFERENCIA": "2125-501-0001761","USU.SOLI.TRANSF": "LYASENCIO","FAR.SOLI.TRANSF": "ECO CONOCOT MONTFUAR","USU.AUTO.TRANSF": "EMAZANA","FAR.AUTO.TRANS": "MEDI PLAZA TUMBACO","PRODUCTOS": [{"NOMBRE": "LENZETTO SOL POLVO 1.53MG/DOSIS * 8.1ML","ENT": 1,"FRAC": 0}]}}

// Los valores en el json de ejemplo no deben ser retornados en caso de que no se puedan obtener correctamente.

// {{create_json: {
//   {
//     "result": "SUCCESS",
//     "body": {
//       "FECHA": {{match_regex: /FECHA: (.*)/}},
//       "NRO.TRANSFERENCIA": {{match_regex: /NRO\.TRANSFERENCIA: (.*)/}},
//       "USU.SOLI TRANSF":{{raw: (function() { return {{match_regex: /USU\.SOLI\.TRANSF: (.*)/}},
//       "FAR.SOLI.TRANSF":{{raw: (function() { return {{match_regex: /FAR\.SOLI\.TRANSF: (.*)/}},
//       "USU.AUTO.TRANSF": {{raw: (function() { return {{match_regex: /USU\.AUTO\.TRANSF: (.*)/}},
//       "FAR.AUTO.TRANS": {{raw: (function() { return {{match_regex: /FAR\.AUTO\.TRANS: (.*)/}},
//       "PRODUCTOS": {{extract_table: "NOMBRE", "ENT", "FRAC"}},
//     }
//   }
// }}

// {{create_json: {
// "result": "SUCCESS",
// "body": {
// "FECHA": {{match_regex: /FECHA: (.*)/}},
// "NRO.TRANSFERENCIA": {{match_regex: /NRO\.TRANSFERENCIA: (.*)/}},
// "USU.SOLI TRANSF":{{raw: (function() { return {{match_regex: /USU\.SOLI\.TRANSF: (.*)/}},
// "FAR.SOLI.TRANSF":{{raw: (function() { return {{match_regex: /FAR\.SOLI\.TRANSF: (.*)/}},
// "USU.AUTO.TRANSF": {{raw: (function() { return {{match_regex: /USU\.AUTO\.TRANSF: (.*)/}},
// "FAR.AUTO.TRANS": {{raw: (function() { return {{match_regex: /FAR\.AUTO\.TRANS: (.*)/}},
// "PRODUCTOS": [
// {
// "NOMBRE": "",
// "ENT": 0,
// "FRAC": 0
// }
// ]
// }
// }}}