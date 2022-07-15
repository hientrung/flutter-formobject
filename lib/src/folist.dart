import './fofield.dart';

class FOList extends FOField {
  final List<dynamic> initValue;
  final FOField Function(FOList list, dynamic data) creator;
  final _items = <FOField>[];
  final _subs = <int, FOSubscription>{};

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
    for (var it in _subs.values) {
      it.dispose();
    }
    _subs.clear();
    _items.addAll(values.map((it) => creator(this, it)));
    if (subscriptions.isNotEmpty) {
      for (var it in _items) {
        _subs[it.hashCode] = _listenChild(it);
      }
    }
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
  FOSubscription onChanged(FOChangedHandler handler) {
    if (subscriptions.isEmpty) {
      for (var it in _items) {
        _subs[it.hashCode] = _listenChild(it);
      }
    }
    return super.onChanged(handler);
  }

  FOSubscription _listenChild(FOField field) {
    return field.onChanged((_) {
      notify();
    });
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
    for (var it in _subs.values) {
      it.dispose();
    }
    _subs.clear();
    super.dispose();
  }

  FOField add(dynamic data) {
    var field = creator(this, data);
    _items.add(field);
    if (subscriptions.isNotEmpty) {
      _subs[field.hashCode] = _listenChild(field);
    }
    notify();
    return field;
  }

  void remove(FOField field) {
    _items.remove(field);
    _subs[field.hashCode]?.dispose();
    _subs.remove(field.hashCode);
    notify();
  }
}
