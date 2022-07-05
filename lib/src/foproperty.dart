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

  set value(T v) {
    if (v != _value) {
      _value = v;
      notify();
    }
  }

  @override
  void reset() => value = initValue;

  @override
  bool get hasChange => value != initValue;
}
