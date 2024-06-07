all: final

final: lex.yy.c y.tab.c y.tab.h
	gcc lex.yy.c y.tab.c -o final -lfl -ly

y.tab.c y.tab.h: final.y
	yacc -d final.y

lex.yy.c: final.l y.tab.h
	flex final.l

clean:
	rm -f lex.yy.c y.tab.c y.tab.h final

