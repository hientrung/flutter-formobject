import 'package:formobject/src/foobject.dart';

import './fofield.dart';
import './foproperty.dart';

class FOForm {
  final Map<String, dynamic> json;
  late final FOField _root;

  FOForm(this.json) {
    if (!json.containsKey('data')) {
      throw 'Not found key "data" in json';
    }
    if (!json.containsKey('meta')) {
      throw 'Not found key "meta" in json';
    }
    Map<String, dynamic> meta = json['meta'];
    if (!meta.containsKey(':root')) {
      throw 'Not found key ":root" object in meta data';
    }
    _root = _createField(null, '', json['data'], meta[':root']);
  }

  FOField _createField(
      FOField? parent, String name, dynamic data, Map<String, dynamic> meta) {
    try {
      String? type = meta['type'];
      switch (type) {
        case 'string':
          return FOProperty<String?>(
            parent: parent,
            name: name,
            type: FOFieldType.string,
            meta: meta,
            initValue: data,
          );
        case 'int':
          return FOProperty<int?>(
            parent: parent,
            name: name,
            type: FOFieldType.int,
            meta: meta,
            initValue: data,
          );
        case 'double':
          return FOProperty<double?>(
            parent: parent,
            name: name,
            type: FOFieldType.double,
            meta: meta,
            initValue: data,
          );
        case 'bool':
          return FOProperty<bool?>(
            parent: parent,
            name: name,
            type: FOFieldType.bool,
            meta: meta,
            initValue: data,
          );
        case 'datetime':
          return FOProperty<DateTime?>(
            parent: parent,
            name: name,
            type: FOFieldType.datetime,
            meta: meta,
            initValue: data,
          );
        case 'object':
          var obj = FOObject(
            parent: parent,
            name: name,
            type: FOFieldType.object,
            meta: meta,
          );
          String? valTypeName = meta['valueType'];
          if (valTypeName == null) throw 'Not found key "valueType"';
          Map<String, dynamic>? valType = json['meta'][valTypeName];
          if (valType == null) throw 'Not found meta type "$valTypeName"';
          for (var it in valType.entries) {
            obj.items[it.key] = _createField(
                obj, it.key, data == null ? null : data[it.key], it.value);
          }
          return obj;
        default:
          throw 'Not support type: $type';
      }
    } catch (ex) {
      throw 'Can not create field "${parent != null ? "${parent.fullName}.$name" : name}": ${ex.toString()}';
    }
  }

  dynamic get value => _root.value;

  bool validate() => _root.validate();

  bool get isValid => _root.isValid;

  FOValidStatus get status => _root.status;

  bool get hasChange => _root.hasChange;

  T getField<T extends FOField>(String name) {
    if (name.isEmpty) return _root as T;
    throw 'Not found field: $name';
  }

  FOProperty<T?> getProperty<T>(String name) {
    return getField<FOProperty<T?>>(name);
  }
}
