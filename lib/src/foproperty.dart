import './fofield.dart';

///A field is a primitive value.
class FOProperty<T> extends FOField {
  T _value;
  final T initValue;

  FOProperty({
    super.parent,
    required super.name,
    required super.type,
    required super.meta,
    required this.initValue,
  }) : _value = initValue;

  @override
  T get value {
    super.value;
    return _value;
  }

  @override
  set value(val) {
    if (val is! T) throw 'Can not set value, expected type $T';
    if (val != _value) {
      _value = val;
      notify();
    }
  }

  @override
  void reset() {
    value = initValue;
    super.reset();
  }

  @override
  bool get hasChange => value != initValue;

  @override
  toJson() {
    if (value is DateTime) return (value as DateTime).toIso8601String();
    return value;
  }
}
