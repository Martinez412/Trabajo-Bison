%{
#include "calculadora.tab.h"
%}

%%

[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[\t ]+          { /* Ignorar espacios en blanco */ }
\n              { return '\n'; }
[-+*/()]        { return yytext[0]; }

.               { /* Cualquier otro carácter */ }

%%

int yywrap(void) {
    return 1;
}
