import './fofield.dart';

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
  T get value => _value;

  @override
  set value(val) {
    if (val is! T) throw 'Can not set value, expected type $T';
    if (val != _value) {
      _value = val;
      notify();
    }
  }

  @override
  void reset() => value = initValue;

  @override
  bool get hasChange => value != initValue;
}
