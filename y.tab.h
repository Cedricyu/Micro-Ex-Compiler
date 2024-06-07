
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUMBER = 258,
     NAME = 259,
     PROGRAM = 260,
     DECLARE = 261,
     AS = 262,
     INT_TYPE = 263,
     FLOAT_TYPE = 264,
     BEGIN_PROG = 265,
     END_PROG = 266,
     ASSIGN = 267,
     FOR = 268,
     ENDFOR = 269,
     TO = 270,
     DOWNTO = 271,
     IF = 272,
     THEN = 273,
     ELSE = 274,
     ENDIF = 275,
     GT = 276,
     LT = 277,
     GE = 278,
     LE = 279,
     NE = 280,
     EQ = 281,
     UMINUS = 282
   };
#endif
/* Tokens.  */
#define NUMBER 258
#define NAME 259
#define PROGRAM 260
#define DECLARE 261
#define AS 262
#define INT_TYPE 263
#define FLOAT_TYPE 264
#define BEGIN_PROG 265
#define END_PROG 266
#define ASSIGN 267
#define FOR 268
#define ENDFOR 269
#define TO 270
#define DOWNTO 271
#define IF 272
#define THEN 273
#define ELSE 274
#define ENDIF 275
#define GT 276
#define LT 277
#define GE 278
#define LE 279
#define NE 280
#define EQ 281
#define UMINUS 282




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 42 "final.y"

    double dval;
    struct symtab *symp;
    char *str;
    struct fortab *forp;
    int ival;



/* Line 1676 of yacc.c  */
#line 116 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


