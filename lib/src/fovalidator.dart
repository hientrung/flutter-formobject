import 'dart:async';

import './fofield.dart';
import './foobject.dart';

///Callback function to validate a value. Return null if value is valid
typedef FOValidateHandler = FutureOr<String?> Function(dynamic value);

///Callback function used to validate in async validation
typedef FORequestHandler = Future<dynamic> Function(
    String url, dynamic value, Map<String, dynamic> data);

///Base class for validate value of field
///
///If it has condition, then it will be check condition should return true
///before run validate
class FOValidator {
  ///An expression string should return true before run validate
  final String? condition;

  ///Function to validate value. This function must return FutureOr<String?>
  ///
  ///If return null then valid, else result string used as error message
  final FOValidateHandler handler;

  ///Field use this validation
  final FOField field;

  ///Create a validator for a field
  FOValidator(this.field, this.handler, this.condition);

  ///Validate value
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

  ///Implement the request to validate by call a service in server side
  ///
  ///The result should be a boolean, true mean valid, else it use 'message' to response
  ///
  ///Or the result is string that used for 'message', if string is empty then the value is valid
  static FORequestHandler? requestHandler;

  ///Create a validator from a json config
  static FOValidator? fromJson(FOField field, Map<String, dynamic> meta) {
    var res = <FOValidator>[];
    try {
      List<dynamic>? rules = meta['rules'];
      if (rules != null) {
        for (Map<String, dynamic> it in rules) {
          var type = it['type'];
          switch (type) {
            case 'required':
              res.add(FOValidator.required(
                field,
                it['message'],
                it['condition'],
              ));
              break;
            case 'requiredTrue':
              res.add(FOValidator.requiredTrue(
                field,
                it['message'],
                it['condition'],
              ));
              break;
            case 'range':
              res.add(FOValidator.range(
                field,
                it['message'],
                it['condition'],
                it['min'],
                it['max'],
              ));
              break;
            case 'email':
              res.add(FOValidator.email(
                field,
                it['message'],
                it['condition'],
              ));
              break;
            case 'match':
              res.add(FOValidator.match(
                field,
                it['message'],
                it['condition'],
                it['pattern'],
              ));
              break;
            case 'equal':
              res.add(FOValidator.equal(
                field,
                it['message'],
                it['condition'],
                it['expression'],
              ));
              break;
            case 'expression':
              res.add(FOValidator.expression(
                field,
                it['message'],
                it['condition'],
                it['expression'],
              ));
              break;
            case 'service':
              res.add(FOValidator.service(
                field,
                it['message'],
                it['condition'],
                it['url'],
                it['fieldNames'] ?? <String>[],
                it['debounce'] ?? 1,
              ));
              break;
            default:
              throw 'Not supported rule type "$type"';
          }
        }
      }
    } catch (ex) {
      throw 'Invalid config validate: $meta\n$ex';
    }
    if (res.isEmpty) return null;
    if (res.length == 1) return res[0];
    return FOValidator.all(field, res);
  }

  ///Check all validation. Return if the first invalid
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

  ///Validate a value must be not null, not equal 0, or not empty string
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

  ///Validate value must be 'true'
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

  ///Validate value must be in range.
  ///
  ///If value is number then it should be >=min and <=max
  ///
  ///If value is a list/object then the 'length' property shoud be >=min and <=max
  ///
  ///If min or max = null then validation will be ignore check it
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

  ///Validate value in case it is not empty and must be a email address
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

  ///Validate value in case it is not empty and must be match the regular expression
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

  ///Validate value must be equal with value of expression
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

  ///Vaidate value by an expression that has result valie is not null,
  ///not empty string, not zero or must be true
  factory FOValidator.expression(
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

  ///Validate value by an async process.
  ///Require implement function Validator.requestHandler to process async validation
  factory FOValidator.service(FOField field, String message, String? condition,
      String url, List<String> fieldNames, int debounce) {
    if (requestHandler == null) {
      throw 'Need implement FOValidator.requestHandler to call validate via service';
    }
    Timer? timer;
    return FOValidator(
      field,
      (value) {
        if (timer != null) timer!.cancel();
        final result = Completer<String?>();
        timer = Timer(Duration(seconds: debounce), () {
          //get data fields;
          final data = <String, dynamic>{};
          if (fieldNames.isNotEmpty) {
            FOField? cur = field;
            while (cur is! FOObject && cur != null) {
              cur = cur.parent;
            }
            if (cur == null) {
              throw 'Not found object field to get value of "fieldNames"';
            }
            for (var f in fieldNames) {
              data[f] = cur.eval(f);
            }
          }
          //post to service
          requestHandler!(url, value, data).then((res) {
            if (res == null) {
              result.complete(null);
            } else if (res is bool) {
              result.complete(res ? null : message);
            } else if (res is String) {
              result.complete(res.isEmpty ? null : res);
            } else {
              throw 'Only support result from service is boolean or string';
            }
          });
        });
        return result.future;
      },
      condition,
    );
  }
}
