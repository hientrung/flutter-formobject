// Generated from F:\Trung\MyGit\formobject\lib\src\antlr4\Expression.g4 by ANTLR 4.10.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'ExpressionVisitor.dart';
import 'ExpressionBaseVisitor.dart';
const int RULE_program = 0, RULE_expression = 1, RULE_aggregate = 2, RULE_find = 3, 
          RULE_constant = 4;
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
                   TOKEN_DBQ = 23, TOKEN_SGQ = 24, TOKEN_QMARK = 25, TOKEN_COUNT = 26, 
                   TOKEN_SUM = 27, TOKEN_AVG = 28, TOKEN_EXIST = 29, TOKEN_FIRST = 30, 
                   TOKEN_STRING_LITERAL = 31, TOKEN_DATE_LITERAL = 32, TOKEN_NUM_DOUBLE = 33, 
                   TOKEN_NUM_INT = 34, TOKEN_TRUE = 35, TOKEN_FALSE = 36, 
                   TOKEN_NULL = 37, TOKEN_THIS = 38, TOKEN_IDENTIFIER = 39, 
                   TOKEN_WS = 40, TOKEN_NL = 41;

  @override
  final List<String> ruleNames = [
    'program', 'expression', 'aggregate', 'find', 'constant'
  ];

  static final List<String?> _LITERAL_NAMES = [
      null, "'['", "']'", "'('", "')'", "'+'", "'-'", "'*'", "'/'", "'%'", 
      "'^'", "'=='", "'!='", "'<'", "'<='", "'>'", "'>='", "'&&'", "'||'", 
      "'!'", "'.'", "'#'", "':'", "'\"'", "'''", "'?'", "'count'", "'sum'", 
      "'avg'", "'exist'", "'first'", null, null, null, null, "'true'", "'false'", 
      "'null'", "'this'"
  ];
  static final List<String?> _SYMBOLIC_NAMES = [
      null, "LBRACKET", "RBRACKET", "LPAREN", "RPAREN", "PLUS", "MINUS", 
      "STAR", "DIV", "MOD", "POW", "EQUALS", "NOT_EQUALS", "LTHAN", "LTEQ", 
      "GTHAN", "GTEQ", "AND", "OR", "NOT", "DOT", "SHARP", "COLON", "DBQ", 
      "SGQ", "QMARK", "COUNT", "SUM", "AVG", "EXIST", "FIRST", "STRING_LITERAL", 
      "DATE_LITERAL", "NUM_DOUBLE", "NUM_INT", "TRUE", "FALSE", "NULL", 
      "THIS", "IDENTIFIER", "WS", "NL"
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
      state = 10;
      expression(0);
      state = 11;
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
      state = 26;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
      case TOKEN_PLUS:
        _localctx = UnaryPlusExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;

        state = 14;
        match(TOKEN_PLUS);
        state = 15;
        expression(13);
        break;
      case TOKEN_MINUS:
        _localctx = UnaryMinusExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;
        state = 16;
        match(TOKEN_MINUS);
        state = 17;
        expression(12);
        break;
      case TOKEN_NOT:
        _localctx = NotExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;
        state = 18;
        match(TOKEN_NOT);
        state = 19;
        expression(11);
        break;
      case TOKEN_LPAREN:
        _localctx = ParenthesizedExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;
        state = 20;
        match(TOKEN_LPAREN);
        state = 21;
        expression(0);
        state = 22;
        match(TOKEN_RPAREN);
        break;
      case TOKEN_POW:
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
        state = 24;
        constant();
        break;
      case TOKEN_IDENTIFIER:
        _localctx = IdentifierExpressionContext(_localctx);
        context = _localctx;
        _prevctx = _localctx;
        state = 25;
        match(TOKEN_IDENTIFIER);
        break;
      default:
        throw NoViableAltException(this);
      }
      context!.stop = tokenStream.LT(-1);
      state = 68;
      errorHandler.sync(this);
      _alt = interpreter!.adaptivePredict(tokenStream, 4, context);
      while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
        if (_alt == 1) {
          if (parseListeners != null) triggerExitRuleEvent();
          _prevctx = _localctx;
          state = 66;
          errorHandler.sync(this);
          switch (interpreter!.adaptivePredict(tokenStream, 3, context)) {
          case 1:
            _localctx = MultiplicativeExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 28;
            if (!(precpred(context, 10))) {
              throw FailedPredicateException(this, "precpred(context, 10)");
            }
            state = 29;
            _la = tokenStream.LA(1)!;
            if (!((((_la) & ~0x3f) == 0 && ((BigInt.one << _la) & ((BigInt.one << TOKEN_STAR) | (BigInt.one << TOKEN_DIV) | (BigInt.one << TOKEN_MOD) | (BigInt.one << TOKEN_POW))) != BigInt.zero))) {
            errorHandler.recoverInline(this);
            } else {
              if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
              errorHandler.reportMatch(this);
              consume();
            }
            state = 30;
            expression(11);
            break;
          case 2:
            _localctx = AdditiveExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 31;
            if (!(precpred(context, 9))) {
              throw FailedPredicateException(this, "precpred(context, 9)");
            }
            state = 32;
            _la = tokenStream.LA(1)!;
            if (!(_la == TOKEN_PLUS || _la == TOKEN_MINUS)) {
            errorHandler.recoverInline(this);
            } else {
              if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
              errorHandler.reportMatch(this);
              consume();
            }
            state = 33;
            expression(10);
            break;
          case 3:
            _localctx = RelationalExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 34;
            if (!(precpred(context, 8))) {
              throw FailedPredicateException(this, "precpred(context, 8)");
            }
            state = 35;
            _la = tokenStream.LA(1)!;
            if (!((((_la) & ~0x3f) == 0 && ((BigInt.one << _la) & ((BigInt.one << TOKEN_LTHAN) | (BigInt.one << TOKEN_LTEQ) | (BigInt.one << TOKEN_GTHAN) | (BigInt.one << TOKEN_GTEQ))) != BigInt.zero))) {
            errorHandler.recoverInline(this);
            } else {
              if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
              errorHandler.reportMatch(this);
              consume();
            }
            state = 36;
            expression(9);
            break;
          case 4:
            _localctx = EqualityExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 37;
            if (!(precpred(context, 7))) {
              throw FailedPredicateException(this, "precpred(context, 7)");
            }
            state = 38;
            _la = tokenStream.LA(1)!;
            if (!(_la == TOKEN_EQUALS || _la == TOKEN_NOT_EQUALS)) {
            errorHandler.recoverInline(this);
            } else {
              if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
              errorHandler.reportMatch(this);
              consume();
            }
            state = 39;
            expression(8);
            break;
          case 5:
            _localctx = LogicalAndExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 40;
            if (!(precpred(context, 6))) {
              throw FailedPredicateException(this, "precpred(context, 6)");
            }
            state = 41;
            match(TOKEN_AND);
            state = 42;
            expression(7);
            break;
          case 6:
            _localctx = LogicalOrExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 43;
            if (!(precpred(context, 5))) {
              throw FailedPredicateException(this, "precpred(context, 5)");
            }
            state = 44;
            match(TOKEN_OR);
            state = 45;
            expression(6);
            break;
          case 7:
            _localctx = TernaryExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 46;
            if (!(precpred(context, 4))) {
              throw FailedPredicateException(this, "precpred(context, 4)");
            }
            state = 47;
            match(TOKEN_QMARK);
            state = 48;
            expression(0);
            state = 49;
            match(TOKEN_COLON);
            state = 50;
            expression(5);
            break;
          case 8:
            _localctx = AggregateExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 52;
            if (!(precpred(context, 15))) {
              throw FailedPredicateException(this, "precpred(context, 15)");
            }
            state = 53;
            match(TOKEN_LBRACKET);
            state = 55;
            errorHandler.sync(this);
            _la = tokenStream.LA(1)!;
            if ((((_la) & ~0x3f) == 0 && ((BigInt.one << _la) & ((BigInt.one << TOKEN_LPAREN) | (BigInt.one << TOKEN_PLUS) | (BigInt.one << TOKEN_MINUS) | (BigInt.one << TOKEN_POW) | (BigInt.one << TOKEN_NOT) | (BigInt.one << TOKEN_STRING_LITERAL) | (BigInt.one << TOKEN_DATE_LITERAL) | (BigInt.one << TOKEN_NUM_DOUBLE) | (BigInt.one << TOKEN_NUM_INT) | (BigInt.one << TOKEN_TRUE) | (BigInt.one << TOKEN_FALSE) | (BigInt.one << TOKEN_NULL) | (BigInt.one << TOKEN_THIS) | (BigInt.one << TOKEN_IDENTIFIER))) != BigInt.zero)) {
              state = 54;
              expression(0);
            }

            state = 57;
            match(TOKEN_RBRACKET);
            state = 58;
            match(TOKEN_DOT);
            state = 61;
            errorHandler.sync(this);
            switch (tokenStream.LA(1)!) {
            case TOKEN_COUNT:
            case TOKEN_SUM:
            case TOKEN_AVG:
              state = 59;
              aggregate();
              break;
            case TOKEN_EXIST:
            case TOKEN_FIRST:
              state = 60;
              find();
              break;
            default:
              throw NoViableAltException(this);
            }
            break;
          case 9:
            _localctx = PropertyExpressionContext(new ExpressionContext(_parentctx, _parentState));
            pushNewRecursionContext(_localctx, _startState, RULE_expression);
            state = 63;
            if (!(precpred(context, 14))) {
              throw FailedPredicateException(this, "precpred(context, 14)");
            }
            state = 64;
            match(TOKEN_DOT);
            state = 65;
            match(TOKEN_IDENTIFIER);
            break;
          } 
        }
        state = 70;
        errorHandler.sync(this);
        _alt = interpreter!.adaptivePredict(tokenStream, 4, context);
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

  AggregateContext aggregate() {
    dynamic _localctx = AggregateContext(context, state);
    enterRule(_localctx, 4, RULE_aggregate);
    try {
      state = 84;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
      case TOKEN_COUNT:
        _localctx = CountFunctionContext(_localctx);
        enterOuterAlt(_localctx, 1);
        state = 71;
        match(TOKEN_COUNT);
        state = 72;
        match(TOKEN_LPAREN);
        state = 73;
        match(TOKEN_RPAREN);
        break;
      case TOKEN_SUM:
        _localctx = SumFunctionContext(_localctx);
        enterOuterAlt(_localctx, 2);
        state = 74;
        match(TOKEN_SUM);
        state = 75;
        match(TOKEN_LPAREN);
        state = 76;
        expression(0);
        state = 77;
        match(TOKEN_RPAREN);
        break;
      case TOKEN_AVG:
        _localctx = AvgFunctionContext(_localctx);
        enterOuterAlt(_localctx, 3);
        state = 79;
        match(TOKEN_AVG);
        state = 80;
        match(TOKEN_LPAREN);
        state = 81;
        expression(0);
        state = 82;
        match(TOKEN_RPAREN);
        break;
      default:
        throw NoViableAltException(this);
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

  FindContext find() {
    dynamic _localctx = FindContext(context, state);
    enterRule(_localctx, 6, RULE_find);
    try {
      state = 92;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
      case TOKEN_EXIST:
        _localctx = ExistFunctionContext(_localctx);
        enterOuterAlt(_localctx, 1);
        state = 86;
        match(TOKEN_EXIST);
        state = 87;
        match(TOKEN_LPAREN);
        state = 88;
        match(TOKEN_RPAREN);
        break;
      case TOKEN_FIRST:
        _localctx = FirstFunctionContext(_localctx);
        enterOuterAlt(_localctx, 2);
        state = 89;
        match(TOKEN_FIRST);
        state = 90;
        match(TOKEN_LPAREN);
        state = 91;
        match(TOKEN_RPAREN);
        break;
      default:
        throw NoViableAltException(this);
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

  ConstantContext constant() {
    dynamic _localctx = ConstantContext(context, state);
    enterRule(_localctx, 8, RULE_constant);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 94;
      _la = tokenStream.LA(1)!;
      if (!((((_la) & ~0x3f) == 0 && ((BigInt.one << _la) & ((BigInt.one << TOKEN_POW) | (BigInt.one << TOKEN_STRING_LITERAL) | (BigInt.one << TOKEN_DATE_LITERAL) | (BigInt.one << TOKEN_NUM_DOUBLE) | (BigInt.one << TOKEN_NUM_INT) | (BigInt.one << TOKEN_TRUE) | (BigInt.one << TOKEN_FALSE) | (BigInt.one << TOKEN_NULL) | (BigInt.one << TOKEN_THIS))) != BigInt.zero))) {
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
      case 7: return precpred(context, 15);
      case 8: return precpred(context, 14);
    }
    return true;
  }

  static const List<int> _serializedATN = [
      4,1,41,97,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,1,0,1,0,1,0,1,1,
      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,27,8,1,1,1,1,1,
      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,56,8,1,1,1,1,1,1,1,1,1,3,1,62,
      8,1,1,1,1,1,1,1,5,1,67,8,1,10,1,12,1,70,9,1,1,2,1,2,1,2,1,2,1,2,1,
      2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,2,85,8,2,1,3,1,3,1,3,1,3,1,3,1,3,3,
      3,93,8,3,1,4,1,4,1,4,0,1,2,5,0,2,4,6,8,0,5,1,0,7,10,1,0,5,6,1,0,13,
      16,1,0,11,12,2,0,10,10,31,38,110,0,10,1,0,0,0,2,26,1,0,0,0,4,84,1,
      0,0,0,6,92,1,0,0,0,8,94,1,0,0,0,10,11,3,2,1,0,11,12,5,0,0,1,12,1,1,
      0,0,0,13,14,6,1,-1,0,14,15,5,5,0,0,15,27,3,2,1,13,16,17,5,6,0,0,17,
      27,3,2,1,12,18,19,5,19,0,0,19,27,3,2,1,11,20,21,5,3,0,0,21,22,3,2,
      1,0,22,23,5,4,0,0,23,27,1,0,0,0,24,27,3,8,4,0,25,27,5,39,0,0,26,13,
      1,0,0,0,26,16,1,0,0,0,26,18,1,0,0,0,26,20,1,0,0,0,26,24,1,0,0,0,26,
      25,1,0,0,0,27,68,1,0,0,0,28,29,10,10,0,0,29,30,7,0,0,0,30,67,3,2,1,
      11,31,32,10,9,0,0,32,33,7,1,0,0,33,67,3,2,1,10,34,35,10,8,0,0,35,36,
      7,2,0,0,36,67,3,2,1,9,37,38,10,7,0,0,38,39,7,3,0,0,39,67,3,2,1,8,40,
      41,10,6,0,0,41,42,5,17,0,0,42,67,3,2,1,7,43,44,10,5,0,0,44,45,5,18,
      0,0,45,67,3,2,1,6,46,47,10,4,0,0,47,48,5,25,0,0,48,49,3,2,1,0,49,50,
      5,22,0,0,50,51,3,2,1,5,51,67,1,0,0,0,52,53,10,15,0,0,53,55,5,1,0,0,
      54,56,3,2,1,0,55,54,1,0,0,0,55,56,1,0,0,0,56,57,1,0,0,0,57,58,5,2,
      0,0,58,61,5,20,0,0,59,62,3,4,2,0,60,62,3,6,3,0,61,59,1,0,0,0,61,60,
      1,0,0,0,62,67,1,0,0,0,63,64,10,14,0,0,64,65,5,20,0,0,65,67,5,39,0,
      0,66,28,1,0,0,0,66,31,1,0,0,0,66,34,1,0,0,0,66,37,1,0,0,0,66,40,1,
      0,0,0,66,43,1,0,0,0,66,46,1,0,0,0,66,52,1,0,0,0,66,63,1,0,0,0,67,70,
      1,0,0,0,68,66,1,0,0,0,68,69,1,0,0,0,69,3,1,0,0,0,70,68,1,0,0,0,71,
      72,5,26,0,0,72,73,5,3,0,0,73,85,5,4,0,0,74,75,5,27,0,0,75,76,5,3,0,
      0,76,77,3,2,1,0,77,78,5,4,0,0,78,85,1,0,0,0,79,80,5,28,0,0,80,81,5,
      3,0,0,81,82,3,2,1,0,82,83,5,4,0,0,83,85,1,0,0,0,84,71,1,0,0,0,84,74,
      1,0,0,0,84,79,1,0,0,0,85,5,1,0,0,0,86,87,5,29,0,0,87,88,5,3,0,0,88,
      93,5,4,0,0,89,90,5,30,0,0,90,91,5,3,0,0,91,93,5,4,0,0,92,86,1,0,0,
      0,92,89,1,0,0,0,93,7,1,0,0,0,94,95,7,4,0,0,95,9,1,0,0,0,7,26,55,61,
      66,68,84,92
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

class AggregateContext extends ParserRuleContext {
  AggregateContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_aggregate;
 
  @override
  void copyFrom(ParserRuleContext ctx) {
    super.copyFrom(ctx);
  }
}

class FindContext extends ParserRuleContext {
  FindContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_find;
 
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
  TerminalNode? POW() => getToken(ExpressionParser.TOKEN_POW, 0);
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

class AggregateExpressionContext extends ExpressionContext {
  List<ExpressionContext> expressions() => getRuleContexts<ExpressionContext>();
  ExpressionContext? expression(int i) => getRuleContext<ExpressionContext>(i);
  TerminalNode? LBRACKET() => getToken(ExpressionParser.TOKEN_LBRACKET, 0);
  TerminalNode? RBRACKET() => getToken(ExpressionParser.TOKEN_RBRACKET, 0);
  TerminalNode? DOT() => getToken(ExpressionParser.TOKEN_DOT, 0);
  AggregateContext? aggregate() => getRuleContext<AggregateContext>(0);
  FindContext? find() => getRuleContext<FindContext>(0);
  AggregateExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitAggregateExpression(this);
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
}class SumFunctionContext extends AggregateContext {
  TerminalNode? SUM() => getToken(ExpressionParser.TOKEN_SUM, 0);
  TerminalNode? LPAREN() => getToken(ExpressionParser.TOKEN_LPAREN, 0);
  ExpressionContext? expression() => getRuleContext<ExpressionContext>(0);
  TerminalNode? RPAREN() => getToken(ExpressionParser.TOKEN_RPAREN, 0);
  SumFunctionContext(AggregateContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitSumFunction(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class AvgFunctionContext extends AggregateContext {
  TerminalNode? AVG() => getToken(ExpressionParser.TOKEN_AVG, 0);
  TerminalNode? LPAREN() => getToken(ExpressionParser.TOKEN_LPAREN, 0);
  ExpressionContext? expression() => getRuleContext<ExpressionContext>(0);
  TerminalNode? RPAREN() => getToken(ExpressionParser.TOKEN_RPAREN, 0);
  AvgFunctionContext(AggregateContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitAvgFunction(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class CountFunctionContext extends AggregateContext {
  TerminalNode? COUNT() => getToken(ExpressionParser.TOKEN_COUNT, 0);
  TerminalNode? LPAREN() => getToken(ExpressionParser.TOKEN_LPAREN, 0);
  TerminalNode? RPAREN() => getToken(ExpressionParser.TOKEN_RPAREN, 0);
  CountFunctionContext(AggregateContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitCountFunction(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}class ExistFunctionContext extends FindContext {
  TerminalNode? EXIST() => getToken(ExpressionParser.TOKEN_EXIST, 0);
  TerminalNode? LPAREN() => getToken(ExpressionParser.TOKEN_LPAREN, 0);
  TerminalNode? RPAREN() => getToken(ExpressionParser.TOKEN_RPAREN, 0);
  ExistFunctionContext(FindContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitExistFunction(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class FirstFunctionContext extends FindContext {
  TerminalNode? FIRST() => getToken(ExpressionParser.TOKEN_FIRST, 0);
  TerminalNode? LPAREN() => getToken(ExpressionParser.TOKEN_LPAREN, 0);
  TerminalNode? RPAREN() => getToken(ExpressionParser.TOKEN_RPAREN, 0);
  FirstFunctionContext(FindContext ctx) { copyFrom(ctx); }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionVisitor<T>) {
     return visitor.visitFirstFunction(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}