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
          String? objectTypeName = meta['objectType'];
          if (objectTypeName == null) throw 'Not found key "objectType"';
          Map<String, dynamic>? objectType = json['meta'][objectTypeName];
          if (objectType == null) throw 'Not found meta type "$objectTypeName"';
          if (data is! Map<String, dynamic>?) {
            throw 'Invalid data type, expected Map object';
          }
          for (var it in objectType.entries) {
            obj.add(
                it.key,
                _createField(
                  obj,
                  it.key,
                  data == null ? null : data[it.key],
                  it.value,
                ));
          }
          return obj;
        default:
          throw 'Not support type: $type';
      }
    } catch (ex) {
      if (parent == null) {
        throw 'Can not create form data\n$ex';
      }
      throw 'Can not create field "${parent.fullName.isNotEmpty ? "${parent.fullName}.$name" : name}"\n$ex';
    }
  }

  void onChanged(FOChangedHandler handler) => _root.onChanged(handler);

  dynamic get value => _root.value;

  set value(dynamic val) => _root.value = val;

  bool validate() => _root.validate();

  bool get isValid => _root.isValid;

  FOValidStatus get status => _root.status;

  bool get hasChange => _root.hasChange;

  Iterable<FOField> get childs => _root.childs;

  FOField operator [](dynamic index) => _root[index];
}
