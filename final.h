#define NSYMS 20 /* maximum number of symbols */

struct symtab {
    char *name;
    double value;
#define TYPE_INT 0
#define TYPE_FLOAT 1
    int type;
    int size;
} symtab[NSYMS];

struct symtab *symlook(char *s);

#define NFS 10
struct forstack {
    char *itername;
    int label;
} forstack[NFS];

#define NIQ 10
struct ifqueue {
    int label;

} ifqueue[NIQ];
