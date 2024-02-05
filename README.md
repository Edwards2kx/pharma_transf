# pharma_transfer

A new Flutter project.


nombre del package 


com.smartneighbor.pharmatransf

para modificar el nombre del paquete usar el comando
flutter pub run change_app_package_name:main com.smartneighbor.pharmatransf


para generar la huella SHA1 y SHA256 en la consola usar
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

copiar en el proyecto de firebase


//vista login

al empezar intenta realizar un login silencioso... si falla
se queda en pantalla de login...
si es eficiente pasa a la pantalla home....


si el usuario no se encuentra en la base de datos muestra mensaje de usuario no autorizado
caso contrario permanece en la vista.


AL TERMINAR REFACTORIZAR LO SIGUIENTE

agregar al usuario de base de datos la información de cuenta de google
en el login de 1 obtener el usuario de base de datos antes de navegar...


modificar homePage para que ya le llegue el usuario.... este se carga desde la vista de login
o tener un future que muestre cargando y cuando ya obtenga el usuario de google y el usuario de base de datos muestre la vista...

cambiar las navegaciones a rutas usando go router y pasando los parametros...

gemini api_key AIzaSyDIZJ0ZW4WoRxQt00twWLWhLFTALs0auMU


los metodos del controller server_comunication.dart deben estar en una clase la cual debe ser accedida desde un provider no desde las vistas.





 {
 "FECHA": "2024-01-26 19:14:21",
 "NRO. TRANSFERENCIA": "2125-501-0001761",
 "USU. SOLI. TRANSF.": "LYASENCIO",
 "FAR. SOLI. TRANSF.": "ECO CONOCOT MONTFUAR",
 "USU. AUTO. TRANSF.": "EMAZANA",
"FAR. AUTO. TRANS": "MEDI PLAZA TUMBACO",
 "PRODUCTOS": 
    [
        {"NOMBRE": "LENZETTO SOL POLVO 1.53MG/DOSIS * 8.1ML", "ENT" : 1 , "FRAC" : 0}
    ]
 }

 {
  "FECHA": "2024-01-26 19:14:21",
  "NRO. TRANSFERENCIA": "2125-501-0001761",
  "USU. SOLI. TRANSF.": "LYASENCIO",
  "FAR. SOLI. TRANSF.": "ECO CONOCOT MONTFUAR",
  "USU. AUTO. TRANSF.": "EMAZANA",
 "FAR. AUTO. TRANS": "MEDI PLAZA TUMBACO",
  "PRODUCTOS": 
     [
         {"NOMBRE": "LENZETTO SOL POLVO 1.53MG/DOSIS * 8.1ML", "ENT" : 1 , "FRAC" : 0}
     ]
  }