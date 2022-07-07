import 'package:antlr4/antlr4.dart';
import './fofield.dart';
import './folist.dart';
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
    parser.errorListeners.clear();
    parser.addErrorListener(err);
    final tree = parser.program();
    if (err.hasError) {
      var s =
          '${expr.substring(0, err.errorAt)}<FAILED>${expr.substring(err.errorAt)}';
      throw 'Invalid expression: $s';
    }
    final eval = _FOExpressionVisitor(field);
    return eval.visit(tree);
  }
}

class _FOExpressionError extends BaseErrorListener {
  bool _hasError = false;
  int _errorAt = 0;

  @override
  void syntaxError(
      Recognizer<ATNSimulator> recognizer,
      Object? offendingSymbol,
      int? line,
      int charPositionInLine,
      String msg,
      RecognitionException<IntStream>? e) {
    _hasError = true;
    _errorAt = charPositionInLine;
    super.syntaxError(
        recognizer, offendingSymbol, line, charPositionInLine, msg, e);
  }

  bool get hasError => _hasError;
  int get errorAt => _errorAt;
}

class _FOExpressionVisitor extends ExpressionBaseVisitor<dynamic> {
  FOField field;
  FOField? parent;
  List<FOField>? list;

  bool _throwError = false;

  _FOExpressionVisitor(this.field);

  dynamic rawValue(ParseTree ctx) {
    final v = visit(ctx);
    if (v is FOField) return v.value;
    return v;
  }

  @override
  visit(ParseTree tree) {
    try {
      return super.visit(tree);
    } catch (ex) {
      if (_throwError) throw ex.toString();
      _throwError = true;
      throw 'Can not evaluate expression: ${tree.text}\n$ex';
    }
  }

  @override
  visitProgram(ProgramContext ctx) {
    return rawValue(ctx.expression()!);
  }

  @override
  visitUnaryPlusExpression(UnaryPlusExpressionContext ctx) {
    return rawValue(ctx.expression()!);
  }

  @override
  visitUnaryMinusExpression(UnaryMinusExpressionContext ctx) {
    return -rawValue(ctx.expression()!);
  }

  @override
  visitNotExpression(NotExpressionContext ctx) {
    return !rawValue(ctx.expression()!);
  }

  @override
  visitMultiplicativeExpression(MultiplicativeExpressionContext ctx) {
    final left = rawValue(ctx.expression(0)!);
    final right = rawValue(ctx.expression(1)!);
    if (ctx.MOD() != null) return left % right;
    if (ctx.STAR() != null) return left * right;
    if (ctx.DIV() != null) return left / right;
    if (ctx.POW() != null) return left ^ right;
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitAdditiveExpression(AdditiveExpressionContext ctx) {
    final left = rawValue(ctx.expression(0)!);
    final right = rawValue(ctx.expression(1)!);
    if (ctx.PLUS() != null) return left + right;
    if (ctx.MINUS() != null) return left - right;
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitRelationalExpression(RelationalExpressionContext ctx) {
    final left = rawValue(ctx.expression(0)!);
    final right = rawValue(ctx.expression(1)!);
    if (ctx.GTEQ() != null) return left >= right;
    if (ctx.GTHAN() != null) return left > right;
    if (ctx.LTEQ() != null) return left <= right;
    if (ctx.LTHAN() != null) return left < right;
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitEqualityExpression(EqualityExpressionContext ctx) {
    final left = rawValue(ctx.expression(0)!);
    final right = rawValue(ctx.expression(1)!);
    if (ctx.EQUALS() != null) return left == right;
    if (ctx.NOT_EQUALS() != null) return left != right;
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitLogicalAndExpression(LogicalAndExpressionContext ctx) {
    return rawValue(ctx.expression(0)!) && rawValue(ctx.expression(1)!);
  }

  @override
  visitLogicalOrExpression(LogicalOrExpressionContext ctx) {
    return rawValue(ctx.expression(0)!) || rawValue(ctx.expression(1)!);
  }

  @override
  visitTernaryExpression(TernaryExpressionContext ctx) {
    var c = rawValue(ctx.expression(0)!);
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
    if (c != null) return c.text!.substring(1, c.text!.length - 1);
    c = ctx.DATE_LITERAL();
    if (c != null) {
      return DateTime.parse(c.text!.substring(1, c.text!.length - 1));
    }
    c = ctx.NUM_DOUBLE();
    if (c != null) double.parse(c.text!);
    c = ctx.NUM_INT();
    if (c != null) return int.parse(c.text!);
    if (ctx.THIS() != null) return field;
    if (ctx.POW() != null) return parent ?? field.parent;
    throw 'Not implemented ${ctx.text}';
  }

  @override
  visitIdentifierExpression(IdentifierExpressionContext ctx) {
    return field[ctx.IDENTIFIER()!.text];
  }

  @override
  visitPropertyExpression(PropertyExpressionContext ctx) {
    final left = visit(ctx.expression()!);
    if (left is! FOField) throw '"${ctx.expression()!.text}" is not field';
    return left[ctx.IDENTIFIER()!.text];
  }

  @override
  visitAggregateExpression(AggregateExpressionContext ctx) {
    final lst = visit(ctx.expression(0)!);
    if (lst is! FOList) throw '"${ctx.expression(0)!.text}" is not list';
    //filter
    var cond = ctx.expression(1);
    final res = <FOField>[];
    final oldParent = parent;
    //parent of current list used filter
    parent = lst.parent;
    //quick find function, alway exist if found first valid
    final finder = ctx.find();
    if (cond != null) {
      final oldField = field;
      //do filter items
      for (var it in lst.childs) {
        field = it;
        if (rawValue(cond)) {
          res.add(it);
          if (finder != null) break;
        }
      }
      field = oldField;
    } else {
      res.addAll(lst.childs);
    }

    dynamic v;
    final oldList = list;
    list = res;
    if (finder != null) {
      //find function
      v = visit(finder);
    } else {
      //eval aggregate, parent still available
      v = rawValue(ctx.aggregate()!);
    }
    list = oldList;
    //reset parent
    parent = oldParent;
    return v;
  }

  @override
  visitCountFunction(CountFunctionContext ctx) {
    return list!.length;
  }

  @override
  visitSumFunction(SumFunctionContext ctx) {
    //using parent in AggregateExpressionContext
    final oldField = field;
    var total = 0.0;
    for (var it in list!) {
      field = it;
      total += rawValue(ctx.expression()!);
    }
    field = oldField;
    return total;
  }

  @override
  visitAvgFunction(AvgFunctionContext ctx) {
    //using parent in AggregateExpressionContext
    final oldField = field;
    var total = 0.0;
    int c = 0;
    for (var it in list!) {
      field = it;
      total += rawValue(ctx.expression()!);
      c++;
    }
    field = oldField;
    return c != 0 ? total / c : 0;
  }

  @override
  visitExistFunction(ExistFunctionContext ctx) {
    return list!.isNotEmpty;
  }

  @override
  visitFirstFunction(FirstFunctionContext ctx) {
    return list!.isNotEmpty ? list![0] : null;
  }
}
