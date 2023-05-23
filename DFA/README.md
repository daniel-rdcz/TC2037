# Manual de usuario

David Vieyra

Daniel Rodriguez

2023-03-30

## Descripción
Este programa implementa un Autómata Finito Determinista (DFA) que es capaz de validar expresiones aritméticas. El programa cuenta con dos funciones principales: evaluate-dfa y arithmetic-lexer.

La función evaluate-dfa recibe como entrada la definición de un DFA y una cadena de caracteres, y determina si la cadena pertenece al lenguaje definido por el DFA. Por otro lado, la función arithmetic-lexer es una envoltura de la función evaluate-dfa y se utiliza para validar expresiones aritméticas.

## Cómo utilizar el programa
Para utilizar el programa, es necesario instalar el lenguaje de programación Racket en el equipo. Una vez instalado, se puede copiar el código del programa en un archivo de texto y guardarlo con la extensión ".rkt".

En caso de querer realizar un test con valores propios, utilizar la función 

**(arithmetic-lexer *string*)**

- Donde *string* debe ir entre comillas "*string*" y sera el la expresion aritmetica a evaluar

Puede compilar el programa y ponerlo cuando se este ejecutando el mismo o lo pude poner al final del código con los valores deseados en el apartado de string.
