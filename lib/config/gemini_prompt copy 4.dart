const String kPromptDecodeTicket = '''
En la imagen puede haber un recibo, requiero como respuesta un objeto JSON con la siguiente información:
**Información general:**
* **FECHA:** {{match_regex: /FECHA: (.*)/}}
* **NRO. TRANSFERENCIA:** {{match_regex: /NRO\.TRANSFERENCIA: (.*)/}}
**Origen y destino de la transferencia:**
"Los valores de los parámetros deben ser tomados literalmente del texto, sin ninguna inferencia o deducción."
"USU.SOLI.TRANSF": {{raw: (function() {
  return {{match_regex: /USU\.SOLI\.TRANSF: (.*)/}};
})}},
"FAR.SOLI.TRANSF": {{raw: (function() {
  return {{match_regex: /FAR\.SOLI\.TRANSF: (.*)/}};
})}},
"USU.AUTO.TRANSF": {{raw: (function() {
  return {{match_regex: /USU\.AUTO\.TRANSF: (.*)/}};
})}},
"FAR.AUTO.TRANS": {{raw: (function() {
  return {{match_regex: /FAR\.AUTO\.TRANS: (.*)/}};
})}},
**Productos:**
* **NOMBRE:** {{extract_table: "NOMBRE", "ENT", "FRAC"}}
o
* **NOMBRE:** {{extract_table: "NOMBRE", "ENTEROS", "FRACC"}}
el parametro NOMBRE podria terminar en numero, para asegurarse de que el parametro ENT y FRAC son los correspondiente tenerlos en cuenta
como los ultimos valores de la fila.
en el parametro NOMBRE podrian haber simbolos como +,* y -
estructura JSON en caso de lectura correcta de los parametros
{{create_json: {
"result": "SUCCESS",
"body": {
"FECHA": "",
"NRO.TRANSFERENCIA": "",
"USU.SOLI TRANSF": "",
"FAR.SOLI.TRANSF": "",
"USU.AUTO.TRANSF": "",
"FAR.AUTO.TRANS": "",
"PRODUCTOS": [
{
"NOMBRE": "",
"ENT": 0,
"FRAC": 0
}
]
}
}}}

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