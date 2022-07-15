import './fofield.dart';

class FOList extends FOField {
  final List<dynamic> initValue;
  final FOField Function(FOList list, dynamic data) creator;
  final _items = <FOField>[];

  FOList({
    super.parent,
    required super.name,
    required super.meta,
    required this.initValue,
    required this.creator,
  }) : super(type: FOFieldType.list) {
    _items.addAll(initValue.map((it) => creator(this, it)));
  }

  void _reset(List<dynamic> values) {
    var old = value.toString();
    _items.clear();
    _items.addAll(values.map((it) => creator(this, it)));
    var s = value.toString();
    if (old != s) notify();
  }

  @override
  void reset() {
    _reset(initValue);
    super.reset();
  }

  @override
  List<dynamic> get value {
    super.value;
    return _items.map((e) => e.value).toList();
  }

  @override
  set value(val) {
    if (val is! List<dynamic>) {
      throw 'Can not set value, expected type List';
    }
    _reset(val);
  }

  @override
  bool get hasChange {
    return initValue.toString() != value.toString();
  }

  @override
  bool get hasChild => true;

  @override
  Iterable<FOField> get childs => _items;

  @override
  FOField operator [](dynamic index) {
    if (index is! int) {
      throw 'Index should be integer number';
    }
    return _items[index];
  }

  @override
  String? get error {
    var errs = <String>[];
    var e = super.error;
    if (e != null) errs.add(e);
    for (var it in _items) {
      e = it.error;
      if (e != null) errs.add(e);
    }
    if (errs.isEmpty) return null;
    if (FOField.customErrors != null) return FOField.customErrors!(errs);
    return errs.join('; ');
  }

  @override
  void dispose() {
    for (var it in _items) {
      it.dispose();
    }
    _items.clear();
    super.dispose();
  }

  @override
  toJson() {
    return _items.map((e) => e.toJson()).toList();
  }

  FOField add(dynamic data) {
    var field = creator(this, data);
    _items.add(field);
    notify();
    return field;
  }

  void remove(FOField field) {
    _items.remove(field);
    notify();
  }
}
