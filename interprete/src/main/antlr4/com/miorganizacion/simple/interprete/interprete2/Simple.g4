grammar Simple;

@parser::header {
	import java.util.Map;
	import java.util.HashMap;
	import java.util.List;
	import java.util.ArrayList;
	import com.miorganizacion.simple.interprete2.ast.*;
}

@parser::members {
	Map<String, Object> symbolTable = new HashMap<String, Object>();
}

program: PROGRAM ID BRACKET_OPEN
	/* Declaraciones para analisis */
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
		Map<String, Object> symbolTable = new HashMap<String, Object>();
	}
	(sentence {body.add($sentence.node);})* /* Contenido del programa */
	BRACKET_CLOSE
	{
		for(ASTNode n : body) {
			n.execute(symbolTable);
		}
	};

/* Clasifica cada nodo */
sentence returns [ASTNode node]: 
	println {$node = $println.node;} 
	| conditional {$node = $conditional.node;}
	| var_decl {$node = $var_decl.node;}
	| var_assign {$node = $var_assign.node;}
	| sqrt {$node = $sqrt.node;}
	| stdev {$node = $stdev.node;};
	
println returns [ASTNode node]: PRINTLN expression SEMICOLON
	{$node = new Println($expression.node);};
	
conditional returns [ASTNode node]: IF PAR_OPEN expression PAR_CLOSE
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
	}
	BRACKET_OPEN (s1 = sentence{body.add($s1.node);})* BRACKET_CLOSE
	ELSE
	{
		List<ASTNode> elseBody = new ArrayList<ASTNode>();
	}
	BRACKET_OPEN (s2=sentence {elseBody.add($s2.node);})* BRACKET_CLOSE
	{
		$node = new If($expression.node, body, elseBody);
	};

/* Declaracion de var */
var_decl returns [ASTNode node]:
	VAR ID SEMICOLON {$node = new VarDecl($ID.text);};

/* Guarda valor de variable en tabla */
var_assign returns [ASTNode node]:
	ID ASSIGN expression SEMICOLON {$node = new VarAssign($ID.text, $expression.node);};
	
sqrt returns [ASTNode node]:
	SQRT expression SEMICOLON {$node = new SquareRoot($expression.node);};
	
stdev returns [ASTNode node]:
	{List<ASTNode> numbers = new ArrayList<ASTNode>();}
	STDEV PAR_OPEN 
	(n1 = expression{numbers.add($n1.node);} COMMA)* n2 = expression{numbers.add($n2.node);}
	PAR_CLOSE SEMICOLON
	{
		$node = new StandardDev(numbers);
	};

/* Expresion con prioridad a factores y term parentesis */
expression returns [ASTNode node]:
	t1 = factor {$node = $t1.node;}
	(AND t2 = factor {$node = new And($node, $t2.node);})*
	| (PLUS t2=factor {$node = new Addition($node, $t2.node);})*;

/* Factor evalua multiplicaciones con prioridad */
factor returns [ASTNode node]: 
	t1 = term {$node = $t1.node;}
	(MULT t2=term {$node = new Multiplication($node, $t2.node);})*;
	
term returns [ASTNode node]:
	NUMBER {$node = new Constant(Integer.parseInt($NUMBER.text));}
	| BOOLEAN {$node = new Constant(Boolean.parseBoolean($BOOLEAN.text));}
	| ID {$node = new VarRef($ID.text);}
	| PAR_OPEN expression {$node = $expression.node;} PAR_CLOSE;

PROGRAM: 'program';
VAR: 'var';
PRINTLN: 'println';
IF: 'if';
ELSE: 'else';
SQRT: 'sqrt';
STDEV: 'stdev';

PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';

AND: '&&';
OR: '||';
NOT: '!';

GT: '>';
LT: '<';
GEQ: '>=';
LEQ: '<=';
EQ: '==';
NEQ: '!=';

ASSIGN: '=';

BRACKET_OPEN: '{';
BRACKET_CLOSE: '}';

PAR_OPEN: '(';
PAR_CLOSE: ')';

SEMICOLON: ';';
COMMA: ',';

BOOLEAN: 'true' | 'false';

ID: [a-zA-Z_][a-zA-Z0-9]*;

NUMBER: [0-9]+;

WS: [ \t\n\r]+ -> skip;