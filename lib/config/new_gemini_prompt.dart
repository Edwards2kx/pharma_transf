const String kTunnedPromptDecodeTicket = '''

En la imagen puede haber un recibo, la imagen podria estar rotada, rotala digitalmente para que el texto de forma completamente horizontal, dame una respuesta en forma de JSON

  {{create_json: {
  "result": "SUCCESS",
  "body": {
    "FECHA": "{{match_regex: /FECHA: (.*)/}}"
    "NRO.TRANSFERENCIA": "{{match_regex: /NRO\.TRANSFERENCIA: (.*)/}}",
    "USU.SOLI TRANSF": "extractField("USU.SOLI.TRANSF", /USU\.SOLI\.TRANSF: (.*)/)",
    "FAR.SOLI.TRANSF": "extractField("FAR.SOLI.TRANSF", /FAR\.SOLI\.TRANSF: (.*)/)",
    "USU.AUTO.TRANSF": "extractField("FAR.AUTO.TRANSF", /FAR\.AUTO\.TRANSF: (.*)/)",
    "FAR.AUTO.TRANSF": "extractField("FAR.AUTO.TRANSF", /FAR\.AUTO\.TRANSF: (.*)/)",
    "PRODUCTOS": {{extract_table: "NOMBRE", "ENT", "FRAC", /^(.*?)(?:\s+(\d+)\s+(\d+))?\$/}}
    },
  "content":"{{extract_text}}",
  "error": "{{if not FECHA or not NRO.TRANSFERENCIA or not USU.SOLI TRANSF or not FAR.SOLI.TRANSF or not USU.AUTO.TRANSF or not FAR.AUTO.TRANSF or not PRODUCTOS}}No se pudo leer algun parametro del recibo. Vuelve a intentarlo.{{/if}}"
  }}}








{% set error_fecha = "No se pudo leer la fecha." %}
{% set error_nro_transferencia = "No se pudo leer el número de transferencia." %}
{% set error_usu_soli_transf = "No se pudo leer el usuario que solicita la transferencia." %}
{% set error_far_soli_transf = "No se pudo leer la farmacia que solicita la transferencia." %}
{% set error_usu_auto_transf = "No se pudo leer el usuario que autoriza la transferencia." %}
{% set error_far_auto_transf = "No se pudo leer la farmacia que autoriza la transferencia." %}
{% set error_productos = "No se pudieron leer los productos." %}

{% set fecha = "{{match_regex: /FECHA: (.*)/}}" %}
{% set nro_transferencia = "{{match_regex: /NRO\.TRANSFERENCIA: (.*)/}}" %}
{% set usu_soli_transf = "{{match_regex: /USU\.SOLI\.TRANSF: (.*)/}}" %}
{% set far_soli_transf = "{{match_regex: /FAR\.SOLI\.TRANSF: (.*)/}}" %}
{% set usu_auto_transf = "{{match_regex: /USU\.AUTO\.TRANSF: (.*)/}}" %}
{% set far_auto_transf = "{{match_regex: /FAR\.AUTO\.TRANSF: (.*)/}}" %}
{% set productos = "{{extract_table: "NOMBRE", "ENT", "FRAC", /^(.*?)(?:\s+(\d+)\s+(\d+))?\$/}}" %}

{% set body = {
  "FECHA": fecha,
  "NRO.TRANSFERENCIA": nro_transferencia,
  "USU.SOLI TRANSF": usu_soli_transf,
  "FAR.SOLI.TRANSF": far_soli_transf,
  "USU.AUTO.TRANSF": usu_auto_transf,
  "FAR.AUTO.TRANSF": far_auto_transf,
  "PRODUCTOS": productos
} %}
{% set error = null %}

{% if not fecha %}
  {% set error = error | concat(" " | error_fecha) %}
{% endif %}

{% if not nro_transferencia %}
  {% set error = error | concat(" " | error_nro_transferencia) %}
{% endif %}

{% if not usu_soli_transf %}
  {% set error = error | concat(" " | error_usu_soli_transf) %}
{% endif %}

{% if not far_soli_transf %}
  {% set error = error | concat(" " | error_far_soli_transf) %}
{% endif %}

{% if not usu_auto_transf %}
  {% set error = error | concat(" " | error_usu_auto_transf) %}
{% endif %}

{% if not far_auto_transf %}
  {% set error = error | concat(" " | error_far_auto_transf) %}
{% endif %}

{% if not productos %}
  {% set error = error | concat(" " | error_productos) %}
{% endif %}

{% set response = {
  "result": error ? "ERROR" : "SUCCESS",
  "body": body,
  "error": error
} %}

{{ response | json_encode }}


'''




;


// {% set fecha = "{{match_regex: /FECHA: (.*)/}}" %}
// {% set nro_transferencia = "{{match_regex: /NRO\.TRANSFERENCIA: (.*)/}}" %}
// {% set usu_soli_transf = "{{match_regex: /USU\.SOLI\.TRANSF: (.*)/}}" %}
// {% set far_soli_transf = "{{match_regex: /FAR\.SOLI\.TRANSF: (.*)/}}" %}
// {% set usu_auto_transf = "{{match_regex: /USU\.AUTO\.TRANSF: (.*)/}}" %}
// {% set far_auto_transf = "{{match_regex: /FAR\.AUTO\.TRANSF: (.*)/}}" %}
// {% set productos = "{{extract_table: "NOMBRE", "ENT", "FRAC", /^(.*?)(?:\s+(\d+)\s+(\d+))?\$/}}" %}
