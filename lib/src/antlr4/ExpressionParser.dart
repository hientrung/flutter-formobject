// Generated from D:\GitHub\flutter-formobject\lib\src\antlr4\Expression.g4 by ANTLR 4.10.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'ExpressionVisitor.dart';
import 'ExpressionBaseVisitor.dart';
const int RULE_program = 0, RULE_expression = 1, RULE_constant = 2;
class ExpressionParser extends Parser {
  static final checkVersion = () => RuntimeMetaData.checkVersion('4.10.1', RuntimeMetaData.VERSION);
  static const int TOKEN_EOF = IntStream.EOF;

  static final List<DFA> _decisionToDFA = List.generate(
      _ATN.numberOfDecisions, (i) => DFA(_ATN.getDecisionState(i), i));
  static final PredictionContextCache _sharedContextCache = PredictionContextCache();
  static const int TOKEN_LBRACKET = 1, TOKEN_RBRACKET = 2, TOKEN_LPAREN = 3, 
                   TOKEN_RPAREN = 4, TOKEN_PLUS = 5, TOKEN_MINUS = 6, TOKEN_STAR = 7, 
                   TOKEN_DIV = 8, TOKEN_MOD = 9, TOKEN_POW = 10, TOKEN_EQUALS = 11, 
                   TOKEN_NOT_EQUALS = 12, TOKEN_LTHAN = 13, TOKEN_LTEQ = 14, 
                   TOKEN_GTHAN = 15, TOKEN_GTEQ = 16, TOKEN_AND = 17, TOKEN_OR = 18, 
                   TOKEN_NOT = 19, TOKEN_DOT = 20, TOKEN_SHARP = 21, TOKEN_COLON = 22, 
                   TOKEN_DBQ = 23, TOKEN_QMARK = 24, TOKEN_STRING_LITERAL = 25, 
                   TOKEN_DATE_LITERAL = 26, TOKEN_NUM_DOUBLE = 27, TOKEN_NUM_INT = 28, 
                   TOKEN_TRUE = 29, TOKEN_FALSE = 30, TOKEN_NULL = 31, TOKEN_THIS = 32, 
                   TOKEN_IDENTIFIER = 33, TOKEN_WS = 34, TOKEN_NL = 35;

  @override
  final List<String> ruleNames = [
    'program', 'expression', 'constant'
  ];

  static final List<String?> _LITERAL_NAMES = [
      null, "'['", "']'", "'('", "')'", "'+'", "'-'", "'*'", "'/'", "'%'", 
      "'^'", "'=='", "'!='", "'<'", "'<='", "'>'", "'>='", "'&&'", "'||'", 
      "'!'", "'.'", "'#'", "':'", "'\"'", "'?'", null, null, null, null, 
      "'true'", "'false'", "'null'", "'this'"
  ];
  static final List<String?> _SYMBOLIC_NAMES = [
      null, "LBRACKET", "RBRACKET", "LPAREN", "RPAREN", "PLUS", "MINUS", 
      "STAR", "DIV", "MOD", "POW", "EQUALS", "NOT_EQUALS", "LTHAN", "LTEQ", 
      "GTHAN", "GTEQ", "AND", "OR", "NOT", "DOT", "SHARP", "COLON", "DBQ", 
      "QMARK", "STRING_LITERAL", "DATE_LITERAL", "NUM_DOUBLE", "NUM_INT", 
      "TRUE", "FALSE", "NULL", "THIS", "IDENTIFIER", "WS", "NL"
  ];
  static final Vocabulary VOCABULARY = VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

  @override
  Vocabulary get vocabulary {
    return VOCABULARY;
  }

  @override
  String get grammarFileName => 'Expression.g4';

  @override
  List<int> get serializedATN => _serializedATN;

  @override
  ATN getATN() {
   return _ATN;
  }

  ExpressionParser(TokenStream input) : super(input) {
    interpreter = ParserATNSimulator(this, _ATN, _decisionToDFA, _sharedContextCache);
  }

  ProgramContext program() {
    dynamic _localctx = ProgramContext(context, state);
    enterRule(_localctx, 0, RULE_program);
    try {
      enterOuterAlt(_localctx, 1);
      state = 6;
      expression(0);
      state = 7;
      match(TOKEN_EOF);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ExpressionContext expression([int _p = 0]) {
    final _parentctx = context;
    final _parentState = state;
    dynamic _localctx = ExpressionContext(context, _parentState);
    var _prevctx = _localctx;
    var _startState = 2;
    enterRecursionRule(_localctx, 2, RULE_expression, _p);
    int _la;
    try {
      int _alt;
      enterOuterAlt(_localctx, 1);
      state = 25;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
      case TOKEN_POW:
        _localctx = ParentPropertyExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;

        state = 10;
        match(TOKEN_POW);
        state = 11;
        match(TOKEN_DOT);
        state = 12;
        match(TOKEN_IDENTIFIER);
        break;
      case TOKEN_PLUS:
        _localctx = UnaryPlusExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;
        state = 13;
        match(TOKEN_PLUS);
        state = 14;
        expression(13);
        break;
      case TOKEN_MINUS:
        _localctx = UnaryMinusExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;
        state = 15;
        match(TOKEN_MINUS);
        state = 16;
        expression(12);
        break;
      case TOKEN_NOT:
        _localctx = NotExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;
        state = 17;
        match(TOKEN_NOT);
        state = 18;
        expression(11);
        break;
      case TOKEN_LPAREN:
        _localctx = ParenthesizedExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;
        state = 19;
        match(TOKEN_LPAREN);
        state = 20;
        expression(0);
        state = 21;
        match(TOKEN_RPAREN);
        break;
      case TOKEN_STRING_LITERAL:
      case TOKEN_DATE_LITERAL:
      case TOKEN_NUM_DOUBLE:
      case TOKEN_NUM_INT:
      case TOKEN_TRUE:
      case TOKEN_FALSE:
      case TOKEN_NULL:
      case TOKEN_THIS:
        _localctx = ConstantExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;
        state = 23;
        constant();
        break;
      case TOKEN_IDENTIFIER:
        _localctx = IdentifierExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;
        state = 24;
        match(TOKEN_IDENTIFIER);
        break;
      default:
        throw NoViableAltException(this);
      }
      context!.stop = tokenStream.LT(-1);
      state = 61;
      errorHandler.sync(this);
      _alt = interpreter!.adaptivePredict(tokenStream, 2, context);
      while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
        if (_alt == 1) {
          if (parseListeners != null) triggerExitRuleEvent();
          _prevctx = _localctx;
          state = 59;
          errorHandler.sync(this);
          switch (interpreter!.adaptivePredict(tokenStream, 1, context)) {
          case 1:
            _localctx = MultiplicativeExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 27;
            if (!(precpred(context, 10))) {
              throw FailedPredicateException(this, "precpred(context, 10)");
            }
            state = 28;
            _la = tokenStream.LA(1)!;
            if (!((((_la) & ~0x3f) == 0 && ((BigInt.one << _la) & ((BigInt.one << TOKEN_STAR) | (BigInt.one << TOKEN_DIV) | (BigInt.one << TOKEN_MOD) | (BigInt.one << TOKEN_POW))) != BigInt.zero))) {
            errorHandler.recoverInline(this);
            } else {
              if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
              errorHandler.reportMatch(this);
              consume();
            }
            state = 29;
            expression(11);
            break;
          case 2:
            _localctx = AdditiveExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 30;
            if (!(precpred(context, 9))) {
              throw FailedPredicateException(this, "precpred(context, 9)");
            }
            state = 31;
            _la = tokenStream.LA(1)!;
            if (!(_la == TOKEN_PLUS || _la == TOKEN_MINUS)) {
            errorHandler.recoverInline(this);
            } else {
              if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
              errorHandler.reportMatch(this);
              consume();
            }
            state = 32;
            expression(10);
            break;
          case 3:
            _localctx = RelationalExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 33;
            if (!(precpred(context, 8))) {
              throw FailedPredicateException(this, "precpred(context, 8)");
            }
            state = 34;
            _la = tokenStream.LA(1)!;
            if (!((((_la) & ~0x3f) == 0 && ((BigInt.one << _la) & ((BigInt.one << TOKEN_LTHAN) | (BigInt.one << TOKEN_LTEQ) | (BigInt.one << TOKEN_GTHAN) | (BigInt.one << TOKEN_GTEQ))) != BigInt.zero))) {
            errorHandler.recoverInline(this);
            } else {
              if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
              errorHandler.reportMatch(this);
              consume();
            }
            state = 35;
            expression(9);
            break;
          case 4:
            _localctx = EqualityExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 36;
            if (!(precpred(context, 7))) {
              throw FailedPredicateException(this, "precpred(context, 7)");
            }
            state = 37;
            _la = tokenStream.LA(1)!;
            if (!(_la == TOKEN_EQUALS || _la == TOKEN_NOT_EQUALS)) {
            errorHandler.recoverInline(this);
            } else {
              if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
              errorHandler.reportMatch(this);
              consume();
            }
            state = 38;
            expression(8);
            break;
          case 5:
            _localctx = LogicalAndExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 39;
            if (!(precpred(context, 6))) {
              throw FailedPredicateException(this, "precpred(context, 6)");
            }
            state = 40;
            match(TOKEN_AND);
            state = 41;
            expression(7);
            break;
          case 6:
            _localctx = LogicalOrExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 42;
            if (!(precpred(context, 5))) {
              throw FailedPredicateException(this, "precpred(context, 5)");
            }
            state = 43;
            match(TOKEN_OR);
            state = 44;
            expression(6);
            break;
          case 7:
            _localctx = TernaryExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 45;
            if (!(precpred(context, 4))) {
              throw FailedPredicateException(this, "precpred(context, 4)");
            }
            state = 46;
            match(TOKEN_QMARK);
            state = 47;
            expression(0);
            state = 48;
            match(TOKEN_COLON);
            state = 49;
            expression(5);
            break;
          case 8:
            _localctx = ExistExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 51;
            if (!(precpred(context, 16))) {
              throw FailedPredicateException(this, "precpred(context, 16)");
            }
            state = 52;
            match(TOKEN_LBRACKET);
            state = 53;
            expression(0);
            state = 54;
            match(TOKEN_RBRACKET);
            break;
          case 9:
            _localctx = PropertyExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 56;
            if (!(precpred(context, 15))) {
              throw FailedPredicateException(this, "precpred(context, 15)");
            }
            state = 57;
            match(TOKEN_DOT);
            state = 58;
            match(TOKEN_IDENTIFIER);
            break;
          } 
        }
        state = 63;
        errorHandler.sync(this);
        _alt = interpreter!.adaptivePredict(tokenStream, 2, context);
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      unrollRecursionContexts(_parentctx);
    }
    return _localctx;
  }

  ConstantContext constant() {
    dynamic _localctx = ConstantContext(context, state);
    enterRule(_localctx, 4, RULE_constant);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 64;
      _la = tokenStream.LA(1)!;
      if (!((((_la) & ~0x3f) == 0 && ((BigInt.one << _la) & ((BigInt.one << TOKEN_STRING_LITERAL) | (BigInt.one << TOKEN_DATE_LITERAL) | (BigInt.one << TOKEN_NUM_DOUBLE) | (BigInt.one << TOKEN_NUM_INT) | (BigInt.one << TOKEN_TRUE) | (BigInt.one << TOKEN_FALSE) | (BigInt.one << TOKEN_NULL) | (BigInt.one << TOKEN_THIS))) != BigInt.zero))) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  @override
  bool sempred(RuleContext? _localctx, int ruleIndex, int predIndex) {
    switch (ruleIndex) {
    case 1:
      return _expression_sempred(_localctx as ExpressionContext?, predIndex);
    }
    return true;
  }
  bool _expression_sempred(dynamic _localctx, int predIndex) {
    switch (predIndex) {
      case 0: return precpred(context, 10);
      case 1: return precpred(context, 9);
      case 2: return precpred(context, 8);
      case 3: return precpred(context, 7);
      case 4: return precpred(context, 6);
      case 5: return precpred(context, 5);
      case 6: return precpred(context, 4);
      case 7: return precpred(context, 16);
      case 8: return precpred(context, 15);
    }
    return true;
  }

  static const List<int> _serializedATN = [
      4,1,35,67,2,0,7,0,2,1,7,1,2,2,7,2,1,0,1,0,1,0,1,1,1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,26,8,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,1,60,8,1,10,1,
      12,1,63,9,1,1,2,1,2,1,2,0,1,2,3,0,2,4,0,5,1,0,7,10,1,0,5,6,1,0,13,
      16,1,0,11,12,1,0,25,32,78,0,6,1,0,0,0,2,25,1,0,0,0,4,64,1,0,0,0,6,
      7,3,2,1,0,7,8,5,0,0,1,8,1,1,0,0,0,9,10,6,1,-1,0,10,11,5,10,0,0,11,
      12,5,20,0,0,12,26,5,33,0,0,13,14,5,5,0,0,14,26,3,2,1,13,15,16,5,6,
      0,0,16,26,3,2,1,12,17,18,5,19,0,0,18,26,3,2,1,11,19,20,5,3,0,0,20,
      21,3,2,1,0,21,22,5,4,0,0,22,26,1,0,0,0,23,26,3,4,2,0,24,26,5,33,0,
      0,25,9,1,0,0,0,25,13,1,0,0,0,25,15,1,0,0,0,25,17,1,0,0,0,25,19,1,0,
      0,0,25,23,1,0,0,0,25,24,1,0,0,0,26,61,1,0,0,0,27,28,10,10,0,0,28,29,
      7,0,0,0,29,60,3,2,1,11,30,31,10,9,0,0,31,32,7,1,0,0,32,60,3,2,1,10,
      33,34,10,8,0,0,34,35,7,2,0,0,35,60,3,2,1,9,36,37,10,7,0,0,37,38,7,
      3,0,0,38,60,3,2,1,8,39,40,10,6,0,0,40,41,5,17,0,0,41,60,3,2,1,7,42,
      43,10,5,0,0,43,44,5,18,0,0,44,60,3,2,1,6,45,46,10,4,0,0,46,47,5,24,
      0,0,47,48,3,2,1,0,48,49,5,22,0,0,49,50,3,2,1,5,50,60,1,0,0,0,51,52,
      10,16,0,0,52,53,5,1,0,0,53,54,3,2,1,0,54,55,5,2,0,0,55,60,1,0,0,0,
      56,57,10,15,0,0,57,58,5,20,0,0,58,60,5,33,0,0,59,27,1,0,0,0,59,30,
      1,0,0,0,59,33,1,0,0,0,59,36,1,0,0,0,59,39,1,0,0,0,59,42,1,0,0,0,59,
      45,1,0,0,0,59,51,1,0,0,0,59,56,1,0,0,0,60,63,1,0,0,0,61,59,1,0,0,0,
      61,62,1,0,0,0,62,3,1,0,0,0,63,61,1,0,0,0,64,65,7,4,0,0,65,5,1,0,0,
      0,3,25,59,61
  ];

  static final ATN _ATN =
      ATNDeserializer().deserialize(_serializedATN);
}
class ProgramContext extends ParserRuleContext {
  ExpressionContext? expression() => getRuleContext<ExpressionContext>(0);
  TerminalNode? EOF() => getToken(ExpressionParser.TOKEN_EOF, 0);
  ProgramContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_program;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitProgram(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ExpressionContext extends ParserRuleContext {
  ExpressionContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_expression;
 
  @override
  void copyFrom(ParserRuleContext ctx) {
    super.copyFrom(ctx);
  }
}

class ConstantContext extends ParserRuleContext {
  TerminalNode? TRUE() => getToken(ExpressionParser.TOKEN_TRUE, 0);
  TerminalNode? FALSE() => getToken(ExpressionParser.TOKEN_FALSE, 0);
  TerminalNode? NULL() => getToken(ExpressionParser.TOKEN_NULL, 0);
  TerminalNode? STRING_LITERAL() => getToken(ExpressionParser.TOKEN_STRING_LITERAL, 0);
  TerminalNode? DATE_LITERAL() => getToken(ExpressionParser.TOKEN_DATE_LITERAL, 0);
  TerminalNode? NUM_DOUBLE() => getToken(ExpressionParser.TOKEN_NUM_DOUBLE, 0);
  TerminalNode? NUM_INT() => getToken(ExpressionParser.TOKEN_NUM_INT, 0);
  TerminalNode? THIS() => getToken(ExpressionParser.TOKEN_THIS, 0);
  ConstantContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_constant;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitConstant(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ParenthesizedExpressionContext extends ExpressionContext {
  TerminalNode? LPAREN() => getToken(ExpressionParser.TOKEN_LPAREN, 0);
  ExpressionContext? expression() => getRuleContext<ExpressionContext>(0);
  TerminalNode? RPAREN() => getToken(ExpressionParser.TOKEN_RPAREN, 0);
  ParenthesizedExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitParenthesizedExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class AdditiveExpressionContext extends ExpressionContext {
  List<ExpressionContext> expressions() => getRuleContexts<ExpressionContext>();
  ExpressionContext? expression(int i) => getRuleContext<ExpressionContext>(i);
  TerminalNode? MINUS() => getToken(ExpressionParser.TOKEN_MINUS, 0);
  TerminalNode? PLUS() => getToken(ExpressionParser.TOKEN_PLUS, 0);
  AdditiveExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitAdditiveExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class RelationalExpressionContext extends ExpressionContext {
  List<ExpressionContext> expressions() => getRuleContexts<ExpressionContext>();
  ExpressionContext? expression(int i) => getRuleContext<ExpressionContext>(i);
  TerminalNode? GTHAN() => getToken(ExpressionParser.TOKEN_GTHAN, 0);
  TerminalNode? GTEQ() => getToken(ExpressionParser.TOKEN_GTEQ, 0);
  TerminalNode? LTHAN() => getToken(ExpressionParser.TOKEN_LTHAN, 0);
  TerminalNode? LTEQ() => getToken(ExpressionParser.TOKEN_LTEQ, 0);
  RelationalExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitRelationalExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class TernaryExpressionContext extends ExpressionContext {
  List<ExpressionContext> expressions() => getRuleContexts<ExpressionContext>();
  ExpressionContext? expression(int i) => getRuleContext<ExpressionContext>(i);
  TerminalNode? QMARK() => getToken(ExpressionParser.TOKEN_QMARK, 0);
  TerminalNode? COLON() => getToken(ExpressionParser.TOKEN_COLON, 0);
  TernaryExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitTernaryExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class LogicalAndExpressionContext extends ExpressionContext {
  List<ExpressionContext> expressions() => getRuleContexts<ExpressionContext>();
  ExpressionContext? expression(int i) => getRuleContext<ExpressionContext>(i);
  TerminalNode? AND() => getToken(ExpressionParser.TOKEN_AND, 0);
  LogicalAndExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitLogicalAndExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ConstantExpressionContext extends ExpressionContext {
  ConstantContext? constant() => getRuleContext<ConstantContext>(0);
  ConstantExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitConstantExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class LogicalOrExpressionContext extends ExpressionContext {
  List<ExpressionContext> expressions() => getRuleContexts<ExpressionContext>();
  ExpressionContext? expression(int i) => getRuleContext<ExpressionContext>(i);
  TerminalNode? OR() => getToken(ExpressionParser.TOKEN_OR, 0);
  LogicalOrExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitLogicalOrExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class NotExpressionContext extends ExpressionContext {
  TerminalNode? NOT() => getToken(ExpressionParser.TOKEN_NOT, 0);
  ExpressionContext? expression() => getRuleContext<ExpressionContext>(0);
  NotExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitNotExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class IdentifierExpressionContext extends ExpressionContext {
  TerminalNode? IDENTIFIER() => getToken(ExpressionParser.TOKEN_IDENTIFIER, 0);
  IdentifierExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitIdentifierExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ParentPropertyExpressionContext extends ExpressionContext {
  TerminalNode? POW() => getToken(ExpressionParser.TOKEN_POW, 0);
  TerminalNode? DOT() => getToken(ExpressionParser.TOKEN_DOT, 0);
  TerminalNode? IDENTIFIER() => getToken(ExpressionParser.TOKEN_IDENTIFIER, 0);
  ParentPropertyExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitParentPropertyExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class UnaryMinusExpressionContext extends ExpressionContext {
  TerminalNode? MINUS() => getToken(ExpressionParser.TOKEN_MINUS, 0);
  ExpressionContext? expression() => getRuleContext<ExpressionContext>(0);
  UnaryMinusExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitUnaryMinusExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class UnaryPlusExpressionContext extends ExpressionContext {
  TerminalNode? PLUS() => getToken(ExpressionParser.TOKEN_PLUS, 0);
  ExpressionContext? expression() => getRuleContext<ExpressionContext>(0);
  UnaryPlusExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitUnaryPlusExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class PropertyExpressionContext extends ExpressionContext {
  ExpressionContext? expression() => getRuleContext<ExpressionContext>(0);
  TerminalNode? DOT() => getToken(ExpressionParser.TOKEN_DOT, 0);
  TerminalNode? IDENTIFIER() => getToken(ExpressionParser.TOKEN_IDENTIFIER, 0);
  PropertyExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitPropertyExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class EqualityExpressionContext extends ExpressionContext {
  List<ExpressionContext> expressions() => getRuleContexts<ExpressionContext>();
  ExpressionContext? expression(int i) => getRuleContext<ExpressionContext>(i);
  TerminalNode? EQUALS() => getToken(ExpressionParser.TOKEN_EQUALS, 0);
  TerminalNode? NOT_EQUALS() => getToken(ExpressionParser.TOKEN_NOT_EQUALS, 0);
  EqualityExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitEqualityExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ExistExpressionContext extends ExpressionContext {
  List<ExpressionContext> expressions() => getRuleContexts<ExpressionContext>();
  ExpressionContext? expression(int i) => getRuleContext<ExpressionContext>(i);
  TerminalNode? LBRACKET() => getToken(ExpressionParser.TOKEN_LBRACKET, 0);
  TerminalNode? RBRACKET() => getToken(ExpressionParser.TOKEN_RBRACKET, 0);
  ExistExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitExistExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class MultiplicativeExpressionContext extends ExpressionContext {
  List<ExpressionContext> expressions() => getRuleContexts<ExpressionContext>();
  ExpressionContext? expression(int i) => getRuleContext<ExpressionContext>(i);
  TerminalNode? MOD() => getToken(ExpressionParser.TOKEN_MOD, 0);
  TerminalNode? STAR() => getToken(ExpressionParser.TOKEN_STAR, 0);
  TerminalNode? DIV() => getToken(ExpressionParser.TOKEN_DIV, 0);
  TerminalNode? POW() => getToken(ExpressionParser.TOKEN_POW, 0);
  MultiplicativeExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitMultiplicativeExpression(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}