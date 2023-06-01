<h1 style="text-align: center">Resaltador de Sintaxis</h1>
<p> Materia

<ul>
<li> Implementacion de Metodos Computacionales
</ul>

<p> Profesor 

<ul>
<li> Gilberto Echeverria Furio
</ul>





<p>Alumnos</p>

<ul>

<li>Miguel Angel Cabrera Victoria | A01782982

<li> David Santiago Vieyra Garcia | A01656030

<li>Jose Daniel Rodriguez Cruz    | A01782933

</ul>

<hr>
<b> Introducción </b>
<br>
<br>

<p>En este proyecto se planteara los metodos cumputacionales que se implementaron con el fin de elaborar el archivo "DFA.exs", dichos archivos estan basados en el lenguaje de programación  funcionnal Elixir con el objetivo que convierta la entrada de un archivo de JSON o Python dando como salida otro archivo HTML separando el lexico correspodiente de acuerdo a la syntaxis correcta para cada lenguaje</p>

<p>Este informe tiene como objetivo proporcionar una descripción detallada del funcionamiento de un autómata finito determinado (DFA). El propósito es comprender la lógica por detrás en la asignación de sintaxis y la separación de tipos de tokens. </p>

<b>Funcionamiento del codigo</b>
<br>
<br>



<p>El funcionamiento del script comienza definiendo el modulo <b>JSON</b>, por que pasa a llamarse el funcion </b>readerWritter</b> el cual cuanto con dos parametros llamados "in_filename", "out_filename" con el fin de recivir el nombre de archivos de entrada y salida, esta función se encarga de leer el contenido del archivo que se le da como entrada y procesar linea por linea para tener una salida en formato HTML resaltando la syntaxis que habia detro del archivo de entrada.</p>

<p>La siguiente funcion que sigue conforme al objetivo pricipal del reto es <b>evaluateLine</b> la cual tiene el objetivo de procesar cada linea del archivo de entrada y segmentar los caracteres de manera individual, por lo manda a llamar a otra funcion llamada <b>recursion_function</b> dentro de esta misma , el fin de esta función es como el mismo nombre lo declara es procesar recursivamente los caracteres de entrada dentro de una lista, tomando los caracteres de entrada, la lista de tokens acumulados asi como el token y estado actual, invietiendose con el metodo "Enum.reverse" debido a que se aculuman de manera inversa a lo que esperamos como salida y finalente uniendolos en una solo cadana de caracteres</p>

<p>La funcion <b>stepper</b> tiene el fin de realizar las transiciones de estado basadas en los caracteres que se dieron de entrada asi como el estado actual, por lo que se busco hacer un "do" para hacer una comparacion y buscar la semenjanza y determinar el nuevo estado y un indicador valido para el DFA<p>

<b>Reflexion</b>

<p>El uso de un DFA es analizar la sintaxis de un lenguaje, como en este caso la sintaxis JSON siendo un componente esencial para el analisis de la syntaxis, proporcionando una manera sencilla de determinar y clasificar tokens en un conjunto de caracteres<p>

<p>El codigo brindado se utiliza para indetificar y resaltar componentes de la syntaxis JSON como Python , ya sea como la llaves y los caracteres de puntuacion, sin embargo este script es un pequeña parte de un DFA completo debido a que no se cuenta con todas las reglas, por lo que llegamos a la reflexion que gracias a estos componentes vistos en clase pudimos saber el funcionamiento que se maneja por atras para relizar las herrameintas de un Ingeniero en Software que uno de sus principales herramientas son los lenguajes de programacion, siendo un proceso desafiente y complejo de resolver debido a los estados, movimmientos de estados y acciones que debe tomar, hay que resaltar que esta función utiliza el funcionamiento de un Automata (DFA) para realizar un estado de syntaxis</p>



