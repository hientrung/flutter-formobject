grammar Expression;

program: expression EOF;

expression:
	expression LBRACKET expression RBRACKET					# ExistExpression
	| expression DOT IDENTIFIER								# PropertyExpression
	| POW DOT IDENTIFIER									# ParentPropertyExpression
	| PLUS expression										# UnaryPlusExpression
	| MINUS expression										# UnaryMinusExpression
	| NOT expression										# NotExpression
	| expression (MOD | STAR | DIV | POW) expression		# MultiplicativeExpression
	| expression (MINUS | PLUS) expression					# AdditiveExpression
	| expression (GTHAN | GTEQ | LTHAN | LTEQ) expression	# RelationalExpression
	| expression (EQUALS | NOT_EQUALS) expression			# EqualityExpression
	| expression AND expression								# LogicalAndExpression
	| expression OR expression								# LogicalOrExpression
	| expression QMARK expression COLON expression			# TernaryExpression
	| LPAREN expression RPAREN								# ParenthesizedExpression
	| constant												# ConstantExpression
	| IDENTIFIER											# IdentifierExpression;

constant:
	 TRUE
	| FALSE
	| NULL
	| STRING_LITERAL
	| DATE_LITERAL
	| NUM_DOUBLE
	| NUM_INT
	| THIS;

LBRACKET: '[';
RBRACKET: ']';
LPAREN: '(';
RPAREN: ')';
PLUS: '+';
MINUS: '-';
STAR: '*';
DIV: '/';
MOD: '%';
POW: '^';
EQUALS: '==';
NOT_EQUALS: '!=';
LTHAN: '<';
LTEQ: '<=';
GTHAN: '>';
GTEQ: '>=';
AND: '&&';
OR: '||';
NOT: '!';
DOT: '.';
SHARP: '#';
COLON: ':';
DBQ: '"';
QMARK: '?';

fragment DIGIT: '0' ..'9';
fragment HEX: (DIGIT | 'A' ..'F' | 'a' ..'f');
fragment EXPONENT: ('e' | 'E') ('+' | '-')? ('0' ..'9')+;
fragment ESC:
	'\\' (
		'n'
		| 'r'
		| 't'
		| 'b'
		| 'f'
		| '"'
		| '\''
		| '/'
		| '\\'
		| 'u' HEX HEX HEX HEX
		| ('0' ..'3') ( ('0' ..'7') ( ('0' ..'7'))?)?
		| ('4' ..'9') ( ('0' ..'7'))?
	);

STRING_LITERAL: DBQ ( ~('"' | '\\') | ESC)* DBQ;
DATE_LITERAL:
	SHARP ('0'..'9' | 'T' |'Z' | '+' |'-' |'.'|':'|' ')+ SHARP;
NUM_DOUBLE: (NUM_INT DOT DIGIT+) EXPONENT?;
NUM_INT: DIGIT+;

TRUE: 'true';
FALSE: 'false';
NULL: 'null';
THIS: 'this';

IDENTIFIER: ('a' ..'z' | 'A' ..'Z' | '_') (
		'a' ..'z'
		| 'A' ..'Z'
		| DIGIT
		| '_'
	)*;

WS: [ \t]+ -> channel(HIDDEN);
NL: [\r\n]+ -> channel(HIDDEN);