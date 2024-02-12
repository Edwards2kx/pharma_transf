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


cambiar la vista principal para que aparezca farmacias
para entregar en la parte superior, y no obligar
a tener la pantalla dividida si no hay farmacias para entregar

revisar la opcion de que a las farmacias para recoger
aparezca un contador de produtos a recoger en ella

cambiar los mensajes de errores o falta de información

quien recoge un producto es quien la puede entregar sino está marcada con su correo no puede modificarla

en la tarjeta que se vea el correo de quien la marco como recogida.


en historial, user acepta remover, colocar quien recogio y quien entrego.

en la pantalla principal , solo cuente las farmacias para entregar donde el usuario es el poseedor del 
paquete. 

1. las farmacias que no están en la base de datos se deben registrar en la primera visita.

2. solo el que recoge entrega, solo es visible las farmacias para entregar donde yo tengo 

3. el rol de dependiente solo ve el historial de la farmacia a la que está relacionado



AGREGAR VISTA DE UBICACIONES

AGREGAR ACCION DE SUBIR UBICACION MOTORIZADO
AGREGAR ACCION DE CONSULTAR UBICACION MOTORIZADO

 ya - AGREGAR VALIDACION DEL PERMISO DE UBICACION

 modificar drawer remover info innecesaria
 instalar shorebird
 agregar vista de mapas


 ubicacion 
 y acyualizacion farmacia

 probar endpoint de guardar ubicación, 
 probar endpoint de actualizar ubicación de farmacia



lottie files
borjalottie@yopmail.com
RRdFd5dSk3XxaPB
