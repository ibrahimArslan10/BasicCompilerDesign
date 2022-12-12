%{
	#include <stdio.h>
	#include <string.h>
	

	struct symboltable
	{
		char name[100];
		char type[100];
		int length;
	}ST[1007];

	struct constanttable
	{
		char name[100];
		char type[100];
		int length;
	}CT[1007];

	int hash(char *str)
	{
		int value = 0;
		for(int i = 0 ; i < strlen(str) ; i++)
		{
			value = 10*value + (str[i] - 'A');
			value = value % 1007;
			while(value < 0)
				value = value + 1007;
		}
		return value;
	}

	int lookupST(char *str)
	{
		int value = hash(str);
		if(ST[value].length == 0)
		{
			return 0;
		}
		else if(strcmp(ST[value].name,str)==0)
		{
			return 1;
		}
		else
		{
			for(int i = value + 1 ; i!=value ; i = (i+1)%1007)
	    	{
	    		if(strcmp(ST[i].name,str)==0)
	    		{
	    			return 1;
	    		}
	    	}
	    	return 0;
	    }
	}
	void insertST(char *str1, char *str2)
	{
		if(lookupST(str1))
		{
		    return;
	    }
		else
		{
			int value = hash(str1);
			if(ST[value].length == 0)
			{
				strcpy(ST[value].name,str1);
				strcpy(ST[value].type,str2);
				ST[value].length = strlen(str1);
				return;
			}

			int pos = 0;

			for (int i = value + 1 ; i!=value ; i = (i+1)%1007)
			{
				if(ST[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(ST[pos].name,str1);
			strcpy(ST[pos].type,str2);
			ST[pos].length = strlen(str1);
		}
	}
	void printST()
	{
		for(int i = 0 ; i < 1007 ; i++)
		{
			if(ST[i].length == 0)
			{
				continue;
			}

			printf("%s\t%s\n",ST[i].name, ST[i].type);
		}
	}
	int lookupCT(char *str)
	{
		int value = hash(str);
		if(CT[value].length == 0)
			return 0;
		else if(strcmp(CT[value].name,str)==0)
			return 1;
		else
		{
			for(int i = value + 1 ; i!=value ; i = (i+1)%1007)
			{
				if(strcmp(CT[i].name,str)==0)
				{
					return 1;
				}
			}
			return 0;
		}
	}
	void insertCT(char *str1, char *str2)
	{
		if(lookupCT(str1))
			return;
		else
		{
			int value = hash(str1);
			if(CT[value].length == 0)
			{
				strcpy(CT[value].name,str1);
				strcpy(CT[value].type,str2);
				CT[value].length = strlen(str1);
				return;
			}

			int pos = 0;

			for (int i = value + 1 ; i!=value ; i = (i+1)%1007)
			{
				if(CT[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(CT[pos].name,str1);
			strcpy(CT[pos].type,str2);
			CT[pos].length = strlen(str1);
		}
	}
	void printCT()
	{
		for(int i = 0 ; i < 1007 ; i++)
		{
			if(CT[i].length == 0)
				continue;

			printf("%s\t%s\n",CT[i].name, CT[i].type);
		}
	}

%}

DEF "define"
INC "include"
operator [[<][=]|[>][=]|[=][=]|[!][=]|[>]|[<]|[\|][\|]|[&][&]|[\!]|[=]|[\^]|[\+][=]|[\-][=]|[\*][=]|[\/][=]|[\%][=]|[\+][\+]|[\-][\-]|[\+]|[\-]|[\*]|[\/]|[\%]|[&]|[\|]|[~]|[<][<]|[>][>]]


%%
\n   {yylineno++;}
\/\/(.*) {printf("%s \t- same line comment\n", yytext);}				
([#][" "]*({INC})[ ]*([<]?)([A-Za-z]+)[.]?([A-Za-z]*)([>]?))/["\n"|\/|" "|"\t"] {printf("%s \t-Kütüphane Eklenmesi\n",yytext);}	
[ \n\t] ;
([#][" "]*({DEF})[" "]*([A-Za-z]+)(" ")*[0-9]+)/["\n"|\/|" "|"\t"] {printf("%s \t-Tanımlayıcı\n",yytext);} //Matches definition
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/  {printf("%s \t- Yorum Satırı\n", yytext);}
, {printf("%s \t- Virgül\n", yytext);}
; {printf("%s \t- Noktalı Virgül\n", yytext);}
\} {printf("%s \t- SÜslü Parantez Kapat\n", yytext);}
\] {printf("%s \t- Dizi Parantezi Kapatma Simgesi\n", yytext);}
\( {printf("%s \t- Parantez Aç\n", yytext);}
\) {printf("%s \t- Parantez Kapat\n", yytext);}
\. {printf("%s \t- NOkta\n", yytext);}
\[ {printf("%s \t- Dizi Parantezi Açma Sİmgesi\n", yytext);}
\: {printf("%s \t- İki nokta üst üste\n", yytext);}
\\ {printf("%s \t- Çift Ters Slaş\n", yytext);}
\{ {printf("%s \t- Süslü Parantez Aç\n", yytext);}
auto|break|default|printf|case|void|scanf|const|do|double|long|enum|float|sizeof|for|goto|char|if|int|register|continue|return|short|else|typedef|static|unsigned|struct|switch|signed|union|extern|while|volatile|main/[\(|" "|\{|;|:|"\n"|"\t"] {printf("%s \t- Anahtar Kelime\n", yytext); insertST(yytext, "Anahtar Kelime");}
\"[^\n]*\"/[;|,|\)] {printf("%s \t- String Değişken\n", yytext); insertCT(yytext,"String Değişken");}
\'[A-Z|a-z]\'/[;|,|\)|:] {printf("%s \t- Karakter Değişkeni\n", yytext); insertCT(yytext,"Karakter Değişkeni");}
[a-z|A-Z]([a-z|A-Z]|[0-9])*/\[ {printf("%s \t- Dizi Tanımlama\n", yytext); insertST(yytext, "Identifier");}
~ {return 0;}
{operator}/[a-z]|[0-9]|;|" "|[A-Z]|\(|\"|\'|\)|\n|\t {printf("%s \t- Operatör\n", yytext);} 

[1-9][0-9]*|0/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\]|\}|:|\n|\t|\^] {printf("%s \t- Integer Değişken\n", yytext); insertCT(yytext, "Integer Değişken");}
([0-9]*)\.([0-9]+)/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\t|\^] {printf("%s \t- Float Değişken\n", yytext); insertCT(yytext, "Float Değişken");}
[A-Za-z_][A-Za-z_0-9]*/[" "|;|,|\(|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\.|\{|\^|\t] {printf("%s \t- Tanımlayıcı\n", yytext); insertST(yytext, "Tanımlayıcı");}


(.?) {
		if(yytext[0]=='"')
       	{
       		printf("HATA: SATIR NO: %d\n",yylineno);
       	}
		else if(yytext[0]=='#')
		{
       		printf("HATA: SATIR NO:. %d\n",yylineno);
       	}
		else if(yytext[0]=='/')
	    {
       		printf("HATA: SATIR NO:. %d\n",yylineno);
       	}
       	else
       	{
       		printf("HATA: SATIR NO:. %d\n",yylineno);
       	}
       	printf("%s\n", yytext);
       	return 0;
}
%%

int main(int argc , char **argv){

    printf("****************************SEMBOL TABLOSU********************************\n");

	int i;
	for (i=0;i<1007;i++){
		ST[i].length=0;
		CT[i].length=0;
	}

	yyin = fopen(argv[1],"r");
	yylex();
	
	printf("\n\nSemboL Tablosu\n\n");
	printST();

	printCT();
	printf("*********************SABİTLER TABLOSU***************************************\n");
}

int yywrap(){
    return 1;
}
