Integrantes:

- Bryan Ariza
- Andres Toledo
- Juan Wilches
- Manuel Cardenas

Descripción del Proyecto:En este problema, se busca utilizar BISON, una herramienta para la generación de analizadores sintácticos, para implementar y ejecutar una calculadora que pueda realizar operaciones matemáticas básicas y manejar errores. Los pasos a seguir incluyen la instalación de BISON, la localización y ejecución de un ejemplo de calculadora proporcionado en la documentación de BISON (Ejemplo 1-5), y la realización de pruebas funcionales para garantizar el correcto funcionamiento de la calculadora.

Instalacion de Bison en linux:

-Actualiza la lista de paquetes para hace eso necesitas Abrir tu terminal de linux y ejecutar:

         sudo apt update
         
-Luego de eso Instala Bison y Flex para eso usa el siguiente comando para instalarlo 

         sudo apt install bison
         sudo apt-get install bison flex
         
-Para asegurarte de que Bison se ha instalado correctamente puedes verificar su versión
                
        bison --version
        flex  --version

COMPILACION Y EJECUCION

Para compilar y ejecutar esta calculadora generada por bison debes seguir esta linea de pasos

-Generar el código C con Flex y Bison:

         flex calculadora.l
         bison -d calculadora.y

Esto genera lex.yy.c, calculadora.tab.c, y calculadora.tab.h.

-Luego compila el codigo C generado:

         gcc lex.yy.c calculadora.tab.c -o calculadora -lm
El flag -lm es necesario para vincular la biblioteca matemática estándar.

-Ejecutar la calculadora:

         ./calculadora
         
Introduce una expresión matemática y presiona Enter para ver el resultado.

FUNCIONAMIENTO DE LA CALCULADORA

Para entender el funcionamiento de la calculadora el usuario introduce una expresión matemática, por ejemplo:

         ./calculadora 3 + 5 * (2 - 8) 
          
  Flex divide la entrada en tokens: NUMERO(3), SUMA(+), NUMERO(5), MULTIPLICACION(*), PARENIZQ((), NUMERO(2), RESTA(-), NUMERO(8), PARENDER()).  

  Otro ejemplo de uso seria el siguente comando que funciona a la perfeccion

           ./calculadora 3 + 2
           

TONKENZICACION

La tokenización es el proceso de dividir una secuencia de caracteres (como una expresión matemática) en unidades más pequeñas llamadas tokens. Cada token representa una unidad significativa, como un número, un operador o un paréntesis.

*La calculadora utiliza Flex para la tokenización. Flex es un generador de analizadores léxicos que define patrones de búsqueda para identificar tokens específicos en una entrada.

*En nuestro caso, los tokens incluyen números (NUMERO), operadores (SUMA, RESTA, MULTIPLICACION, DIVISION), y paréntesis (PARENIZQ, PARENDER).

En el archivo "calculadora.l" contiene las reglas de tokenización definidas por expresiones regulares:


         %{
     #include "calculadora.tab.h"
     %}

     %%

     [0-9]+      { return NUMERO; }
     \+          { return SUMA; }
     \-          { return RESTA; }
      \*          { return MULTIPLICACION; }
      \/          { return DIVISION; }
     \(          { return PARENIZQ; }
     \)          { return PARENDER; }
     [\t\n ]+    { /* Ignorar espacios en blanco y saltos de línea */ }
     .           { printf("Carácter no reconocido: %s\n", yytext); }

    %%

- [0-9]+: Detecta secuencias de dígitos y las clasifica como NUMERO.
- +, -, *, /: Son detectados y clasificados como operadores matemáticos (SUMA, RESTA, MULTIPLICACION, DIVISION).
- ( y ): Clasificados como paréntesis izquierdo y derecho (PARENIZQ, PARENDER).
  
ANALISIS:

-Bison recibe los tokens generados por Flex y los utiliza para construir un árbol de sintaxis siguiendo las reglas de gramática definidas en calculadora.y.
-Las reglas de gramática en calculadora.y definen cómo los tokens se agrupan para formar expresiones válidas:

     expresion: expresion SUMA expresion
          { $$ = $1 + $3; }
        | expresion RESTA expresion
          { $$ = $1 - $3; }
        | expresion MULTIPLICACION expresion
          { $$ = $1 * $3; }
        | expresion DIVISION expresion
          { $$ = $1 / $3; }
        | '(' expresion ')'
          { $$ = $2; }
        | NUMERO
          { $$ = $1; };
-Estas reglas indican cómo evaluar expresiones matemáticas y construir el árbol de sintaxis abstracta (AST). El $1, $2, $3

Representan los valores de los tokens y $$ el resultado de la evaluación de la regla.

EVALUACION DE LA EXPRESION:
Bison evalúa el árbol de sintaxis utilizando las acciones especificadas en las reglas de gramática.
Siguiendo lo que veniamos explicando anteriormente, el proceso de evaluación sería el siguente

1) Evaluar (2 - 8):

Usa la regla ´expresion: expresion RESTA expresion.

$$ = 2 - 8; ⇒ Resultado: -6.

2) Evaluar 5 * -6:

Usa la regla ´expresion: expresion MULTIPLICACION expresion.

$$ = 5 * -6; ⇒ Resultado: -30.

3) Evaluar 3 + (-30):

Usa la regla ´expresion: expresion SUMA expresion.

$$ = 3 + (-30); ⇒ Resultado: -27.

La evaluación sigue un orden de precedencia definido por las reglas en Bison. Primero se evalúan las operaciones dentro de los paréntesis, luego la multiplicación/división, y finalmente la suma/resta.

Una vez evaluada la expresión completa, el resultado es devuelto y mostrado al usuario. En este caso el ejemplo que se acabo de monstrar el resultado sería -27.

EVALUACION Y CONCLUSION FINAL:

Esta calculadora simple utiliza Bison y Flex para interpretar y evaluar expresiones matemáticas. Flex maneja la tokenización, dividiendo la entrada en tokens significativos, mientras que Bison analiza la estructura sintáctica de los tokens y evalúa el resultado final. Este enfoque modular facilita la extensión de la calculadora para soportar funciones más complejas y nuevos operadores.

