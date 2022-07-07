// Generated from F:\Trung\MyGit\formobject\lib\src\antlr4\Expression.g4 by ANTLR 4.10.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'ExpressionParser.dart';

/// This abstract class defines a complete generic visitor for a parse tree
/// produced by [ExpressionParser].
///
/// [T] is the eturn type of the visit operation. Use `void` for
/// operations with no return type.
abstract class ExpressionVisitor<T> extends ParseTreeVisitor<T> {
  /// Visit a parse tree produced by [ExpressionParser.program].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitProgram(ProgramContext ctx);

  /// Visit a parse tree produced by the {@code ParenthesizedExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitParenthesizedExpression(ParenthesizedExpressionContext ctx);

  /// Visit a parse tree produced by the {@code AdditiveExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAdditiveExpression(AdditiveExpressionContext ctx);

  /// Visit a parse tree produced by the {@code RelationalExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRelationalExpression(RelationalExpressionContext ctx);

  /// Visit a parse tree produced by the {@code TernaryExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTernaryExpression(TernaryExpressionContext ctx);

  /// Visit a parse tree produced by the {@code LogicalAndExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLogicalAndExpression(LogicalAndExpressionContext ctx);

  /// Visit a parse tree produced by the {@code ConstantExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitConstantExpression(ConstantExpressionContext ctx);

  /// Visit a parse tree produced by the {@code LogicalOrExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLogicalOrExpression(LogicalOrExpressionContext ctx);

  /// Visit a parse tree produced by the {@code NotExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNotExpression(NotExpressionContext ctx);

  /// Visit a parse tree produced by the {@code AggregateExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAggregateExpression(AggregateExpressionContext ctx);

  /// Visit a parse tree produced by the {@code IdentifierExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIdentifierExpression(IdentifierExpressionContext ctx);

  /// Visit a parse tree produced by the {@code UnaryMinusExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitUnaryMinusExpression(UnaryMinusExpressionContext ctx);

  /// Visit a parse tree produced by the {@code UnaryPlusExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitUnaryPlusExpression(UnaryPlusExpressionContext ctx);

  /// Visit a parse tree produced by the {@code PropertyExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitPropertyExpression(PropertyExpressionContext ctx);

  /// Visit a parse tree produced by the {@code EqualityExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitEqualityExpression(EqualityExpressionContext ctx);

  /// Visit a parse tree produced by the {@code MultiplicativeExpression}
  /// labeled alternative in {@link ExpressionParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitMultiplicativeExpression(MultiplicativeExpressionContext ctx);

  /// Visit a parse tree produced by the {@code CountFunction}
  /// labeled alternative in {@link ExpressionParser#aggregate}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCountFunction(CountFunctionContext ctx);

  /// Visit a parse tree produced by the {@code SumFunction}
  /// labeled alternative in {@link ExpressionParser#aggregate}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSumFunction(SumFunctionContext ctx);

  /// Visit a parse tree produced by the {@code AvgFunction}
  /// labeled alternative in {@link ExpressionParser#aggregate}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAvgFunction(AvgFunctionContext ctx);

  /// Visit a parse tree produced by the {@code ExistFunction}
  /// labeled alternative in {@link ExpressionParser#find}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExistFunction(ExistFunctionContext ctx);

  /// Visit a parse tree produced by the {@code FirstFunction}
  /// labeled alternative in {@link ExpressionParser#find}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitFirstFunction(FirstFunctionContext ctx);

  /// Visit a parse tree produced by [ExpressionParser.constant].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitConstant(ConstantContext ctx);
}