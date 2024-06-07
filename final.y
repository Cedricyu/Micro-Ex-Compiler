%{
#include "final.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
char programname[1000];
void yyerror(const char *s);
int yylex(void);
extern int yylineno;
// Define color codes
int top = 1, tail = 1;
int labelcnt = 0;
int forstacktop = 0;
int foropt = 0;
int tmpcnt = 0;
int maxtmpcnt = 0;
#define MAX(a,b) (((a)>(b))?(a):(b))

struct symtab *expstack[50];
int exptop = 0;

int ifqueuenear, ifqueuerear = 0;

char *parmlist[10];
int parmcnt = 0;
#define BLUE "\033[1;34m"
#define RESET "\033[0m"
#define RED "\033[31m"
// Increase the initial stack size

typedef enum {
    COMP_GT,  // Greater than
    COMP_LT,  // Less than
    COMP_GE,  // Greater than or equal
    COMP_LE,  // Less than or equal
    COMP_NE,  // Not equal
    COMP_EQ   // Equal
} Comparator;

%}

%union {
    double dval;
    struct symtab *symp;
    char *str;
    struct fortab *forp;
    int ival;
}

%token <dval> NUMBER
%token <symp> NAME
%token PROGRAM DECLARE AS INT_TYPE FLOAT_TYPE BEGIN_PROG END_PROG ASSIGN FOR ENDFOR TO DOWNTO IF THEN ELSE ENDIF
%token GT LT GE LE NE EQ 
%type <str> TYPE
%type <str> ASSIGNMENT
%type <ival> COMPARATOR
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS
%debug

%%

PROG: PROGRAM_HEADER BEGIN_PROG STMT_LIST END_PROG {
        printf(BLUE "\tHALT %s\n" RESET, programname);
	printf("\n");
	int i = 0;
	for ( i = 0 ; i < maxtmpcnt ; i++)
		printf(BLUE "Declare T&%d, Float\n" RESET, i+1);
    }
;

STMT_LIST: 
	STMT
	| STMT_LIST STMT
;

STMT: 
    DECLARATION_STMT {printf("\n");}
|   ASSIGNMENT ';'{}
|   FORSTMT    	{}
|   IFSTMT	{}
|   FUNCTION ';'{}
;

DECLARATION_STMT: DECLARATIONS;

ASSIGNMENT: NAME ASSIGN EXPRESSION { 
	if ( $1->type == TYPE_INT )
		printf(BLUE "\tI_Store %s,%d\n" RESET, $1->name, atoi(expstack[--exptop]->name));
	else if ( $1->type == TYPE_FLOAT )
		printf(BLUE "\tF_Store %s,%s\n" RESET, $1->name, expstack[--exptop]->name);;
	$$ = $1->name;
	tmpcnt = 0;
}
;

EXPRESSION: EXPRESSION '+' EXPRESSION {
                        printf(BLUE "\tF_ADD %s, %s, T&%d\n" RESET, expstack[--exptop]->name, expstack[--exptop]->name, ++tmpcnt);
                        struct symtab *e = (struct symtab*)malloc(sizeof(struct symtab));
                        if (e == NULL) {
                                yyerror("Memory allocation error");
                                YYABORT;
                        }
                        char name[20];
                        sprintf(name, "T&%d", tmpcnt);
                        e->name = strdup(name);
			expstack[exptop++] = e;
			maxtmpcnt = MAX(maxtmpcnt, tmpcnt);
                }
        |       EXPRESSION '-' EXPRESSION {
                        printf(BLUE "\tF_SUB %s, %s, T&%d\n" RESET, expstack[--exptop]->name, expstack[--exptop]->name, ++tmpcnt);
                        struct symtab *e = (struct symtab*)malloc(sizeof(struct symtab));
                        if (e == NULL) {
                                yyerror("Memory allocation error");
                                YYABORT;
                        }
                        char name[20];
                        sprintf(name, "T&%d", tmpcnt);
                        e->name = strdup(name);
			expstack[exptop++] = e;
			maxtmpcnt = MAX(maxtmpcnt, tmpcnt);
                }
        |       EXPRESSION '*' EXPRESSION {
                        printf(BLUE "\tF_MUL %s, %s, T&%d\n" RESET, expstack[--exptop]->name, expstack[--exptop]->name, ++tmpcnt);
                        struct symtab *e = (struct symtab*)malloc(sizeof(struct symtab));
                        if (e == NULL) {
                                yyerror("Memory allocation error");
                                YYABORT;
                        }
                        char name[20];
                        sprintf(name, "T&%d", tmpcnt);
                        e->name = strdup(name);
			expstack[exptop++] = e;
                        maxtmpcnt = MAX(maxtmpcnt, tmpcnt);
		}
        |       EXPRESSION '/' EXPRESSION {
                        printf(BLUE "\tF_DIV %s, %s, T&%d\n" RESET, expstack[--exptop]->name, expstack[--exptop]->name, ++tmpcnt);
                        struct symtab *e = (struct symtab*)malloc(sizeof(struct symtab));
			if (e == NULL) {
				yyerror("Memory allocation error");
				YYABORT;
			}
			char name[20];
			sprintf(name, "T&%d", tmpcnt);
			e->name = strdup(name);
			expstack[exptop++] = e;
		        maxtmpcnt = MAX(maxtmpcnt, tmpcnt);
		}
        |       '-' EXPRESSION %prec UMINUS {
                        printf(BLUE "\tF_UMINUS %s, T&%d\n" RESET, expstack[--exptop]->name, ++tmpcnt);
			struct symtab *e = (struct symtab*)malloc(sizeof(struct symtab));
                        if (e == NULL) {
                                yyerror("Memory allocation error");
                                YYABORT;
                        }
                        char name[20];
                        sprintf(name, "T&%d", tmpcnt);
                        e->name = strdup(name);
			expstack[exptop++] = e;
                        maxtmpcnt = MAX(maxtmpcnt, tmpcnt);
                }
        |       '(' EXPRESSION ')' {
                }
        |       NAME {
                        expstack[exptop++] = $1;
                }
        |       NUMBER {
 			struct symtab *e = (struct symtab*)malloc(sizeof(struct symtab));
                        if (e == NULL) {
                                yyerror("Memory allocation error");
                                YYABORT;
                        }
                        char name[20];
                        sprintf(name, "%f", $1);
                        e->name = strdup(name);
                        expstack[exptop++] = e;
                }
        |       NAME '[' NAME ']' {
                        struct symtab *e = (struct symtab*)malloc(sizeof(struct symtab));
                        if (e == NULL) {
                                yyerror("Memory allocation error");
                                YYABORT;
                        }
			char name[20];
                        sprintf(name, "%s[%s]", $1->name, $3->name);
			e->name = strdup(name);
			expstack[exptop++] = e;
                }
;

DECLARATIONS: 
     		DECLARATIONS DECLARATION
	|	DECLARATION
;

DECLARATION:
    DECLARE VARIABLES AS TYPE ';'{
        int i;
	for( i = top; i < tail ; i++){
		if ( symtab[i].size )
			printf(BLUE "\tDeclare %s as %s_array,%d\n" RESET, symtab[i].name, $4, symtab[i].size);
		else{
		        printf(BLUE "\tDeclare %s as %s\n" RESET, symtab[i].name, $4);
		}
		if ( strcmp($4, "Integer") == 0 ){
			symtab[i].type = TYPE_INT;
		}
		else if ( strcmp($4, "Float") == 0 ){
                        symtab[i].type = TYPE_FLOAT;
		}
    	}
    	top = tail;
	}
;

VARIABLES: VARIABLE
         | VARIABLES ',' VARIABLE;

VARIABLE: NAME '[' NUMBER ']' {
             	$1->size = $3;
		tail ++;
        }
	| NAME {
		$1->size = 0;
		tail ++;
        };

TYPE:
    INT_TYPE {
        $$ = "Integer";
    }
    | FLOAT_TYPE {
        $$ = "Float";
    }
;

FORSTMT:	FORLOOP STMT_LIST ENDFOR {
	forstacktop--;
	if(foropt)
		printf(BLUE "\tDEC %s\n" RESET, forstack[forstacktop].itername);
	else	
		printf(BLUE "\tINC %s\n" RESET, forstack[forstacktop].itername);
	printf(BLUE "\tICMP %s, %d\n" RESET, forstack[forstacktop].itername, atoi(expstack[--exptop]->name));
        
	if(foropt)
                printf(BLUE "\tJGE lb&%d\n" RESET, forstack[forstacktop].label);
	else
		printf(BLUE "\tJLE lb&%d\n" RESET, forstack[forstacktop].label);
	printf("\n");
};
FORLOOP:	FOR '(' ASSIGNMENT TO EXPRESSION ')'{
	labelcnt ++;
	printf(BLUE "lb&%d:" RESET, labelcnt);
	forstack[forstacktop].label = labelcnt;
	forstack[forstacktop].itername = strdup($3);
	forstacktop++;
	foropt = 0;
}	| 	 FOR '(' ASSIGNMENT DOWNTO EXPRESSION ')'{
        labelcnt ++;
        printf(BLUE "lb&%d:" RESET, labelcnt);
        forstack[forstacktop].label = labelcnt;
        forstack[forstacktop].itername = strdup($3);
        forstacktop++;
	foropt = 1;
};

PROGRAM_HEADER: PROGRAM NAME {
        printf(BLUE "\tSTART %s\n" RESET, $2->name);        
	strcpy(programname, $2->name);
    }
;

IFSTMT: 	IF_PART ELSE_PART ENDIF {
        	};

IF_PART: 	IF '(' COMP ')' THEN STMT_LIST {
            		labelcnt++;
                	ifqueue[ifqueuerear++].label = labelcnt;                        
			printf(BLUE "\tJ lb&%d\n" RESET, labelcnt);
                        printf(BLUE "lb&%d:" RESET, ifqueue[ifqueuenear++].label);
        	};

ELSE_PART: 	ELSE STMT_LIST {
            		printf(BLUE "lb&%d:" RESET, ifqueue[ifqueuenear++].label);
        	};
	
COMP: 		NAME COMPARATOR EXPRESSION {
        	printf(BLUE "\tF_CMP %s, %s\n" RESET, $1->name, expstack[--exptop]->name);    
		labelcnt++;
		ifqueue[ifqueuerear++].label = labelcnt;
		switch ($2) {
			case COMP_GT: 
				printf(BLUE "\tJLE lb&%d\n" RESET, labelcnt);
				break;
			case COMP_LT: 
				printf(BLUE "\tJGE lb&%d\n" RESET, labelcnt);			
				break;
			case COMP_GE: 
				printf(BLUE "\tJL lb&%d\n" RESET, labelcnt);			
				break;
			case COMP_LE: 	
				printf(BLUE "\tJG lb&%d\n" RESET, labelcnt);
				break;
			case COMP_NE: 
				printf(BLUE "\tJE lb&%d\n" RESET, labelcnt);
				break;
			case COMP_EQ: 
	                	printf(BLUE "\tJNE lb&%d\n" RESET, ifqueue[ifqueuenear].label);
				break;
            	}
        };

COMPARATOR: 	'>'  { $$ = COMP_GT; }
          | 	'<'  { $$ = COMP_LT; }
          |	GE   { $$ = COMP_GE; }
          | 	LE   { $$ = COMP_LE; }
          | 	NE   { $$ = COMP_NE; }
          | 	EQ   { $$ = COMP_EQ; };

FUNCTION:	NAME '(' PARAMETERS ')' {
		int i = 0;
		printf(BLUE "\tCALL %s" , $1->name);
		for( i = 0 ; i < parmcnt ; i++ ){
			printf(",%s",parmlist[i]);
			free(parmlist[i]);
		}
		printf(RESET"\n");
		parmcnt = 0;
	}

PARAMETERS :	PARAMETER {}
	|	PARAMETERS ',' PARAMETER {}

PARAMETER : 	
		EXPRESSION	{
		parmlist[parmcnt++] = strdup(expstack[--exptop]->name);
}
%%

int main() {
    yydebug = 0;  // Enable Bison debug output
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, RED "Error at line %d: %s\n" RESET, yylineno, s);
}

struct symtab *symlook(char *s) {
    struct symtab *sp;

    for (sp = symtab; sp < &symtab[NSYMS]; sp++) {
        /* is it already here? */
        if (sp->name && !strcmp(sp->name, s))
            return sp;

        /* is it free */
        if (!sp->name) {
            sp->name = strdup(s);
            return sp;
        }
        /* otherwise continue to next */
    }
    yyerror("Too many symbols");
    exit(1); /* cannot continue */
}

