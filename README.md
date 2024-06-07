系統編譯設計 FINAL: COMPILER of Micro/EX
===
##### 臺師大資工 40844029S 游明睿

input(範例輸入)
---
```Program testP
Begin 
declare I as integer;
declare A,B,C,D, LLL[100] as float;
FOR (I:=1 TO 100)
 A:=-LLL[I]+B*D-C;
ENDFOR
IF (A>=10000.0) THEN
 print(A+3.14);
ELSE
 print(2,1.4);
ENDIF
End
```


output(範例輸出)

```
40844029s@telnet:~/CompilerPrograms/FinProject$ ./final < input
        START testP
        Declare I as Integer
        Declare A as Float
        Declare B as Float
        Declare C as Float
        Declare D as Float
        Declare LLL as Float_array,100

        I_Store I,1
lb&1:   F_UMINUS LLL[I], T&1
        F_MUL B, D, T&2
        F_ADD T&1, T&2, T&3
        F_SUB T&3, C, T&4
        F_Store A,T&4
        INC I
        ICMP I, 100
        JLE lb&1

        F_CMP A, 10000.000000
        JL lb&2
        F_ADD A, 3.140000, T&1
        CALL print,T&1
        J lb&3
lb&2:   CALL print,2.000000,1.400000
lb&3:   HALT testP

Declare T&1, Float
Declare T&2, Float
Declare T&3, Float
Declare T&4, Float
```
for
---

---
- reduction rule
```
FORSTMT:	FORLOOP STMT_LIST ENDFOR

FORLOOP:	FOR '(' ASSIGNMENT TO EXPRESSION ')' | 	FOR '(' ASSIGNMENT DOWNTO EXPRESSION ')'

```
- downto for

```
FOR (I:=100 DOWNTO 1)
 A:=-LLL[I]+B*D-C;
ENDFOR
```

```
        I_Store I,100
lb&1:   F_UMINUS LLL[I], T&1
        F_MUL B, D, T&2
        F_ADD T&1, T&2, T&3
        F_SUB T&3, C, T&4
        F_Store A,T&4
        DEC I
        ICMP I, 1
        JGE lb&1
```
- 實作for to expression類別
```
FOR (I:=1 TO 100*J+6)
 A:=-LLL[I]+B*D-C;
ENDFOR
```
```
        I_Store I,1
        F_MUL 100.000000, J, T&1
        F_ADD T&1, 6.000000, T&2
lb&1:   F_UMINUS LLL[I], T&3
        F_MUL B, D, T&4
        F_ADD T&3, T&4, T&5
        F_SUB T&5, C, T&6
        F_Store A,T&6
        INC I
        ICMP I, T&2
        JLE lb&1
```


if-else
---
- reduction rule
```
IFSTMT: 	IF_PART ELSE_PART ENDIF

IF_PART: 	IF '(' COMP ')' THEN STMT_LIST 

ELSE_PART: 	ELSE STMT_LIST 
	
COMP: 		NAME COMPARATOR EXPRESSION 

COMPARATOR: 	'>'  
          | 	'<'  
          |	  GE  
          | 	LE   
          | 	NE   
          | 	EQ   

```

```
IF (A>=10000.0) THEN
 A:=A+1;
ELSE
 A:=B*C;
ENDIF
```
```
 F_CMP A, 10000.000000
        JL lb&2
        F_ADD A, 1.000000, T&1
        F_Store A,T&1
        J lb&3
lb&2:   F_MUL B, C, T&1
        F_Store A,T&1
lb&3:   HALT testP
```
nested if-else
```
IF (A>=10000.0) THEN
 IF (B<=0.0) THEN
 print(A+3.14);
 ELSE
 print(A+3.14*10);
 ENDIF
ELSE
 print(2,1.4);
ENDIF

```
```
        F_CMP   A, 10000.000000
        JL lb&2
        F_CMP B, 0.000000
        JG lb&3
        F_ADD A, 3.140000, T&1
        CALL print,T&1
        J lb&4
lb&2:   F_MUL 3.140000, 10.000000, T&2
        F_ADD A, T&2, T&3
        CALL print,T&3
lb&3:   J lb&5
lb&4:   CALL print,2.000000,1.400000
lb&5:   HALT testP
```

- tmp declartion
```
        F_UMINUS LLL[I], T&1
        F_MUL B, D, T&2
        F_ADD T&1, T&2, T&3
        F_SUB T&3, C, T&4
        F_Store A,T&4

        F_ADD A, 3.140000, T&1

        Declare T&1, Float
        Declare T&2, Float
        Declare T&3, Float
        Declare T&4, Float
```
> 重複利用使用過的tmp變數 減少變數宣告


function call
---
- reduction rule
```
FUNCTION:	NAME '(' PARAMETERS ')' 

PARAMETERS :	PARAMETER 
	|	PARAMETERS ',' PARAMETER

PARAMETER : 	
		EXPRESSION	

```
```
print(A+3.14);
```

```
        F_ADD A, 3.140000, T&1
        CALL print,T&1
```

## comments

- data structures

```c
int top = 1, tail = 1; /// for symtable

int labelcnt = 0; /// for label

// for for-loop implement
#define NFS 10
struct forstack {
    char *itername;
    int label;
} forstack[NFS];
int forstacktop = 0;  
int foropt = 0;
int tmpcnt = 0;
int maxtmpcnt = 0;
#define MAX(a,b) (((a)>(b))?(a):(b))

struct symtab *expstack[50];  // for expresion 
int exptop = 0;


/// for if-else
#define NIQ 10
struct ifqueue {
    int label;

} ifqueue[NIQ];
int ifqueuenear, ifqueuerear = 0;

// for function call
char *parmlist[10];
int parmcnt = 0;
```


- 心得

在這次實作compiler的過程中，我感到自身實作能力上存在許多不足，但也意外收穫了很多。在這次的過程中，我學會了除了利用parse tree來儲存目前資訊外，還可以運用許多資料結構來管理在reduce過程中可能會用到的資料。

此外，我意識到許多reduction rule可能會有衝突的情況，可能可以從好幾種不同的路線進行reduce。儘管目前還沒有找到好的解決方案，但由於目前的執行沒有問題，所以暫且忽略這個問題。

這次的實作經驗讓我對編譯器的設計和實作有了更深的理解，也意識到了自己在這方面需要加強的地方。
