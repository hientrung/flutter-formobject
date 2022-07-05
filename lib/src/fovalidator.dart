import 'dart:async';

import 'package:formobject/formobject.dart';

typedef FOValidateHandler = FutureOr<String?> Function(dynamic value);

class FOValidator {
  final String? condition;
  final FOValidateHandler handler;
  final FOField field;

  FOValidator(this.field, this.handler, this.condition);

  FutureOr<String?> validate(dynamic value) {
    var b = true;
    if (condition != null && condition!.isNotEmpty) {
      var c = field.eval(condition!);
      if (c == null ||
          (c is String && c.isEmpty) ||
          (c is num && c == 0) ||
          (c is bool && !c)) {
        b = false;
      }
    }
    if (!b) return null;
    return handler(value);
  }

  static FOValidator? fromJson(FOField field, Map<String, dynamic> meta) {
    var res = <FOValidator>[];
    try {
      if (meta.containsKey('required')) {
        res.add(FOValidator.required(
          field,
          meta['required']['message'],
          meta['required']['condition'],
        ));
      }
      if (meta.containsKey('requiredTrue')) {
        res.add(FOValidator.requiredTrue(
          field,
          meta['requiredTrue']['message'],
          meta['requiredTrue']['condition'],
        ));
      }
      if (meta.containsKey('range')) {
        res.add(FOValidator.range(
          field,
          meta['range']['message'],
          meta['range']['condition'],
          meta['range']['min'],
          meta['range']['max'],
        ));
      }
      if (meta.containsKey('email')) {
        res.add(FOValidator.email(
          field,
          meta['email']['message'],
          meta['email']['condition'],
        ));
      }
      if (meta.containsKey('match')) {
        res.add(FOValidator.match(
          field,
          meta['match']['message'],
          meta['match']['condition'],
          meta['match']['pattern'],
        ));
      }
      if (meta.containsKey('equal')) {
        res.add(FOValidator.equal(
          field,
          meta['equal']['message'],
          meta['equal']['condition'],
          meta['equal']['expression'],
        ));
      }
      if (meta.containsKey('custom')) {
        res.add(FOValidator.custom(
          field,
          meta['custom']['message'],
          meta['custom']['condition'],
          meta['custom']['expression'],
        ));
      }
    } catch (ex) {
      throw 'Invalid config validate: $meta\n$ex';
    }
    if (res.isEmpty) return null;
    if (res.length == 1) return res[0];
    return FOValidator.all(field, res);
  }

  factory FOValidator.all(
    FOField field,
    List<FOValidator> validators,
  ) {
    return FOValidator(field, (value) {
      FutureOr<String?> exec(int ind) {
        if (ind == validators.length) return null;
        var s = validators[ind].validate(value);
        if (s == null) return exec(ind + 1);
        if (s is String) return s;
        if (s is Future<String?>) return s.then((val) => val ?? exec(ind + 1));
        return s; //never return this
      }

      return exec(0);
    }, null);
  }

  factory FOValidator.required(
    FOField field,
    String message,
    String? condition,
  ) {
    return FOValidator(
      field,
      (value) => value == null ||
              (value is num && value == 0) ||
              (value is String && value.isEmpty)
          ? message
          : null,
      condition,
    );
  }

  factory FOValidator.requiredTrue(
    FOField field,
    String message,
    String? condition,
  ) {
    return FOValidator(
      field,
      (value) => value is bool && value == true ? null : message,
      condition,
    );
  }

  factory FOValidator.range(
    FOField field,
    String message,
    String? condition,
    int? min,
    int? max,
  ) {
    return FOValidator(
      field,
      (value) {
        try {
          num l = value is num
              ? value
              : value.length; // number or any object has 'length'
          if (min != null && l < min) return message;
          if (max != null && l > max) return message;
        } catch (_) {}
        return null;
      },
      condition,
    );
  }

  factory FOValidator.email(
    FOField field,
    String message,
    String? condition,
  ) {
    return FOValidator(
      field,
      (value) {
        if (value is String && value.isNotEmpty) {
          String pattern =
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?)*$";
          RegExp regex = RegExp(pattern);
          return regex.hasMatch(value) ? null : message;
        }
        return null;
      },
      condition,
    );
  }

  factory FOValidator.match(
    FOField field,
    String message,
    String? condition,
    String pattern,
  ) {
    return FOValidator(
      field,
      (value) {
        if (value is String && value.isNotEmpty) {
          RegExp regex = RegExp(pattern);
          return regex.hasMatch(value) ? null : message;
        }
        return null;
      },
      condition,
    );
  }

  factory FOValidator.equal(
    FOField field,
    String message,
    String? condition,
    String expression,
  ) {
    return FOValidator(
      field,
      (value) {
        return value == field.eval(expression) ? null : message;
      },
      condition,
    );
  }

  factory FOValidator.custom(
    FOField field,
    String message,
    String? condition,
    String expression,
  ) {
    return FOValidator(
      field,
      (value) {
        var r = field.eval(expression);
        if (r == null ||
            (r is String && r.isEmpty) ||
            (r is num && r == 0) ||
            (r is bool && !r)) return message;
        return null;
      },
      condition,
    );
  }
}
