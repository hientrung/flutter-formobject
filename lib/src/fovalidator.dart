import 'dart:async';

class FOValidator {
  final FutureOr<String?> Function(dynamic value) validate;

  FOValidator(this.validate);

  static FOValidator? fromJson(Map<String, dynamic> meta) {
    var res = <FOValidator>[];
    if (meta.containsKey('required')) {
      res.add(FOValidator.required(meta['required']));
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
    });
  }

  factory FOValidator.required(String message) {
    return FOValidator((value) => value == null ||
            (value is num && value == 0) ||
            (value is String && value == "")
        ? message
        : null);
  }
}
