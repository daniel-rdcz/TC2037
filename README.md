<h1 style="text-align: center">Resaltador de Sintáxis Instructivo</h1>
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

## Forma de uso 

<br>

<b>Ejemplos base</b>

Al unicamente ejecutar el programa nos generará 3 archivos por lenguaje con casos base de uso

    Para JSON
    "iex JSON.exs"

    Para Python
    "iex Python.exs"

<b>Archivo propio</b>

Para utilizar el programa con archivos propios ejecutaremos el programa con los comandos del punto anterior, posteriormente llamaremos al módulo general de cada archivo y ejecutaremos la funciónn <b>writter</b>. Como primer parámetro de la función mandaremos el archivo a analizar entre comillas y como segundo parámetro enviaremos el nombre deseado para nuestro archivo HTML con la terminación ".html" y entrecomillado de igualmanera.

    Para JSON
    $"iex JSON.exs"
    >JSON.writter("archivo.json", "nombre_archivo.html")

    Para Python
    "iex Python.exs"
    >Python.writter("archivo.py", "nombre_archivo.html")

**Es importante que se esté en la carpeta que contenga el archivo para poder ejecutalo, los archivos estan en las carpetas "JSON" y "Python" respectivamente.**