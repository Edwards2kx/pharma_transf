const String kPythonPromptDecodeTicket = '''

En la imagen puede haber un recibo, la imagen podria estar rotada, rotala digitalmente para que el texto de forma completamente horizontal, dame una respuesta en forma de JSON, no inferir o incluir valores no presentes en la imagen

# Se definen las variables de error
errorFecha = "No se pudo leer la fecha."
errorNroTransferencia = "No se pudo leer el número de transferencia."
errorUsuSoliTransf = "No se pudo leer el usuario que solicita la transferencia."
errorFarSoliTransf = "No se pudo leer la farmacia que solicita la transferencia."
errorUsuAutoTransf = "No se pudo leer el usuario que autoriza la transferencia."
errorFarAutoTransf = "No se pudo leer la farmacia que autoriza la transferencia."
errorProductos = "No se pudieron leer los productos."

# Se definen las variables para los campos del recibo
fecha = "{{match_regex: /FECHA: (.*)/}}"
nroTransferencia = "{{match_regex: /NRO\.TRANSFERENCIA: (.*)/}}"
usuSoliTransf = "{{match_regex: /USU\.SOLI\.TRANSF: (.*)/}}"
farSoliTransf = "{{match_regex: /FAR\.SOLI\.TRANSF: (.*)/}}"
usuAutoTransf = "{{match_regex: /USU\.AUTO\.TRANSF: (.*)/}}"
farAutoTransf = "{{match_regex: /FAR\.AUTO\.TRANSF: (.*)/}}"


# Instrucciones para Gemini:

# El parámetro NOMBRE puede terminar en número.

# Los parámetros ENT y FRAC son los últimos valores de la fila.

# La fila solo contiene 3 elementos.

# El parámetro NOMBRE puede contener símbolos como +, *, -.

def parse_fila(fila):
  """
  Parsea una fila de datos y devuelve un diccionario con los valores.

  Args:
    fila: Una lista que contiene los valores de la fila.

  Returns:
    Un diccionario con los valores de la fila.
  """

  nombre = fila[0]
  ent = fila[1]
  frac = fila[2]

  return {
    "NOMBRE": nombre,
    "ENT": int(ent),
    "FRAC": int(frac),
  }

# Extrae las filas de la tabla
filas = extract_table(r"NOMBRE", r"ENT", r"FRAC", r"^(.*?)(?:\s+(\d+)\s+(\d+))?\$", content)

# Procesa cada fila
for fila in filas:
  valores = parse_fila(fila)

  # Usa los valores para procesar la imagen con Gemini




# Se define la variable para el cuerpo del JSON
body = {}

# Se define la variable para el error
error = None

# Se extrae la fecha
fecha = match_regex(r"/FECHA: (.*)/", content)

# Se extrae el número de transferencia
nroTransferencia = match_regex(r"/NRO\.TRANSFERENCIA: (.*)/", content)

# Se extrae el usuario que solicita la transferencia
usuSoliTransf = match_regex(r"/USU\.SOLI\.TRANSF: (.*)/", content)

# Se extrae la farmacia que solicita la transferencia
farSoliTransf = match_regex(r"/FAR\.SOLI\.TRANSF: (.*)/", content)

# Se extrae el usuario que autoriza la transferencia
usuAutoTransf = match_regex(r"/USU\.AUTO\.TRANSF: (.*)/", content)

# Se extrae la farmacia que autoriza la transferencia
farAutoTransf = match_regex(r"/FAR\.AUTO\.TRANSF: (.*)/", content)

# Se extraen los productos
productos = extract_table(r"NOMBRE", r"ENT", r"FRAC", r"^(.*?)(?:\s+(\d+)\s+(\d+))?\$", content)

# Se convierten las claves a minusculas
for producto in productos:
  producto.update({key.lower(): value for key, value in producto.items()})

# Se convierten los valores ent y frac a enteros
for producto in productos:
  if "ent" in producto:
    producto["ent"] = int(producto["ent"])
  if "frac" in producto:
    producto["frac"] = int(producto["frac"])


# Se valida la fecha
if not fecha:
  error += errorFecha

# Se valida el número de transferencia
if not nroTransferencia:
  error += errorNroTransferencia

# Se valida el usuario que solicita la transferencia
if not usuSoliTransf:
  error += errorUsuSoliTransf

# Se valida la farmacia que solicita la transferencia
if not farSoliTransf:
  error += errorFarSoliTransf

# Se valida el usuario que autoriza la transferencia
if not usuAutoTransf:
  error += errorUsuAutoTransf

# Se valida la farmacia que autoriza la transferencia
if not farAutoTransf:
  error += errorFarAutoTransf

# Se valida la lista de productos
if not productos:
  error += errorProductos

# Se agregan los campos del recibo al cuerpo del JSON
body["fecha"] = fecha
body["nroTransferencia"] = nroTransferencia
body["usuSoliTransf"] = usuSoliTransf
body["farSoliTransf"] = farSoliTransf
body["usuAutoTransf"] = usuAutoTransf
body["farAutoTransf"] = farAutoTransf
body["productos"] = productos

# Se define el resultado
result = "SUCCESS" if error is None else "ERROR"

# Se crea el JSON de respuesta
response = {
  "result": result,
  "body": body,
  "error": error
}

# Se convierte el JSON a una cadena
responseJson = json_encode(response)

# Se imprime el JSON de respuesta
print(responseJson)

'''
;
// productos = "{{extract_table: "NOMBRE", "ENT", "FRAC", /^(.*?)(?:\s+(\d+)\s+(\d+))?\$/}}"

