import './fofield.dart';
import './foproperty.dart';
import './foobject.dart';
import './folist.dart';

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
            initValue: int.tryParse(data.toString()),
          );
        case 'double':
          return FOProperty<double?>(
            parent: parent,
            name: name,
            type: FOFieldType.double,
            meta: meta,
            initValue: double.tryParse(data.toString()),
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
          String? objectTypeName = meta['objectType'];
          if (objectTypeName == null) throw 'Not found key "objectType"';
          Map<String, dynamic>? objectType = json['meta'][objectTypeName];
          if (objectType == null) throw 'Not found meta type "$objectTypeName"';
          if (data is! Map<String, dynamic>?) {
            throw 'Invalid data type, expected Map object';
          }
          var obj = FOObject(
            parent: parent,
            name: name,
            meta: meta,
          );
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
        case 'list':
          Map<String, dynamic>? itemType = meta['itemType'];
          if (itemType == null) throw 'Not found key "itemType"';
          return FOList(
            parent: parent,
            name: name,
            meta: meta,
            initValue: data ?? [],
            creator: (lst, val) =>
                _createField(lst, 'list-item', val, itemType),
          );
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

  FOSubscription onChanged(FOChangedHandler handler) =>
      _root.onChanged(handler);

  dynamic get value => _root.value;

  set value(dynamic val) => _root.value = val;

  bool validate() => _root.validate();

  bool get isValid => _root.isValid;

  FOValidStatus get status => _root.status;

  bool get hasChange => _root.hasChange;

  Iterable<FOField> get childs => _root.childs;

  FOField operator [](dynamic index) => _root[index];

  String? get error => _root.error;

  dynamic eval(String expression) => _root.eval(expression);

  FOField addItem(dynamic data) {
    if (_root is! FOList) throw 'Form data is not list field';
    return (_root as FOList).add(data);
  }

  void addProperty(String name, FOField field) {
    if (_root is! FOObject) throw 'Form data is not object fielld';
    (_root as FOObject).add(name, field);
  }

  void dispose() => _root.dispose();
}
