<h1 style="text-align: center">Resaltador de Sintáxis Paralelo</h1>
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

<li> David Santiago Vieyra Garcia | A01656030

<li>Jose Daniel Rodriguez Cruz    | A01781933

<br>
<b>Análisis de complejidad del algoritmo</b>

La complejidad general del código depende del número de líneas en el archivo de entrada y del número de caracteres en cada línea. Aquí está un resumen de las complejidades de las funciones principales:

- writter(in_filename, out_filename): Complejidad O(N), donde N es el número de líneas en el archivo de entrada.
- write_html_file(file_path, text): Complejidad O(1).
- write_css_file(file_path): Complejidad O(1).
- evaluateLine(line): Complejidad O(M), donde M es el número de caracteres en la línea.
- recursion_function/4: Complejidad O(M), donde M es el número de caracteres en la línea.
- classer(token, state) y stepper(state, char): Complejidad O(1) Esto se debe a que no hay bucles ni iteraciones que dependan del tamaño de entrada. El tiempo de ejecución de la función no aumenta a medida que el tamaño de entrada crece, ya que el número de declaraciones condicionales (state == ...) es fijo y no cambia.

<br>
<b>Conclusiones</b>

En conclusión, al analizar el speedup de nuestro programa al ejecutarlo de forma paralela, a pesar de la existencia de algunos bugs en la medición del tiempo de ejecución, se observa una mejora significativa en el rendimiento. Esto demuestra el prometedor potencial de la programación paralela para acelerar el procesamiento de tareas, además, es importante destacar que el tiempo de ejecución observado, aproximadamente 15 milisegundos, es notablemente bajo en comparación con la complejidad del algoritmo utilizado, que es O(n). Esta eficiencia y escalabilidad del algoritmo son aspectos positivos en términos de rendimiento y optimización del programa.

En resumen, la ejecución paralela ha mostrado ser una estrategia eficaz para mejorar el tiempo de ejecución, y el algoritmo implementado ha demostrado ser eficiente y escalable, lo cual es prometedor para futuros desarrollos y optimizaciones en el procesamiento de tareas.

<b>Reflexión sobre las implicaciones éticas</b>

Es importante considerar las implicaciones éticas que el desarrollo de este tipo de tecnología puede tener en la sociedad. Si bien la optimización de programas y el uso de la programación paralela pueden brindar beneficios en términos de eficiencia y rendimiento, es necesario abordar las posibles desigualdades y efectos negativos que pueden surgir, por ejemplo, al acelerar el procesamiento de tareas, es posible que se aumente la demanda de recursos computacionales, lo que podría llevar a un mayor consumo de energía. Esto plantea preocupaciones ambientales y la necesidad de garantizar prácticas de desarrollo sostenible, además, es fundamental asegurarse de que la implementación de tecnologías como la programación paralela no genere exclusiones o amplíe la brecha digital. Es esencial considerar la accesibilidad y la equidad en el acceso a la tecnología para evitar la creación o perpetuación de disparidades sociales.

En resumen, si bien el desarrollo de tecnologías eficientes y de alto rendimiento puede ser beneficioso, es necesario abordar las implicaciones éticas y sociales para garantizar que se utilicen de manera responsable, inclusiva y sostenible.