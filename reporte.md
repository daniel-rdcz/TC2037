<h1 style="text-align: center">Resaltador de Sintáxis</h1>
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

<li>Jose Daniel Rodriguez Cruz    | A01781933

</ul>

<hr>
<b> Introducción </b>
<br>
<br>

<p>En este proyecto se busco aplicar los métodos computacionales de creación de un DFA para lograr crear un archivo el cual fuera capaz de convertir archivos ".json" o ".py" en archivos HTML los cuales cumplieran con la resaltación de su sintáxis dependiendo de los tokens encontrados dentro de los archivos de entrada.<p>

<p>Este informe tiene como objetivo proporcionar una descripción detallada del funcionamiento de un autómata finito determinado (DFA) utilizado en el poryecto. El propósito es comprender la lógica por detrás en la asignación de sintaxis y la separación de tipos de tokens. </p>

<b>Funcionamiento del codigo</b>
<br>
<br>

<p>El funcionamiento del script comienza definiendo 2 módulos dependiendo de el tipo de archivo que se quiera formatear; el módulo JSON y el módulo Python, una vez llamados estos módulos se ejecutara la función <b>readerWritter</b> la cual resivira los archivos de entrada dividirlos por línea para posteriormente con ayuda de otras funciones analisar char por char que tipo de token es, una vez analizadas y formateadas todas las líneas se retornara el archivo HTML con la sintáxis correcta para que se ejecute y se logren ver todos los token encontrados resaltados de diferente color según el tipo de token.<p>

<p>La función <b>evaluateLine</b> tiene el objetivo de procesar cada línea del archivo de entrada y segmentar los carácteres de manera individual, posteriormente manda a llamar a otra función, <b>recursion_function</b>, dentro de esta misma. El fin de esta función es como el mismo nombre lo declara es procesar recursivamente los carácteres de entrada dentro de una lista, tomando los carácteres de entrada, la lista de tokens acumulados así como el token y estado actual, invietiéndolos con el método "Enum.reverse" debido a que se aculuman de manera inversa a lo que esperamos como salida y finalente uniendolos en una solo cadana de carácteres</p>

<p>La funcion <b>stepper</b> tiene el fin de realizar las transiciones de estado, por lo que se busco hacer un "do" para hacer una comparación y determinar el nuevo estado y un indicador valido para el DFA<p>

<video src="./JSONvideo.mp4" controls>
  Tu navegador no admite la etiqueta de video.
</video>

<b>Reflexión</b>

Durante el desarrollo de este proyecto, hemos tenido la oportunidad de aprender y aplicar los métodos computacionales para la creación de un DFA (Autómata Finito Determinado) con el objetivo de resaltar la sintaxis de archivos de código en HTML. Ha sido una experiencia enriquecedora que nos ha permitido profundizar en el conocimiento de los lenguajes de programación y su estructura. Una de las principales lecciones aprendidas es la importancia de entender la lógica detrás de la asignación de la sintaxis y la separación de los diferentes tipos de tokens en un archivo de código. Mediante el análisis de cada carácter y su contexto, pudimos identificar patrones y determinar el tipo de token al que pertenecía. Además, este proyecto nos ha brindado la oportunidad de trabajar en equipo y aprender a organizar y distribuir las tareas de manera eficiente. La colaboración entre los miembros del equipo fue fundamental para el éxito del proyecto, ya que cada uno aportó sus habilidades y conocimientos específicos. A lo largo del proceso, también nos enfrentamos a desafíos técnicos y tuvimos que buscar soluciones creativas. La implementación de los módulos para el procesamiento de archivos JSON y Python nos permitió abordar diferentes formatos de código y adaptar nuestro DFA para cada caso.

En conclusión, este proyecto nos ha proporcionado una experiencia práctica invaluable en la aplicación de métodos computacionales para el procesamiento de lenguajes de programación. Hemos fortalecido nuestras habilidades técnicas, mejorado nuestra comprensión de la sintaxis y adquirido conocimientos que serán útiles en futuros proyectos relacionados con el análisis y procesamiento de código.