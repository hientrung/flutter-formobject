import './fofield.dart';

class FOObject extends FOField {
  final items = <String, FOField>{};

  FOObject({
    super.parent,
    required super.name,
    required super.type,
    required super.meta,
  });

  @override
  void reset() {
    for (var it in items.values) {
      it.reset();
    }
  }

  @override
  Map<String, dynamic> get value =>
      items.map((key, value) => MapEntry(key, value.value));

  @override
  bool get hasChange {
    for (var it in items.values) {
      if (it.hasChange) return true;
    }
    return false;
  }

  @override
  bool get isValid => super.isValid && items.values.every((it) => it.isValid);
}
