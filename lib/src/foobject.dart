import './fofield.dart';

///A field is an object contains child fields that is a nested object or list or a property field
///
///Object notify value changed if there are any changed in any child fields
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
    super.reset();
  }

  @override
  Map<String, dynamic> get value {
    super.value;
    return _items.map((key, value) => MapEntry(key, value.value));
  }

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
  bool get hasChild => true;

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
    for (var it in _items.values) {
      it.dispose();
    }
    _items.clear();
    for (var it in _subs.values) {
      it.dispose();
    }
    _subs.clear();
    super.dispose();
  }

  @override
  toJson() {
    return _items.map((key, value) => MapEntry(key, value.toJson()));
  }

  ///Add new property
  void add(String name, FOField field) {
    if (_items.containsKey(name)) throw '$name already exist';
    _items[name] = field;
    if (subscriptions.isNotEmpty) {
      _subs[name] = _listenChild(field);
    }
  }

  ///Remove a property
  void remove(String name) {
    _items.remove(name);
    _subs[name]?.dispose();
    _subs.remove(name);
  }
}
