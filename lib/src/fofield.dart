import 'dart:async';

import './fovalidator.dart';

enum FOFieldType {
  string,
  int,
  double,
  bool,
  datetime,
  object,
  array,
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
  final FOValidator? validator;
  final FOField? parent;
  FOValidStatus _status = FOValidStatus.pending;
  bool _notifying = false;
  String _fullName = '';

  FOField({
    this.parent,
    required this.name,
    required this.type,
    required this.meta,
  }) : validator = FOValidator.fromJson(meta) {
    //validate on changed value
    if (validator != null) {
      onChanged((_) {
        _doValidate();
      });
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
    _notifying = true;
    for (var it in subscriptions) {
      it.handler(value);
    }
    _notifying = false;
  }

  dynamic get value;

  set value(dynamic val);

  void reset();

  bool get hasChange;

  void _doValidate() {
    final old = _status;
    _status = FOValidStatus.validating;
    var s = validator!.validate(value);
    void completed(String? res) {
      _status = res == null ? FOValidStatus.valid : FOValidStatus.invalid;
      if (!_notifying &&
          ((old == FOValidStatus.pending && _status == FOValidStatus.invalid) ||
              (old != FOValidStatus.pending && old != _status))) {
        notify();
      }
    }

    if (s is Future<String?>) {
      s.then((val) => completed(val));
    } else {
      completed(s);
    }
  }

  bool validate() {
    if (_status == FOValidStatus.pending) {
      if (validator != null) {
        _doValidate();
      } else {
        _status = FOValidStatus.valid;
      }
    }
    return isValid;
  }

  bool get isValid => _status == FOValidStatus.pending
      ? validate()
      : _status == FOValidStatus.valid;

  FOValidStatus get status => _status;

  String get fullName => _fullName;

  FOField operator [](dynamic index) =>
      throw '"$fullName" is not support childs field';

  Iterable<FOField> get childs =>
      throw '"$fullName" is not support childs field';

  void dispose() {
    subscriptions.clear();
  }
}
