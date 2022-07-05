import './fofield.dart';

class FOObject extends FOField {
  final _items = <String, FOField>{};
  final _subs = <String, FOSubscription>{};

  FOObject({
    super.parent,
    required super.name,
    required super.type,
    required super.meta,
  });

  @override
  void reset() {
    for (var it in _items.values) {
      it.reset();
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
    for (var it in val.entries) {
      _items[it.key]?.value = it.value;
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
    if (!_items.containsKey(index)) {
      throw 'Not found ${fullName.isNotEmpty ? "$fullName.$index" : "$index"}';
    }
    return _items[index]!;
  }

  void add(String name, FOField field) {
    if (_items.containsKey(name)) throw '$name already exist';
    _items[name] = field;
    _subs[name] = field.onChanged((value) {
      notify();
    });
  }

  void remove(String name) {
    _items.remove(name);
    _subs[name]?.dispose();
    _subs.remove(name);
  }
}
