%{
#include <stdio.h>
#include <stdlib.h>

/* Prototipo de la función yylex generado por Flex */
int yylex(void);

/* Prototipo de la función de error */
void yyerror(const char *s);
%}

/* Definimos los tipos de tokens */
%token <num> NUMBER

/* Definimos la precedencia de operadores */
%left '+' '-'
%left '*' '/'
%right UMINUS

/* Definimos el tipo de valor */
%union {
    int num;
}

/* Declaramos el tipo de valor para los tokens y las reglas */
%type <num> expr

%%

/* Reglas gramaticales */
input:
    /* Vacío */
    | input expr '\n' { printf("Resultado: %d\n", $2); }
    ;

expr:
    NUMBER          { $$ = $1; }
    | expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { 
        if ($3 == 0) {
            yyerror("Error: división por cero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | '(' expr ')'  { $$ = $2; }
    ;

%%

/* Función de error */
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("Calculadora básica (Ctrl+C para salir)\n");
    yyparse();
    return 0;
}
