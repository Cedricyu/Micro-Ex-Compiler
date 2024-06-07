%{
#include "y.tab.h"
#include "final.h"
#include <math.h>
#include <stdio.h>

#undef YY_READ_BUF_SIZE
#define YY_READ_BUF_SIZE 65536

%}

%option yylineno

%%
([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?) {
    yylval.dval = atof(yytext);
//    printf("Recognized NUMBER: %s\n", yytext);
    return NUMBER;
}

[ \t]+ ; /* ignore white space */

[Pp][Rr][Oo][Gg][Rr][Aa][Mm] { 
//    printf("Recognized PROGRAM\n");
    return PROGRAM; 
}

[Dd][Ee][Cc][Ll][Aa][Rr][Ee] { 
//    printf("Recognized DECLARE\n");
    return DECLARE; 
}

[Aa][Ss] { 
//    printf("Recognized AS\n");
    return AS; 
}

[Ii][Nn][Tt][Ee][Gg][Ee][Rr] { 
//    printf("Recognized INT_TYPE\n");
    return INT_TYPE; 
}

[Ff][Ll][Oo][Aa][Tt] { 
//    printf("Recognized FLOAT_TYPE\n");
    return FLOAT_TYPE; 
}

[Bb][Ee][Gg][Ii][Nn] { 
//    printf("Recognized BEGIN_PROG\n");
    return BEGIN_PROG; 
}

[Ee][Nn][Dd] { 
//    printf("Recognized END_PROG\n");
    return END_PROG; 
}

[Ff][Oo][Rr] {
    return FOR;
}

[Ee][Nn][Dd][Ff][Oo][Rr] {
    return ENDFOR;
}

[Tt][Oo] {
    return TO;
}

[Dd][Oo][Ww][Nn][Tt][Oo] {
    return DOWNTO;
}
[Ii][Ff] {
    return IF;
}

[Tt][Hh][Ee][Nn] {
    return THEN;
}
[Ee][Ll][Ss][Ee] {
    return ELSE;
}

[Ee][Nn][Dd][Ii][Ff] {
    return ENDIF;
}

":=" {
//    printf("ASSIGN\n");
    return ASSIGN;
}

">="            { return GE; }
"<="            { return LE; }
"!="            { return NE; }
"=="            { return EQ; }
">"             { return GT; }
"<"             { return LT; }

[A-Za-z][A-Za-z0-9]* {
    yylval.symp = symlook(yytext);
//    printf("Recognized NAME: %s\n", yytext);
    return NAME;
}

\n { 
//    printf("Recognized newline\n");
}

. { 
//    printf("Recognized single character: %c\n", yytext[0]);
    return yytext[0]; 
}

<<EOF>> { 
//    printf("Recognized EOF\n");
    return 0; 
}
%%

/* No main or yyerror definition in the lexer file */

