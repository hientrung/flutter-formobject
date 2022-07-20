import './fofield.dart';
import './foproperty.dart';
import './foobject.dart';
import './folist.dart';
import './foexpression.dart';

///An object contains fields or it can be a field in simple case
///
///All fields has value is nullable
class FOForm {
  final Map<String, dynamic> json;
  late final FOField _root;

  ///Create base on a json contains 'data' and 'meta'
  ///
  ///'data': the current value of object
  ///
  ///'meta': config the object, type, validation rules, something else used to create editor.
  ///It must contains ':root' item to access for root item
  ///
  ///Example:
  ///```
  ///final register = FOForm({
  ///  'data': {'name': '', 'password': '', 'confirm': ''},
  ///  'meta': {
  ///    ':root': {'type': 'object', 'objectType': 'Root'},
  ///    'Root': {
  ///      'name': {'type': 'string', 'rules': [
  ///           {'type': 'required', 'message': 'Required'}
  ///       ]},
  ///      'password': {'type': 'string', 'rules': [
  ///           {'type': 'required', 'message': 'Required'}
  ///       ]},
  ///       'confirm': {'type': 'string', 'rules': [
  ///           {'type': 'required', 'message': 'Required'},
  ///           {'type': 'equal', 'message': 'Not matched', 'expression': '^.password'}
  ///       ]},
  ///   }
  /// }
  ///});
  ///```
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
        case 'expression':
          if (parent == null) {
            throw 'Field expression need parent field used to calcuate base on other fields';
          }
          if (meta['expression'] == null) {
            throw 'Not found key "expression"';
          }
          return FOExpression(
            parent: parent,
            name: name,
            meta: meta,
            expression: meta['expression'],
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

  ///Subscription value changed
  FOSubscription onChanged(FOChangedHandler handler) =>
      _root.onChanged(handler);

  ///Subscription validation status changed
  FOSubscription<FOValidStatus> onStatusChanged(
          FOChangedHandler<FOValidStatus> handler) =>
      _root.onStatusChanged(handler);

  ///Get current value
  dynamic get value => _root.value;

  ///Set current value
  set value(dynamic val) => _root.value = val;

  ///Validate value. Return true if it's valid
  bool validate() => _root.validate();

  ///Current validation is valid or not
  bool get isValid => _root.isValid;

  ///Current status of validation
  FOValidStatus get status => _root.status;

  ///Check value has changed or not
  bool get hasChange => _root.hasChange;

  ///Get list of fields if form is 'list' or 'object'
  Iterable<FOField> get childs => _root.hasChild ? _root.childs : [_root];

  ///Get child field base on index (list) or name (object)
  FOField operator [](dynamic index) => _root.hasChild ? _root[index] : _root;

  ///Current error message of validation
  String? get error => _root.error;

  ///Evaluate an expression base on form context
  dynamic eval(String expression) => _root.eval(expression);

  ///Reset all fields value
  void reset() => _root.reset();

  ///Add an item if form is a 'list'
  FOField addItem(dynamic data) {
    if (_root is! FOList) throw 'Form data is not list field';
    return (_root as FOList).add(data);
  }

  ///Add a property field if form is 'object'
  void addProperty(String name, FOField field) {
    if (_root is! FOObject) throw 'Form data is not object fielld';
    (_root as FOObject).add(name, field);
  }

  ///Release all subscription
  void dispose() => _root.dispose();

  ///Convert to json object
  toJson() => _root.toJson();
}
