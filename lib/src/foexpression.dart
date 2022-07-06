import 'package:antlr4/antlr4.dart';
import './fofield.dart';
import './antlr4/ExpressionLexer.dart';
import './antlr4/ExpressionParser.dart';
import './antlr4/ExpressionBaseVisitor.dart';

class FOExpression {
  final FOField field;
  FOExpression(this.field);

  dynamic eval(String expr) {
    if (expr.isEmpty) return null;
    ExpressionLexer.checkVersion();
    ExpressionParser.checkVersion();
    final lexer = ExpressionLexer(InputStream.fromString(expr));
    final tokens = CommonTokenStream(lexer);
    final parser = ExpressionParser(tokens);
    final err = _FOExpressionError();
    parser.addErrorListener(err);
    final tree = parser.program();
    if (err.hasError) {
      throw 'Invalid expression: $expr';
    }
    final eval = _FOExpressionVisitor(field);
    return eval.visit(tree);
  }
}

class _FOExpressionError extends BaseErrorListener {
  bool _hasError = false;
  @override
  void syntaxError(
      Recognizer<ATNSimulator> recognizer,
      Object? offendingSymbol,
      int? line,
      int charPositionInLine,
      String msg,
      RecognitionException<IntStream>? e) {
    _hasError = true;
    super.syntaxError(
        recognizer, offendingSymbol, line, charPositionInLine, msg, e);
  }

  bool get hasError => _hasError;
}

class _FOExpressionVisitor extends ExpressionBaseVisitor<dynamic> {
  final FOField field;
  _FOExpressionVisitor(this.field);

  @override
  visitProgram(ProgramContext ctx) {
    return visit(ctx.expression()!);
  }

  @override
  visitUnaryPlusExpression(UnaryPlusExpressionContext ctx) {
    return visit(ctx.expression()!);
  }

  @override
  visitUnaryMinusExpression(UnaryMinusExpressionContext ctx) {
    return -visit(ctx.expression()!);
  }

  @override
  visitNotExpression(NotExpressionContext ctx) {
    return !visit(ctx.expression()!);
  }

  @override
  visitMultiplicativeExpression(MultiplicativeExpressionContext ctx) {
    final left = visit(ctx.expression(0)!);
    final right = visit(ctx.expression(1)!);
    if (ctx.MOD() != null) return left % right;
    if (ctx.STAR() != null) return left * right;
    if (ctx.DIV() != null) return left / right;
    if (ctx.POW() != null) return left ^ right;
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitAdditiveExpression(AdditiveExpressionContext ctx) {
    final left = visit(ctx.expression(0)!);
    final right = visit(ctx.expression(1)!);
    if (ctx.PLUS() != null) return left + right;
    if (ctx.MINUS() != null) return left - right;
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitRelationalExpression(RelationalExpressionContext ctx) {
    final left = visit(ctx.expression(0)!);
    final right = visit(ctx.expression(1)!);
    if (ctx.GTEQ() != null) return left >= right;
    if (ctx.GTHAN() != null) return left > right;
    if (ctx.LTEQ() != null) return left <= right;
    if (ctx.LTHAN() != null) return left < right;
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitEqualityExpression(EqualityExpressionContext ctx) {
    final left = visit(ctx.expression(0)!);
    final right = visit(ctx.expression(1)!);
    if (ctx.EQUALS() != null) return left == right;
    if (ctx.NOT_EQUALS() != null) return left != right;
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitLogicalAndExpression(LogicalAndExpressionContext ctx) {
    return visit(ctx.expression(0)!) && visit(ctx.expression(1)!);
  }

  @override
  visitLogicalOrExpression(LogicalOrExpressionContext ctx) {
    return visit(ctx.expression(0)!) || visit(ctx.expression(1)!);
  }

  @override
  visitTernaryExpression(TernaryExpressionContext ctx) {
    var c = visit(ctx.expression(0)!);
    if (c) return visit(ctx.expression(1)!);
    return visit(ctx.expression(2)!);
  }

  @override
  visitParenthesizedExpression(ParenthesizedExpressionContext ctx) {
    return visit(ctx.expression()!);
  }

  @override
  visitConstantExpression(ConstantExpressionContext ctx) {
    return visit(ctx.constant()!);
  }

  @override
  visitConstant(ConstantContext ctx) {
    TerminalNode? c;
    if (ctx.TRUE() != null) return true;
    if (ctx.FALSE() != null) return false;
    if (ctx.NULL() != null) return null;
    c = ctx.STRING_LITERAL();
    if (c != null) return c.text;
    c = ctx.DATE_LITERAL();
    if (c != null) {
      return DateTime.parse(c.text!.substring(1, c.text!.length - 1));
    }
    c = ctx.NUM_DOUBLE();
    if (c != null) double.parse(c.text!);
    c = ctx.NUM_INT();
    if (c != null) return int.parse(c.text!);
    if (ctx.THIS() != null) {
      throw 'not implement THIS';
    }
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitIdentifierExpression(IdentifierExpressionContext ctx) {
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitExistExpression(ExistExpressionContext ctx) {
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitPropertyExpression(PropertyExpressionContext ctx) {
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitParentPropertyExpression(ParentPropertyExpressionContext ctx) {
    throw 'Not implemented ${ctx.text}';
  }
}
