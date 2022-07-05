import 'dart:async';

typedef FOValidateHandler = FutureOr<String?> Function(dynamic value);

class FOValidator {
  final String? condition;
  final FOValidateHandler validate;

  FOValidator(this.validate, [this.condition]);

  static FOValidator? fromJson(Map<String, dynamic> meta) {
    var res = <FOValidator>[];
    try {
      if (meta.containsKey('required')) {
        res.add(FOValidator.required(
            meta['required']['message'], meta['required']['condition']));
      }
    } catch (ex) {
      throw 'Invalid config validate: $meta. $ex';
    }
    if (res.isEmpty) return null;
    if (res.length == 1) return res[0];
    return FOValidator.all(res);
  }

  factory FOValidator.all(List<FOValidator> validators) {
    return FOValidator((value) {
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

  factory FOValidator.required(String message, [String? condition]) {
    return FOValidator(
        (value) => value == null ||
                (value is num && value == 0) ||
                (value is String && value == "")
            ? message
            : null,
        condition);
  }
}
