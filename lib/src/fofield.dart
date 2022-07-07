import 'dart:async';

import './foexpression.dart';
import './fovalidator.dart';

enum FOFieldType {
  string,
  int,
  double,
  bool,
  datetime,
  object,
  list,
  expression,
}

enum FOValidStatus {
  invalid,
  valid,
  validating,
  pending,
}

typedef FOChangedHandler<T> = void Function(T value);

class FOSubscription {
  final List<FOSubscription> _sources;
  final FOChangedHandler handler;
  FOSubscription(this._sources, this.handler) {
    _sources.add(this);
  }
  void dispose() => _sources.remove(this);
}

abstract class FOField {
  final String name;
  final FOFieldType type;
  final Map<String, dynamic> meta;
  final subscriptions = <FOSubscription>[];
  final depends = <FOField>[];
  late final FOValidator? validator;
  final FOField? parent;
  FOValidStatus _status = FOValidStatus.pending;
  bool _notifying = false;
  String _fullName = '';
  String? _error;
  final _subDepends = <String, FOSubscription>{};

  FOField({
    this.parent,
    required this.name,
    required this.type,
    required this.meta,
  }) {
    validator = FOValidator.fromJson(this, meta);
    //validate on changed value
    if (validator != null) {
      onChanged((_) {
        _doValidate();
      });
    } else {
      _status = FOValidStatus.valid;
    }
    //combine full name
    var names = <String>[name];
    var p = parent;
    while (p != null && p.name.isNotEmpty) {
      names.insert(0, p.name);
      p = p.parent;
    }
    _fullName = names.join('.');
  }

  FOSubscription onChanged(FOChangedHandler handler) =>
      FOSubscription(subscriptions, handler);

  void notify() {
    if (subscriptions.isEmpty) return;
    _notifying = true;
    final val = value;
    for (var it in subscriptions) {
      it.handler(val);
    }
    _notifying = false;
  }

  ///Get current value of field
  ///
  ///Inherited class should implement and call supper before return value
  dynamic get value {
    _addDepend();
  }

  set value(dynamic val);

  void reset();

  bool get hasChange;

  void _doValidate() {
    final vd = validator!;
    final old = _status;
    _status = FOValidStatus.validating;

    //run in validate context to get depends
    final newDepends = <FOField>[];
    final s = runZonedGuarded<FutureOr<String?>>(
        () => vd.validate(value), (error, stack) => throw error.toString(),
        zoneValues: {
          'FOFieldDepends': newDepends,
          'FOFieldCaller': this,
        });
    _updateDepends(newDepends);

    void completed(String? res) {
      if (res != null && customError != null) {
        _error = customError!(this, res);
      } else {
        _error = res;
      }
      _status = res == null ? FOValidStatus.valid : FOValidStatus.invalid;
      if (!_notifying &&
          ((old == FOValidStatus.pending && _status == FOValidStatus.invalid) ||
              (old != FOValidStatus.pending && old != _status))) {
        notify();
      }
    }

    if (s != null && s is Future<String?>) {
      s.then((val) => completed(val));
    } else {
      completed(s as String?);
    }
  }

  void _updateDepends(List<FOField> newDepends) {
    //remove subscription
    for (var it in depends) {
      if (!newDepends.contains(it)) {
        _subDepends[it.fullName]!.dispose();
        _subDepends.remove(it.fullName);
      }
    }
    //add new subscription
    for (var it in newDepends) {
      if (!depends.contains(it)) {
        _subDepends[it.fullName] = it.onChanged((_) {
          _doValidate();
        });
      }
    }
    //update list
    depends.clear();
    depends.addAll(newDepends);
  }

  void _addDepend() {
    final cur = Zone.current['FOFieldDepends'];
    final caller = Zone.current['FOFieldCaller'];
    if (cur != null &&
        caller != null &&
        this != caller &&
        cur is List<FOField> &&
        !cur.contains(this)) {
      cur.add(this);
    }
  }

  bool validate() {
    if (_status == FOValidStatus.pending && validator != null) {
      _doValidate();
    }
    return isValid;
  }

  bool get isValid => _status == FOValidStatus.pending
      ? validate()
      : _status == FOValidStatus.valid;

  FOValidStatus get status => _status;

  String get fullName => _fullName;

  String? get error {
    if (_status == FOValidStatus.pending) validate();
    return _error;
  }

  FOField operator [](dynamic index) =>
      throw '"$fullName" is not support childs field';

  Iterable<FOField> get childs =>
      throw '"$fullName" is not support childs field';

  dynamic eval(String expression) {
    final expr = FOExpression(this);
    return expr.eval(expression);
  }

  void dispose() {
    subscriptions.clear();
    for (var it in _subDepends.values) {
      it.dispose();
    }
    _subDepends.clear();
    depends.clear();
  }

  static String Function(FOField field, String error)? customError;
  static String Function(List<String> errors)? customErrors;
}
