import './fofield.dart';

class FOObject extends FOField {
  final _items = <String, FOField>{};
  final _subs = <String, FOSubscription>{};
  bool _reseting = false;
  bool _resetingNotify = false;

  FOObject({
    super.parent,
    required super.name,
    required super.meta,
  }) : super(type: FOFieldType.object);

  @override
  void reset() {
    _reseting = true;
    for (var it in _items.values) {
      it.reset();
    }
    _reseting = false;
    if (_resetingNotify) {
      notify();
      _resetingNotify = false;
    }
  }

  @override
  Map<String, dynamic> get value =>
      _items.map((key, value) => MapEntry(key, value.value));

  @override
  set value(val) {
    if (val is! Map<String, dynamic>) {
      throw 'Can not set value, expected type Map';
    }
    _reseting = true;
    for (var it in val.entries) {
      _items[it.key]?.value = it.value;
    }
    _reseting = false;
    if (_resetingNotify) {
      notify();
      _resetingNotify = false;
    }
  }

  @override
  bool get hasChange {
    for (var it in _items.values) {
      if (it.hasChange) return true;
    }
    return false;
  }

  @override
  bool get isValid => super.isValid && _items.values.every((it) => it.isValid);

  @override
  Iterable<FOField> get childs => _items.values;

  @override
  FOField operator [](dynamic index) {
    if (index is! String) {
      throw 'Index should be String';
    }
    if (!_items.containsKey(index)) {
      throw 'Not found ${fullName.isNotEmpty ? "$fullName.$index" : index}';
    }
    return _items[index]!;
  }

  @override
  FOSubscription onChanged(FOChangedHandler handler) {
    if (subscriptions.isEmpty) {
      for (var it in _items.values) {
        _subs[it.name] = _listenChild(it);
      }
    }
    return super.onChanged(handler);
  }

  FOSubscription _listenChild(FOField field) {
    return field.onChanged((_) {
      if (_reseting) {
        _resetingNotify = true;
        return;
      }
      notify();
    });
  }

  @override
  String? get error {
    var errs = <String>[];
    var e = super.error;
    if (e != null) errs.add(e);
    for (var it in _items.values) {
      e = it.error;
      if (e != null) errs.add(e);
    }
    if (errs.isEmpty) return null;
    if (FOField.customErrors != null) return FOField.customErrors!(errs);
    return errs.join('; ');
  }

  @override
  void dispose() {
    _items.clear();
    _subs.clear();
    super.dispose();
  }

  void add(String name, FOField field) {
    if (_items.containsKey(name)) throw '$name already exist';
    _items[name] = field;
    if (subscriptions.isNotEmpty) {
      _subs[name] = _listenChild(field);
    }
  }

  void remove(String name) {
    _items.remove(name);
    _subs[name]?.dispose();
    _subs.remove(name);
  }
}
