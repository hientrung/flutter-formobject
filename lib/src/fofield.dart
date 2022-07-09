import 'dart:async';

import 'expression.dart';
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

class FOSubscription<T> {
  final List<FOSubscription<T>> _sources;
  final FOChangedHandler<T> handler;
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
  final statusSubscriptions = <FOSubscription<FOValidStatus>>[];
  late final FOValidator? validator;
  final FOField? parent;
  FOValidStatus _status = FOValidStatus.pending;
  String _fullName = '';
  String? _error;
  final _depends = <FOField, FOSubscription>{};
  Future<String?>? _validating;

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
    } else if (!hasChild) {
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

  FOSubscription<FOValidStatus> onStatusChanged(
          FOChangedHandler<FOValidStatus> handler) =>
      FOSubscription<FOValidStatus>(statusSubscriptions, handler);

  void notify() {
    if (subscriptions.isEmpty) return;
    final val = value;
    for (var it in subscriptions) {
      it.handler(val);
    }
  }

  void notifyStatus() {
    for (var it in statusSubscriptions) {
      it.handler(_status);
    }
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
    final oldStatus = _status;
    final oldError = _error;
    _validating?.ignore();
    _status = FOValidStatus.validating;

    late FutureOr<String?> res;
    final newDepends = contextDepends(() {
      res = validator!.validate(value);
    });
    _updateDepends(newDepends);

    void completed(String? res) {
      if (res != null && customError != null) {
        _error = customError!(this, res);
      } else {
        _error = res;
      }
      _status = res == null ? FOValidStatus.valid : FOValidStatus.invalid;
      _validating = null;
    }

    if (res is Future<String?>) {
      _validating = res as Future<String?>;
      if (oldStatus != FOValidStatus.validating) notifyStatus();
      _validating!.then((val) {
        completed(val);
        notifyStatus();
      });
    } else {
      completed(res as String?);
      if (_status != oldStatus || _error != oldError) {
        notifyStatus();
      }
    }
  }

  void _updateDepends(List<FOField> newDepends) {
    //remove old
    final removed =
        _depends.entries.where((it) => !newDepends.contains(it.key)).toList();
    for (var it in removed) {
      it.value.dispose();
      _depends.remove(it.key);
    }
    //add new subscription
    for (var it in newDepends) {
      if (!_depends.containsKey(it)) {
        _depends[it] = it.onChanged((_) {
          _doValidate();
        });
      }
    }
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
    } else if (_status == FOValidStatus.pending) {
      _status = FOValidStatus.valid;
    }
    if (hasChild) {
      for (var it in childs) {
        it.validate();
      }
    }
    return isValid;
  }

  Iterable<FOField> get depends => _depends.keys;

  bool get isValid {
    if (_status == FOValidStatus.pending) validate();
    if (!hasChild) return _status == FOValidStatus.valid;
    if (_status != FOValidStatus.valid) return false;
    return childs.every((it) => it.isValid);
  }

  FOValidStatus get status => _status;

  String get fullName => _fullName;

  String? get error {
    if (_status == FOValidStatus.pending) validate();
    return _error;
  }

  bool get hasChild => false;

  FOField operator [](dynamic index) =>
      throw '"$fullName" is not support childs field';

  Iterable<FOField> get childs =>
      throw '"$fullName" is not support childs field';

  dynamic eval(String expression) {
    return evaluate(this, expression);
  }

  ///Run in zone context to get depends
  List<FOField> contextDepends(void Function() run) {
    final List<FOField> lst = [];
    runZonedGuarded(
      run,
      (error, stack) => throw error.toString(),
      zoneValues: {
        'FOFieldDepends': lst,
        'FOFieldCaller': this,
      },
    );
    return lst;
  }

  void dispose() {
    subscriptions.clear();
    statusSubscriptions.clear();
    for (var it in _depends.values) {
      it.dispose();
    }
    _depends.clear();
  }

  static String Function(FOField field, String error)? customError;
  static String Function(List<String> errors)? customErrors;
}
