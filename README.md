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


lottie files
borjalottie@yopmail.com
RRdFd5dSk3XxaPB

cambiar barra del drawer DONE
cambiar icono app IN PROGRESS
cambiar nombre de la app

filtrar vista mapa por un solo usuario
añadir en el mapa, opcion de buscar? o tap para ver información como un tool bar

invertir el orden de llegada de las transferencias del historial o ver como organizarlas


cambiar el icono de la app

flutter pub run flutter_launcher_icons

al actualizar la ubicacion debo actualizar el nearPharma

para subir una actualización en ShoreBird
debe coincidir la versión del pubspec.yaml y la que está subida en la consola
 -- shorebird patch android


user_cargo

administrador, motorizado y dependiente, franquiziado

motorizado, solo ve lo que esta pendiente por recoger, y de entregar solo lo que no se ha recogido.

el administrador debe ver todo, puede recoger y entregar cuando va a entregar un producto colocar un mensaje de que no tiene ese
producto como recogido.

dependiente (los que solicita) puede ver todas las transferencias que el genera, sin importar quien haya recogido, 
no ve lo que le pidieron, no es de su interes. 
en el historial solo ve lo que solicita, 

otro campo que pone user_pertenece allí aparece a que usuario pertence cada usuario

match entre rol depentiende, user_pertenece con la parma solicita, por recoger por entregar o ya en historial
ve los 3 estados de la farmacia que solicito la farmacia del dependiente a que pertenece.

mensaje de falla de internet.

poner version de la aplicacion en el drawbar

pendiente al filtro de la ubicacion de farmacia.




para shorebird 
shorebird release android --artifact apk

flu