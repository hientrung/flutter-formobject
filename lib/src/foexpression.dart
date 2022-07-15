import 'dart:async';

import './fofield.dart';

class FOExpression extends FOField {
  late final dynamic initValue;
  final String expression;
  dynamic _value;
  bool _shouldUpdate = true;
  final Map<FOField, FOSubscription> _valueDepends = {};

  FOExpression({
    required FOField parent,
    required super.name,
    required super.meta,
    required this.expression,
  }) : super(type: FOFieldType.expression, parent: parent);

  @override
  dynamic get value {
    super.value;
    _update();
    return _value;
  }

  @override
  set value(val) {
    throw "Can not set value for a expression, it's readonly";
  }

  @override
  bool get hasChange => value != initValue;

  void _update() {
    if (!_shouldUpdate) return;
    _shouldUpdate = false;

    //run in zone context to get depends
    late dynamic v;
    final newDepends = contextDepends(() => v = parent!.eval(expression));
    _updateValueDepends(newDepends);

    if (v != _value) {
      _value = v;
      notify();
    }
  }

  void _updateValueDepends(List<FOField> newDepends) {
    //remove old
    final removed = _valueDepends.entries
        .where((it) => !newDepends.contains(it.key))
        .toList();
    for (var it in removed) {
      it.value.dispose();
      _valueDepends.remove(it.key);
    }
    //add new
    for (var it in newDepends) {
      if (!_valueDepends.containsKey(it)) {
        _valueDepends[it] = it.onChanged((_) => _listenUpdate());
      }
    }
  }

  void _listenUpdate() {
    if (_shouldUpdate) return;
    _shouldUpdate = true;
    Timer.run(_update);
  }

  @override
  void dispose() {
    for (var it in _valueDepends.values) {
      it.dispose();
    }
    _valueDepends.clear();
    super.dispose();
  }
}
